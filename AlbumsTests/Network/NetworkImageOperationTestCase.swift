//
//  NetworkImageOperationTestCase.swift
//  Albums
//
//  Created by Rick van Voorden on 10/27/14.
//  Copyright (c) 2015 eBay Software Foundation.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import XCTest

var NetworkImageOperation_ImageHandlerTestDouble_Error: NSError?

var NetworkImageOperation_ImageHandlerTestDouble_Image: NSObject?

var NetworkImageOperation_ImageHandlerTestDouble_Response: INV_NetworkResponse?

final class NetworkImageOperation_ImageHandlerTestDouble: NSObject, INV_NetworkImageOperation_ImageHandlerType {
    
    class func imageWithResponse(response: INV_NetworkResponse, error: NSErrorPointer) -> AnyObject? {
        
        NetworkImageOperation_ImageHandlerTestDouble_Response = response
        
        if error != nil {
            
            error.memory = NetworkImageOperation_ImageHandlerTestDouble_Error
            
        }
        
        return NetworkImageOperation_ImageHandlerTestDouble_Image
        
    }
    
}

final class NetworkImageOperation_TaskTestDouble: NSObject, INV_NetworkImageOperation_TaskType {
    
    var completionHandler: INV_NetworkSession_SessionType_CompletionHandler?
    
    var didCancel = false
    
    var request: NSURLRequest?
    
    func cancel() {
        
        self.didCancel = true
        
    }
    
    func startWithRequest(request: NSURLRequest, completionHandler: INV_NetworkSession_SessionType_CompletionHandler) {
        
        self.request = request
        
        self.completionHandler = completionHandler
        
    }
    
}

final class NetworkImageOperationTestCase: XCTestCase {
    
    lazy var data = DataTestDouble()
    
    lazy var error = ErrorTestDouble()
    
    lazy var operation = NetworkImageOperationTestDouble()
    
    var operationTask: NetworkImageOperation_TaskTestDouble {
        
        return (self.operation.task as! NetworkImageOperation_TaskTestDouble)
        
    }
    
    lazy var request = RequestTestDouble()
    
    lazy var response = ResponseTestDouble()
    
    override func tearDown() {
        
        NetworkImageOperation_ImageHandlerTestDouble_Error = nil
        
        NetworkImageOperation_ImageHandlerTestDouble_Image = nil
        
        NetworkImageOperation_ImageHandlerTestDouble_Response = nil
        
    }
    
}

extension NetworkImageOperationTestCase {
    
    func testCancel() {
        
        self.operation.startWithRequest(nil, completionHandler: nil)
        
        let task = self.operationTask
        
        self.operation.cancel()
        
        XCTAssertTrue(task.didCancel)
        
    }
    
}

extension NetworkImageOperationTestCase {
    
    func testClass() {
        
        XCTAssertTrue(INV_NetworkImageOperation.imageHandlerClass()! === INV_NetworkImageHandler.self)
        
        XCTAssertTrue(INV_NetworkImageOperation.taskClass()! === INV_NetworkTask.self)
        
    }
    
}

extension NetworkImageOperationTestCase {
    
    func testStart() {
        
        NetworkImageOperation_ImageHandlerTestDouble_Error = ErrorTestDouble()
        
        NetworkImageOperation_ImageHandlerTestDouble_Image = NSObject()
        
        var didStart = false
        
        self.operation.startWithRequest(self.request) {(image, error) in
            
            didStart = true
            
            XCTAssertTrue(image! === NetworkImageOperation_ImageHandlerTestDouble_Image)
            
            XCTAssertTrue(error! === NetworkImageOperation_ImageHandlerTestDouble_Error)
            
        }
        
        XCTAssertTrue(self.operationTask.request! === self.request)
        
        self.operationTask.completionHandler!(self.data, self.response, self.error)
        
        XCTAssertTrue(NetworkImageOperation_ImageHandlerTestDouble_Response!.data! === self.data)
        
        XCTAssertTrue(NetworkImageOperation_ImageHandlerTestDouble_Response!.error! === self.error)
        
        XCTAssertTrue(NetworkImageOperation_ImageHandlerTestDouble_Response!.response! === self.response)
        
        XCTAssertTrue(didStart)
        
    }
    
}

final class NetworkImageOperationTestDouble: INV_NetworkImageOperation {
    
    override class func imageHandlerClass() -> AnyClass {
        
        return NetworkImageOperation_ImageHandlerTestDouble.self
        
    }
    
    override class func taskClass() -> AnyClass {
        
        return NetworkImageOperation_TaskTestDouble.self
        
    }
    
}
