//
//  NetworkTaskTestCase.swift
//  Albums
//
//  Created by Rick van Voorden on 1/27/15.
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

final class NetworkTask_SessionTestDouble: NSObject, INV_NetworkTask_SessionType {
    
    var completionHandler: INV_NetworkSession_SessionType_CompletionHandler?
    
    var didCancel = false
    
    var request: NSURLRequest?
    
    lazy var task = NetworkTask_TaskTestDouble()
    
    func cancel() {
        
        self.didCancel = true
        
    }
    
    func taskWithRequest(request: NSURLRequest, completionHandler: INV_NetworkSession_SessionType_CompletionHandler) -> INV_NetworkTask_TaskType {
        
        self.request = request
        
        self.completionHandler = completionHandler
        
        return self.task
        
    }
    
}

final class NetworkTask_TaskTestDouble: NSObject, INV_NetworkTask_TaskType {
    
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
    
    var taskSession: NetworkTask_SessionTestDouble {
        
        return (self.task.session as NetworkTask_SessionTestDouble)
        
    }
    
}

extension NetworkTaskTestCase {
    
    func testCancel() {
        
        self.task.startWithRequest(nil, completionHandler: nil)
        
        let session = self.taskSession
        
        self.task.cancel()
        
        XCTAssertTrue(session.didCancel)
        
        XCTAssertTrue(session.task.didCancel)
        
    }
    
}

extension NetworkTaskTestCase {
    
    func testClass() {
        
        XCTAssertTrue(INV_NetworkTask.sessionClass()! === INV_NetworkSession.self)
        
    }
    
}

extension NetworkTaskTestCase {
    
    func testDealloc() {
        
        self.task.startWithRequest(nil, completionHandler: nil)
        
        let session = self.taskSession
        
        self.task = NetworkTaskTestDouble()
        
        XCTAssertTrue(session.didCancel)
        
        XCTAssertTrue(session.task.didCancel)
        
    }
    
}

extension NetworkTaskTestCase {
    
    func assertCancel() {
        
        let task = self.taskSession.task
        
        self.taskSession.task = NetworkTask_TaskTestDouble()
        
        self.task.startWithRequest(nil, completionHandler: nil)
        
        XCTAssertTrue(task.didCancel)
        
    }
    
    func assertData(data: NSData, response: NSURLResponse, error: NSError) {
        
        XCTAssertTrue(data === self.data)
        
        XCTAssertTrue(response === self.response)
        
        XCTAssertTrue(error === self.error)
        
    }
    
    func assertSession() {
        
        XCTAssertTrue(self.taskSession.task.didResume)
        
        XCTAssertTrue(self.taskSession.request! === self.request)
        
        self.taskSession.completionHandler!(self.data, self.response, self.error)
        
    }
    
    func testStart() {
        
        var didStart = false
        
        self.task.startWithRequest(self.request) {(data, response, error) in
            
            didStart = true
            
            self.assertData(data, response: response, error: error)
            
        }
        
        self.assertSession()
        
        self.assertCancel()
        
        XCTAssertTrue(didStart)
        
    }
    
}

final class NetworkTaskTestDouble: INV_NetworkTask {
    
    override class func sessionClass() -> AnyClass {
        
        return NetworkTask_SessionTestDouble.self
        
    }
    
}
