//
//  NetworkJSONOperationTestCase.swift
//  Albums
//
//  Created by Rick van Voorden on 3/1/15.
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

var NetworkJSONOperation_JSONHandlerTestDouble_Error: NSError?

var NetworkJSONOperation_JSONHandlerTestDouble_JSON: NSObject?

var NetworkJSONOperation_JSONHandlerTestDouble_Response: TDD_NetworkResponse?

final class NetworkJSONOperation_JSONHandlerTestDouble: NSObject, TDD_NetworkJSONOperation_JSONHandlerType {
    
    class func jsonWithResponse(response: TDD_NetworkResponse, error: NSErrorPointer) -> AnyObject? {
        
        NetworkJSONOperation_JSONHandlerTestDouble_Response = response
        
        if error != nil {
            
            error.memory = NetworkJSONOperation_JSONHandlerTestDouble_Error
            
        }
        
        return NetworkJSONOperation_JSONHandlerTestDouble_JSON
        
    }
    
}

var NetworkJSONOperation_TaskTestDouble_Self: NetworkJSONOperation_TaskTestDouble?

final class NetworkJSONOperation_TaskTestDouble: NSObject, TDD_NetworkOperation_TaskType {
    
    override init() {
        
        super.init()
        
        NetworkJSONOperation_TaskTestDouble_Self = self
        
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

final class NetworkJSONOperationTestCase: XCTestCase {
    
    lazy var data = DataTestDouble()
    
    lazy var error = ErrorTestDouble()
    
    lazy var operation = NetworkJSONOperationTestDouble()
    
    lazy var request = RequestTestDouble()
    
    lazy var response = ResponseTestDouble()
    
    override func tearDown() {
        
        NetworkJSONOperation_JSONHandlerTestDouble_Error = nil
        
        NetworkJSONOperation_JSONHandlerTestDouble_JSON = nil
        
        NetworkJSONOperation_JSONHandlerTestDouble_Response = nil
        
        NetworkJSONOperation_TaskTestDouble_Self = nil
        
    }
    
}

extension NetworkJSONOperationTestCase {
    
    func testCancel() {
        
        self.operation.startWithRequest(nil, completionHandler: nil)
        
        let task = NetworkJSONOperation_TaskTestDouble_Self!
        
        self.operation.cancel()
        
        XCTAssert(task.didCancel)
        
    }
    
    func testCancelByItself() {
        
        self.operation.cancel()
        
        XCTAssert(NetworkJSONOperation_TaskTestDouble_Self == nil)
        
    }
    
}

extension NetworkJSONOperationTestCase {
    
    func testClass() {
        
        XCTAssert(TDD_NetworkJSONOperation.jsonHandlerClass()! === TDD_NetworkJSONHandler.self)
        
        XCTAssert(TDD_NetworkJSONOperation.taskClass()! === TDD_NetworkTask.self)
        
    }
    
}

extension NetworkJSONOperationTestCase {
    
    func assertJSON(json: AnyObject, error: NSError) {
        
        XCTAssert(json === NetworkJSONOperation_JSONHandlerTestDouble_JSON)
        
        XCTAssert(error === NetworkJSONOperation_JSONHandlerTestDouble_Error)
        
    }
    
    func assertJSONHandler() {
        
        XCTAssert(NetworkJSONOperation_JSONHandlerTestDouble_Response!.data! === self.data)
        
        XCTAssert(NetworkJSONOperation_JSONHandlerTestDouble_Response!.error! === self.error)
        
        XCTAssert(NetworkJSONOperation_JSONHandlerTestDouble_Response!.response! === self.response)
        
    }
    
    func assertTask() {
        
        XCTAssert(NetworkJSONOperation_TaskTestDouble_Self!.request! === self.request)
        
        NetworkJSONOperation_TaskTestDouble_Self!.completionHandler!(self.data, self.response, self.error)
        
    }
    
    func testStart() {
        
        NetworkJSONOperation_JSONHandlerTestDouble_JSON = NSObject()
        
        NetworkJSONOperation_JSONHandlerTestDouble_Error = ErrorTestDouble()
        
        var didAssertJSON = false
        
        self.operation.startWithRequest(self.request) {(json, error) in
            
            self.assertJSON(json, error: error)
            
            didAssertJSON = true
            
        }
        
        self.assertTask()
        
        self.assertJSONHandler()
        
        XCTAssert(didAssertJSON)
        
    }
    
}

final class NetworkJSONOperationTestDouble: TDD_NetworkJSONOperation {
    
    override class func jsonHandlerClass() -> AnyClass {
        
        return NetworkJSONOperation_JSONHandlerTestDouble.self
        
    }
    
    override class func taskClass() -> AnyClass {
        
        return NetworkJSONOperation_TaskTestDouble.self
        
    }
    
}
