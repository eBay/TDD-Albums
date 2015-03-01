//
//  NetworkSessionTestCase.swift
//  Albums
//
//  Created by Rick van Voorden on 1/9/15.
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

final class NetworkSession_ChallengeTestDouble: NSObject, INV_NetworkTrust_ChallengeType {
    
    var protectionSpace: INV_NetworkTrust_ProtectionSpaceType?
    
}

var NetworkSession_ConfigurationTestDouble_EphemeralSessionConfiguration: NetworkSession_ConfigurationTestDouble?

final class NetworkSession_ConfigurationTestDouble: NSObject, INV_NetworkSession_ConfigurationType {
    
    class func ephemeralSessionConfiguration() -> INV_NetworkSession_ConfigurationType {
        
        return NetworkSession_ConfigurationTestDouble_EphemeralSessionConfiguration!
        
    }
    
}

final class NetworkSession_CredentialTestDouble: NSObject, INV_NetworkTrust_CredentialType {
    
    init(trust: SecTrust?) {
        
        
        
    }
    
}

var NetworkSession_QueueTestDouble_MainQueue: NetworkSession_QueueTestDouble?

final class NetworkSession_QueueTestDouble: NSObject, INV_NetworkSession_QueueType {
    
    var block: dispatch_block_t?
    
    class func mainQueue() -> INV_NetworkSession_QueueType {
        
        return NetworkSession_QueueTestDouble_MainQueue!
        
    }
    
    func addOperationWithBlock(block: dispatch_block_t) {
        
        self.block = block
        
    }
    
}

var NetworkSession_SessionTestDouble_Configuration: INV_NetworkSession_ConfigurationType?

var NetworkSession_SessionTestDouble_Delegate: INV_NetworkSession_SessionDelegate?

var NetworkSession_SessionTestDouble_DelegateQueue: NSOperationQueue?

var NetworkSession_SessionTestDouble_Session: NetworkSession_SessionTestDouble?

final class NetworkSession_SessionTestDouble: NSObject, INV_NetworkSession_SessionType {
    
    var completionHandler: INV_NetworkSession_SessionType_CompletionHandler?
    
    lazy var dataTask = NSObject()
    
    var didInvalidateAndCancel = false
    
    var request: NSURLRequest?
    
    class func sessionWithConfiguration(configuration: INV_NetworkSession_ConfigurationType, delegate: INV_NetworkSession_SessionDelegate?, delegateQueue: NSOperationQueue?) -> INV_NetworkSession_SessionType {
        
        NetworkSession_SessionTestDouble_Configuration = configuration
        
        NetworkSession_SessionTestDouble_Delegate = delegate
        
        NetworkSession_SessionTestDouble_DelegateQueue = delegateQueue
        
        return NetworkSession_SessionTestDouble_Session!
        
    }
    
    func dataTaskWithRequest(request: NSURLRequest, completionHandler: INV_NetworkSession_SessionType_CompletionHandler) -> AnyObject {
        
        self.request = request
        
        self.completionHandler = completionHandler
        
        return self.dataTask
        
    }
    
    func invalidateAndCancel() {
        
        self.didInvalidateAndCancel = true
        
    }
    
}

var NetworkSession_TrustTestDouble_Challenge: INV_NetworkTrust_ChallengeType?

var NetworkSession_TrustTestDouble_CompletionHandler: INV_NetworkTrust_CompletionHandler?

final class NetworkSession_TrustTestDouble: NSObject, INV_NetworkSession_TrustType {
    
    class func startWithChallenge(challenge: INV_NetworkTrust_ChallengeType, completionHandler: INV_NetworkTrust_CompletionHandler) {
        
        NetworkSession_TrustTestDouble_Challenge = challenge
        
        NetworkSession_TrustTestDouble_CompletionHandler = completionHandler
        
    }
    
}

final class NetworkSessionTestCase: XCTestCase {
    
    lazy var challenge = NetworkSession_ChallengeTestDouble()
    
    lazy var credential = NetworkSession_CredentialTestDouble(trust: nil)
    
    lazy var data = DataTestDouble()
    
    lazy var error = ErrorTestDouble()
    
    lazy var request = RequestTestDouble()
    
    lazy var response = ResponseTestDouble()
    
    lazy var session = NetworkSessionTestDouble()
    
    var task: AnyObject?
    
    override func tearDown() {
        
        NetworkSession_ConfigurationTestDouble_EphemeralSessionConfiguration = nil
        
        NetworkSession_QueueTestDouble_MainQueue = nil
        
        NetworkSession_SessionTestDouble_Configuration = nil
        
        NetworkSession_SessionTestDouble_Delegate = nil
        
        NetworkSession_SessionTestDouble_DelegateQueue = nil
        
        NetworkSession_SessionTestDouble_Session = nil
        
        NetworkSession_TrustTestDouble_Challenge = nil
        
        NetworkSession_TrustTestDouble_CompletionHandler = nil
        
    }
    
}

extension NetworkSessionTestCase {
    
    func testClass() {
        
        XCTAssert(INV_NetworkSession.configurationClass()! === NSURLSessionConfiguration.self)
        
        XCTAssert(INV_NetworkSession.queueClass()! === NSOperationQueue.self)
        
        XCTAssert(INV_NetworkSession.sessionClass()! === NSURLSession.self)
        
        XCTAssert(INV_NetworkSession.trustClass()! === INV_NetworkTrust.self)
        
    }
    
}

extension NetworkSessionTestCase {
    
    func assertCancel() {
        
        self.session.cancel()
        
        XCTAssert(NetworkSession_SessionTestDouble_Session!.didInvalidateAndCancel)
        
        NetworkSession_SessionTestDouble_Session!.didInvalidateAndCancel = false
        
    }
    
    func assertData(data: NSData, response: NSURLResponse, error: NSError) {
        
        XCTAssert(data === self.data)
        
        XCTAssert(response === self.response)
        
        XCTAssert(error === self.error)
        
    }
    
    func assertSession() {
        
        XCTAssert(NetworkSession_SessionTestDouble_Configuration! === NetworkSession_ConfigurationTestDouble_EphemeralSessionConfiguration)
        
        XCTAssert(NetworkSession_SessionTestDouble_Delegate! === self.session)
        
        XCTAssert(NetworkSession_SessionTestDouble_DelegateQueue == nil)
        
        XCTAssert(self.task! === NetworkSession_SessionTestDouble_Session!.dataTask)
        
        XCTAssert(NetworkSession_SessionTestDouble_Session!.request! === self.request)
        
        NetworkSession_SessionTestDouble_Session!.completionHandler!(self.data, self.response, self.error)
        
        NetworkSession_QueueTestDouble_MainQueue!.block!()
        
    }
    
    func testTask() {
        
        NetworkSession_ConfigurationTestDouble_EphemeralSessionConfiguration = NetworkSession_ConfigurationTestDouble()
        
        NetworkSession_QueueTestDouble_MainQueue = NetworkSession_QueueTestDouble()
        
        NetworkSession_SessionTestDouble_Session = NetworkSession_SessionTestDouble()
        
        var didStart = false
        
        self.task = self.session.taskWithRequest(self.request) {(data, response, error) in
            
            didStart = true
            
            self.assertData(data, response: response, error: error)
            
        }
        
        self.assertSession()
        
        self.assertCancel()
        
        XCTAssert(didStart)
        
    }
    
}

extension NetworkSessionTestCase {
    
    func testSessionDelegateCancelAuthenticationChallenge() {
        
        var didStart = false
        
        self.session.URLSession(nil, didReceiveChallenge: self.challenge) {(disposition, credential) in
            
            didStart = true
            
            XCTAssert(disposition == NSURLSessionAuthChallengeDisposition.CancelAuthenticationChallenge)
            
            XCTAssert(credential! === self.credential)
            
        }
        
        XCTAssert(NetworkSession_TrustTestDouble_Challenge! === self.challenge)
        
        NetworkSession_TrustTestDouble_CompletionHandler!(NSURLSessionAuthChallengeDisposition.CancelAuthenticationChallenge, self.credential)
        
        XCTAssert(didStart)
        
    }
    
    func testSessionDelegateUseCredential() {
        
        var didStart = false
        
        self.session.URLSession(nil, didReceiveChallenge: self.challenge) {(disposition, credential) in
            
            didStart = true
            
            XCTAssert(disposition == NSURLSessionAuthChallengeDisposition.UseCredential)
            
            XCTAssert(credential! === self.credential)
            
        }
        
        XCTAssert(NetworkSession_TrustTestDouble_Challenge! === self.challenge)
        
        NetworkSession_TrustTestDouble_CompletionHandler!(NSURLSessionAuthChallengeDisposition.UseCredential, self.credential)
        
        XCTAssert(didStart)
        
    }
    
}

final class NetworkSessionTestDouble: INV_NetworkSession {
    
    required init() {
        
        super.init()
        
    }
    
    override class func configurationClass() -> AnyClass {
        
        return NetworkSession_ConfigurationTestDouble.self
        
    }
    
    override class func queueClass() -> AnyClass {
        
        return NetworkSession_QueueTestDouble.self
        
    }
    
    override class func sessionClass() -> AnyClass {
        
        return NetworkSession_SessionTestDouble.self
        
    }
    
    override class func trustClass() -> AnyClass {
        
        return NetworkSession_TrustTestDouble.self
        
    }
    
}
