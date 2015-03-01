//
//  NetworkTaskTestCase.swift
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

var NetworkTask_SessionTestDouble_Self: NetworkTask_SessionTestDouble?

final class NetworkTask_SessionTestDouble: NSObject, TDD_NetworkTask_SessionType {
    
    override init() {
        
        super.init()
        
        NetworkTask_SessionTestDouble_Self = self
        
    }
    
    var completionHandler: TDD_NetworkSession_CompletionHandler?
    
    var didCancel = false
    
    var request: NSURLRequest?
    
    var task: NetworkTask_TaskTestDouble?
    
    func cancel() {
        
        self.didCancel = true
        
    }
    
    func taskWithRequest(request: NSURLRequest, completionHandler: TDD_NetworkSession_CompletionHandler) -> TDD_NetworkTask_TaskType {
        
        self.request = request
        
        self.completionHandler = completionHandler
        
        self.task = NetworkTask_TaskTestDouble()
        
        return self.task!
        
    }
    
}

final class NetworkTask_TaskTestDouble: NSObject, TDD_NetworkTask_TaskType {
    
    var didCancel = false
    
    var didResume = false
    
    func cancel() {
        
        self.didCancel = true
        
    }
    
    func resume() {
        
        self.didResume = true
        
    }
    
}

final class NetworkTaskTestCase: XCTestCase {
    
    lazy var data = DataTestDouble()
    
    lazy var error = ErrorTestDouble()
    
    lazy var request = RequestTestDouble()
    
    lazy var response = ResponseTestDouble()
    
    lazy var task = NetworkTaskTestDouble()
    
    override func tearDown() {
        
        NetworkTask_SessionTestDouble_Self = nil
        
    }
    
}

extension NetworkTaskTestCase {
    
    func testClass() {
        
        XCTAssert(TDD_NetworkTask.sessionClass()! === TDD_NetworkSession.self)
        
    }
    
}

extension NetworkTaskTestCase {
    
    func assertData(data: NSData, response: NSURLResponse, error: NSError) {
        
        XCTAssert(data === self.data)
        
        XCTAssert(response === self.response)
        
        XCTAssert(error === self.error)
        
    }
    
    func assertSession() {
        
        XCTAssert(NetworkTask_SessionTestDouble_Self!.request! === self.request)
        
        XCTAssert(NetworkTask_SessionTestDouble_Self!.task!.didResume)
        
        NetworkTask_SessionTestDouble_Self!.completionHandler!(self.data, self.response, self.error)
        
    }
    
    func testStart() {
        
        var didAssertData = false
        
        self.task.startWithRequest(self.request) {(data, response, error) in
            
            self.assertData(data, response: response, error: error)
            
            didAssertData = true
            
        }
        
        self.assertSession()
        
        XCTAssert(didAssertData)
        
    }
    
}

final class NetworkTaskTestDouble: TDD_NetworkTask {
    
    override class func sessionClass() -> AnyClass {
        
        return NetworkTask_SessionTestDouble.self
        
    }
    
}
