//
//  NetworkJSONOperationTestCase.swift
//  Albums
//
//  Created by Rick van Voorden on 10/22/14.
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

var NetworkJSONOperation_JSONHandlerTestDouble_Error: NSError?

var NetworkJSONOperation_JSONHandlerTestDouble_JSON: NSObject?

var NetworkJSONOperation_JSONHandlerTestDouble_Response: INV_NetworkResponse?

final class NetworkJSONOperation_JSONHandlerTestDouble: NSObject, INV_NetworkJSONOperation_JSONHandlerType {
    
    class func jsonWithResponse(response: INV_NetworkResponse, error: NSErrorPointer) -> AnyObject? {
        
        NetworkJSONOperation_JSONHandlerTestDouble_Response = response
        
        if error != nil {
            
            error.memory = NetworkJSONOperation_JSONHandlerTestDouble_Error
            
        }
        
        return NetworkJSONOperation_JSONHandlerTestDouble_JSON
        
    }
    
}

final class NetworkJSONOperation_TaskTestDouble: NSObject, INV_NetworkJSONOperation_TaskType {
    
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

final class NetworkJSONOperationTestCase: XCTestCase {
    
    lazy var data = DataTestDouble()
    
    lazy var error = ErrorTestDouble()
    
    lazy var operation = NetworkJSONOperationTestDouble()
    
    var operationTask: NetworkJSONOperation_TaskTestDouble {
        
        return (self.operation.task as NetworkJSONOperation_TaskTestDouble)
        
    }
    
    lazy var request = RequestTestDouble()
    
    lazy var response = ResponseTestDouble()
    
    override func tearDown() {
        
        NetworkJSONOperation_JSONHandlerTestDouble_Error = nil
        
        NetworkJSONOperation_JSONHandlerTestDouble_JSON = nil
        
        NetworkJSONOperation_JSONHandlerTestDouble_Response = nil
        
    }
    
}

extension NetworkJSONOperationTestCase {
    
    func testCancel() {
        
        self.operation.startWithRequest(nil, completionHandler: nil)
        
        let task = self.operationTask
        
        self.operation.cancel()
        
        XCTAssertTrue(task.didCancel)
        
    }
    
}

extension NetworkJSONOperationTestCase {
    
    func testClass() {
        
        XCTAssertTrue(INV_NetworkJSONOperation.jsonHandlerClass()! === INV_NetworkJSONHandler.self)
        
        XCTAssertTrue(INV_NetworkJSONOperation.taskClass()! === INV_NetworkTask.self)
        
    }
    
}

extension NetworkJSONOperationTestCase {
    
    func testStart() {
        
        NetworkJSONOperation_JSONHandlerTestDouble_Error = ErrorTestDouble()
        
        NetworkJSONOperation_JSONHandlerTestDouble_JSON = NSObject()
        
        var didStart = false
        
        self.operation.startWithRequest(self.request) {(json, error) in
            
            didStart = true
            
            XCTAssertTrue(json! === NetworkJSONOperation_JSONHandlerTestDouble_JSON)
            
            XCTAssertTrue(error! === NetworkJSONOperation_JSONHandlerTestDouble_Error)
            
        }
        
        XCTAssertTrue(self.operationTask.request! === self.request)
        
        self.operationTask.completionHandler!(self.data, self.response, self.error)
        
        XCTAssertTrue(NetworkJSONOperation_JSONHandlerTestDouble_Response!.data! === self.data)
        
        XCTAssertTrue(NetworkJSONOperation_JSONHandlerTestDouble_Response!.error! === self.error)
        
        XCTAssertTrue(NetworkJSONOperation_JSONHandlerTestDouble_Response!.response! === self.response)
        
        XCTAssertTrue(didStart)
        
    }
    
}

final class NetworkJSONOperationTestDouble: INV_NetworkJSONOperation {
    
    override class func jsonHandlerClass() -> AnyClass {
        
        return NetworkJSONOperation_JSONHandlerTestDouble.self
        
    }
    
    override class func taskClass() -> AnyClass {
        
        return NetworkJSONOperation_TaskTestDouble.self
        
    }
    
}
