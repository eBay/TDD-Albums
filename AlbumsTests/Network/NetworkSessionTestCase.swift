//
//  NetworkSessionTestCase.swift
//  Albums
//
//  Created by Rick van Voorden on 2/27/15.
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

let NetworkSession_ConfigurationTestDouble_DefaultSessionConfiguration = NetworkSession_ConfigurationTestDouble()

final class NetworkSession_ConfigurationTestDouble: NSObject, TDD_NetworkSession_ConfigurationType {
    
    class func defaultSessionConfiguration() -> TDD_NetworkSession_ConfigurationType {
        
        return NetworkSession_ConfigurationTestDouble_DefaultSessionConfiguration
        
    }
    
}

let NetworkSession_QueueTestDouble_MainQueue = NetworkSession_QueueTestDouble()

final class NetworkSession_QueueTestDouble: NSObject, TDD_NetworkSession_QueueType {
    
    var block: dispatch_block_t?
    
    class func mainQueue() -> TDD_NetworkSession_QueueType {
        
        return NetworkSession_QueueTestDouble_MainQueue
        
    }
    
    func addOperationWithBlock(block: dispatch_block_t) {
        
        self.block = block
        
    }
    
}

var NetworkSession_SessionTestDouble_Configuration: TDD_NetworkSession_ConfigurationType?

var NetworkSession_SessionTestDouble_Delegate: AnyObject?

var NetworkSession_SessionTestDouble_DelegateQueue: NSOperationQueue?

var NetworkSession_SessionTestDouble_Session: NetworkSession_SessionTestDouble?

final class NetworkSession_SessionTestDouble: NSObject, TDD_NetworkSession_SessionType {
    
    var completionHandler: TDD_NetworkSession_CompletionHandler?
    
    lazy var dataTask = NSObject()
    
    var didInvalidateAndCancel = false
    
    var request: NSURLRequest?
    
    class func sessionWithConfiguration(configuration: TDD_NetworkSession_ConfigurationType, delegate: AnyObject?, delegateQueue: NSOperationQueue?) -> TDD_NetworkSession_SessionType {
        
        NetworkSession_SessionTestDouble_Configuration = configuration
        
        NetworkSession_SessionTestDouble_Delegate = delegate
        
        NetworkSession_SessionTestDouble_DelegateQueue = delegateQueue
        
        NetworkSession_SessionTestDouble_Session = NetworkSession_SessionTestDouble()
        
        return NetworkSession_SessionTestDouble_Session!
        
    }
    
    func dataTaskWithRequest(request: NSURLRequest, completionHandler: TDD_NetworkSession_CompletionHandler) -> AnyObject {
        
        self.request = request
        
        self.completionHandler = completionHandler
        
        return self.dataTask
        
    }
    
    func invalidateAndCancel() {
        
        self.didInvalidateAndCancel = true
        
    }
    
}

final class NetworkSessionTestCase: XCTestCase {
    
    lazy var data = DataTestDouble()
    
    lazy var error = ErrorTestDouble()
    
    lazy var request = RequestTestDouble()
    
    lazy var response = ResponseTestDouble()
    
    lazy var session = NetworkSessionTestDouble()
    
    var task: AnyObject?
    
    override func tearDown() {
        
        NetworkSession_SessionTestDouble_Configuration = nil
        
        NetworkSession_SessionTestDouble_Delegate = nil
        
        NetworkSession_SessionTestDouble_DelegateQueue = nil
        
        NetworkSession_SessionTestDouble_Session = nil
        
    }
    
}

extension NetworkSessionTestCase {
    
    func testCancel() {
        
        self.session.taskWithRequest(nil, completionHandler: nil)
        
        let session = NetworkSession_SessionTestDouble_Session!
        
        self.session.cancel()
        
        XCTAssert(session.didInvalidateAndCancel)
        
    }
    
    func testCancelByItself() {
        
        self.session.cancel()
        
        XCTAssert(NetworkSession_SessionTestDouble_Session == nil)
        
    }
    
}

extension NetworkSessionTestCase {
    
    func testClass() {
        
        XCTAssert(TDD_NetworkSession.configurationClass()! === NSURLSessionConfiguration.self)
        
        XCTAssert(TDD_NetworkSession.queueClass()! === NSOperationQueue.self)
        
        XCTAssert(TDD_NetworkSession.sessionClass()! === NSURLSession.self)
        
    }
    
}

extension NetworkSessionTestCase {
    
    func assertData(data: NSData, response: NSURLResponse, error: NSError) {
        
        XCTAssert(data === self.data)
        
        XCTAssert(response === self.response)
        
        XCTAssert(error === self.error)
        
    }
    
    func assertQueue() {
        
        NetworkSession_QueueTestDouble_MainQueue.block!()
        
    }
    
    func assertSession() {
        
        XCTAssert(NetworkSession_SessionTestDouble_Configuration! === NetworkSession_ConfigurationTestDouble_DefaultSessionConfiguration)
        
        XCTAssert(NetworkSession_SessionTestDouble_Delegate == nil)
        
        XCTAssert(NetworkSession_SessionTestDouble_DelegateQueue == nil)
        
        XCTAssert(self.task! === NetworkSession_SessionTestDouble_Session!.dataTask)
        
        XCTAssert(NetworkSession_SessionTestDouble_Session!.request! === self.request)
        
        NetworkSession_SessionTestDouble_Session!.completionHandler!(self.data, self.response, self.error)
        
    }
    
    func testTask() {
        
        var didAssertData = false
        
        self.task = self.session.taskWithRequest(self.request) {(data, response, error) in
            
            self.assertData(data, response: response, error: error)
            
            didAssertData = true
            
        }
        
        self.assertSession()
        
        XCTAssert(didAssertData == false)
        
        self.assertQueue()
        
        XCTAssert(didAssertData)
        
    }
    
}

final class NetworkSessionTestDouble: TDD_NetworkSession {
    
    override class func configurationClass() -> AnyClass {
        
        return NetworkSession_ConfigurationTestDouble.self
        
    }
    
    override class func queueClass() -> AnyClass {
        
        return NetworkSession_QueueTestDouble.self
        
    }
    
    override class func sessionClass() -> AnyClass {
        
        return NetworkSession_SessionTestDouble.self
        
    }
    
}
