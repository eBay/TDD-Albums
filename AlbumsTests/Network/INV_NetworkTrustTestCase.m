//
//  INV_NetworkTrustTestCase.m
//  Albums
//
//  Created by Rick van Voorden on 11/6/14.
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

#import "INV_NetworkTrustTestCase.h"

static id INV_NetworkTrust_AnchorCertificatesFunctionTestDouble_Array = 0;

static id INV_NetworkTrust_AnchorCertificatesFunctionTestDouble_Trust = 0;

static OSStatus INV_NetworkTrust_AnchorCertificatesFunctionTestDouble(SecTrustRef trust, CFArrayRef array) {
    
    INV_NetworkTrust_AnchorCertificatesFunctionTestDouble_Trust = (__bridge id)trust;
    
    INV_NetworkTrust_AnchorCertificatesFunctionTestDouble_Array = (__bridge id)array;
    
    return 0;
    
}

@implementation INV_NetworkTrust_ChallengeTestDouble

@synthesize protectionSpace = _protectionSpace;

- (id <INV_NetworkTrust_ProtectionSpaceType>)protectionSpace {
    
    return INV_LazyPropertyWithClass((self->_protectionSpace), [INV_NetworkTrust_ProtectionSpaceTestDouble class]);
    
}

@end

@implementation INV_NetworkTrust_CredentialTestDouble

- (instancetype)initWithTrust:(SecTrustRef)trust {
    
    self = [self init];
    
    if (self) {
        
        [self setTrust: (__bridge id)trust];
        
    }
    
    return self;
    
}

@end

static SecTrustCallback INV_NetworkTrust_EvaluateAsyncFunctionTestDouble_Callback = 0;

static dispatch_queue_t INV_NetworkTrust_EvaluateAsyncFunctionTestDouble_Queue = 0;

static id INV_NetworkTrust_EvaluateAsyncFunctionTestDouble_Trust = 0;

static OSStatus INV_NetworkTrust_EvaluateAsyncFunctionTestDouble(SecTrustRef trust, dispatch_queue_t queue, SecTrustCallback callback) {
    
    INV_NetworkTrust_EvaluateAsyncFunctionTestDouble_Trust = (__bridge id)trust;
    
    INV_NetworkTrust_EvaluateAsyncFunctionTestDouble_Queue = queue;
    
    INV_NetworkTrust_EvaluateAsyncFunctionTestDouble_Callback = callback;
    
    return 0;
    
}

static id INV_NetworkTrust_OperationTestDouble_Certificate = 0;

@implementation INV_NetworkTrust_OperationTestDouble

+ (SecCertificateRef)createCertificate {
    
    return (SecCertificateRef)CFBridgingRetain(INV_NetworkTrust_OperationTestDouble_Certificate);
    
}

@end

@implementation INV_NetworkTrust_ProtectionSpaceTestDouble

@synthesize trust = _trust;

- (id)trust {
    
    return INV_LazyPropertyWithClass((self->_trust), [NSObject class]);
    
}

- (SecTrustRef)serverTrust {
    
    return (__bridge SecTrustRef)[self trust];
    
}

@end

@implementation INV_NetworkTrustTestCase

@synthesize challenge = _challenge;

- (INV_NetworkTrust_ChallengeTestDouble *)challenge {
    
    return INV_LazyPropertyWithClass((self->_challenge), [INV_NetworkTrust_ChallengeTestDouble class]);
    
}

@end

@implementation INV_NetworkTrustTestCase (Class)

- (void)testClass {
    
    XCTAssertTrue([INV_NetworkTrust anchorCertificatesFunction] == SecTrustSetAnchorCertificates);
    
    XCTAssertTrue([INV_NetworkTrust credentialClass] == [NSURLCredential class]);
    
    XCTAssertTrue([INV_NetworkTrust evaluateAsyncFunction] == SecTrustEvaluateAsync);
    
    XCTAssertTrue([INV_NetworkTrust operationClass] == [INV_CertificateOperation class]);
    
}

@end

@implementation INV_NetworkTrustTestCase (Start)

- (void)assertError {
    
    XCTAssertTrue([self disposition] == NSURLSessionAuthChallengeCancelAuthenticationChallenge);
    
    XCTAssertTrue([self credential] == 0);
    
}

- (void)assertResult:(SecTrustResultType)result {
    
    INV_NetworkTrust_OperationTestDouble_Certificate = [[NSObject alloc] init];
    
    [INV_NetworkTrustTestDouble startWithChallenge: [self challenge] completionHandler: ^void (NSURLSessionAuthChallengeDisposition disposition, id <INV_NetworkTrust_CredentialType> credential) {
        
        [self setDisposition: disposition];
        
        [self setCredential: credential];
        
    }];
    
    XCTAssertTrue(INV_NetworkTrust_AnchorCertificatesFunctionTestDouble_Trust == (id)[[[self challenge] protectionSpace] serverTrust]);
    
    XCTAssertTrue([INV_NetworkTrust_AnchorCertificatesFunctionTestDouble_Array count] == 1);
    
    XCTAssertTrue([INV_NetworkTrust_AnchorCertificatesFunctionTestDouble_Array objectAtIndex: 0] == INV_NetworkTrust_OperationTestDouble_Certificate);
    
    XCTAssertTrue(INV_NetworkTrust_EvaluateAsyncFunctionTestDouble_Trust == (id)[[[self challenge] protectionSpace] serverTrust]);
    
    XCTAssertTrue(INV_NetworkTrust_EvaluateAsyncFunctionTestDouble_Queue == dispatch_get_main_queue());
    
    INV_NetworkTrust_EvaluateAsyncFunctionTestDouble_Callback((__bridge SecTrustRef)INV_NetworkTrust_EvaluateAsyncFunctionTestDouble_Trust, result);
    
}

- (void)assertSuccess {
    
    XCTAssertTrue([self disposition] == NSURLSessionAuthChallengeUseCredential);
    
    XCTAssertTrue([(INV_NetworkTrust_CredentialTestDouble *)[self credential] trust] == INV_NetworkTrust_EvaluateAsyncFunctionTestDouble_Trust);
    
}

- (void)testResultInvalid {
    
    [self assertResult: kSecTrustResultInvalid];
    
    [self assertError];
    
}

- (void)testResultProceed {
    
    [self assertResult: kSecTrustResultProceed];
    
    [self assertSuccess];
    
}

- (void)testResultDeny {
    
    [self assertResult: kSecTrustResultDeny];
    
    [self assertError];
    
}

- (void)testResultUnspecified {
    
    [self assertResult: kSecTrustResultUnspecified];
    
    [self assertSuccess];
    
}

- (void)testResultRecoverableTrustFailure {
    
    [self assertResult: kSecTrustResultRecoverableTrustFailure];
    
    [self assertError];
    
}

- (void)testResultOtherError {
    
    [self assertResult: kSecTrustResultOtherError];
    
    [self assertError];
    
}

@end

@implementation INV_NetworkTrustTestDouble

+ (INV_NetworkTrust_AnchorCertificatesFunction)anchorCertificatesFunction {
    
    return INV_NetworkTrust_AnchorCertificatesFunctionTestDouble;
    
}

+ (Class)credentialClass {
    
    return [INV_NetworkTrust_CredentialTestDouble class];
    
}

+ (INV_NetworkTrust_EvaluateAsyncFunction)evaluateAsyncFunction {
    
    return INV_NetworkTrust_EvaluateAsyncFunctionTestDouble;
    
}

+ (Class)operationClass {
    
    return [INV_NetworkTrust_OperationTestDouble class];
    
}

@end
