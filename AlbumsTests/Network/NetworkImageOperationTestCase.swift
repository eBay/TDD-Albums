//
//  NetworkImageOperationTestCase.swift
//  Albums
//
//  Created by Rick van Voorden on 3/2/15.
//  Copyright (c) 2015 eBay Software Foundation. All rights reserved.
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

var NetworkImageOperation_ImageHandlerTestDouble_Response: TDD_NetworkResponse?

final class NetworkImageOperation_ImageHandlerTestDouble: NSObject, TDD_NetworkImageOperation_ImageHandlerType {
    
    class func imageWithResponse(response: TDD_NetworkResponse, error: NSErrorPointer) -> AnyObject? {
        
        NetworkImageOperation_ImageHandlerTestDouble_Response = response
        
        if error != nil {
            
            error.memory = NetworkImageOperation_ImageHandlerTestDouble_Error
            
        }
        
        return NetworkImageOperation_ImageHandlerTestDouble_Image
        
    }
    
}

var NetworkImageOperation_TaskTestDouble_Self: NetworkImageOperation_TaskTestDouble?

final class NetworkImageOperation_TaskTestDouble: NSObject, TDD_NetworkImageOperation_TaskType {
    
    override init() {
        
        super.init()
        
        NetworkImageOperation_TaskTestDouble_Self = self
        
    }
    
    var completionHandler: TDD_NetworkTask_CompletionHandler?
    
    var didCancel = false
    
    var request: NSURLRequest?
    
    func cancel() {
        
        self.didCancel = true
        
    }
    
    func startWithRequest(request: NSURLRequest, completionHandler: TDD_NetworkTask_CompletionHandler) {
        
        self.request = request
        
        self.completionHandler = completionHandler
        
    }
    
}

final class NetworkImageOperationTestCase: XCTestCase {
    
    lazy var operation = NetworkImageOperationTestDouble()
    
    lazy var request = RequestTestDouble()
    
    override func tearDown() {
        
        NetworkImageOperation_ImageHandlerTestDouble_Error = nil
        
        NetworkImageOperation_ImageHandlerTestDouble_Image = nil
        
        NetworkImageOperation_ImageHandlerTestDouble_Response = nil
        
        NetworkImageOperation_TaskTestDouble_Self = nil
        
    }
    
}

extension NetworkImageOperationTestCase {
    
    func testClass() {
        
        XCTAssert(TDD_NetworkImageOperation.imageHandlerClass()! === TDD_NetworkImageHandler.self)
        
        XCTAssert(TDD_NetworkImageOperation.taskClass()! === TDD_NetworkTask.self)
        
    }
    
}

extension NetworkImageOperationTestCase {
    
    func assertTask() {
        
        XCTAssert(NetworkImageOperation_TaskTestDouble_Self!.request! === self.request)
        
    }
    
    func testStart() {
        
        self.operation.startWithRequest(self.request, completionHandler: nil)
        
        self.assertTask()
        
    }
    
}

final class NetworkImageOperationTestDouble: TDD_NetworkImageOperation {
    
    override class func imageHandlerClass() -> AnyClass {
        
        return NetworkImageOperation_ImageHandlerTestDouble.self
        
    }
    
    override class func taskClass() -> AnyClass {
        
        return NetworkImageOperation_TaskTestDouble.self
        
    }
    
}
