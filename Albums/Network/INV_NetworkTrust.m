//
//  INV_NetworkTrust.m
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

#import "INV_NetworkTrust.h"

@implementation INV_NetworkTrust

@end

@implementation INV_NetworkTrust (Class)

+ (INV_NetworkTrust_AnchorCertificatesFunction)anchorCertificatesFunction {
    
    return SecTrustSetAnchorCertificates;
    
}

+ (Class <INV_NetworkTrust_CredentialType>)credentialClass {
    
    return [NSURLCredential class];
    
}

+ (INV_NetworkTrust_EvaluateAsyncFunction)evaluateAsyncFunction {
    
    return SecTrustEvaluateAsync;
    
}

+ (Class <INV_NetworkTrust_OperationType>)operationClass {
    
    return [INV_CertificateOperation class];
    
}

@end

@implementation INV_NetworkTrust (Start)

+ (void)startWithChallenge:(id <INV_NetworkTrust_ChallengeType>)challenge completionHandler:(INV_NetworkTrust_CompletionHandler)completionHandler {
    
    SecTrustRef serverTrust = [[challenge protectionSpace] serverTrust];
    
    SecCertificateRef certificate = [[self operationClass] createCertificate];
    
    [self anchorCertificatesFunction](serverTrust, (__bridge CFArrayRef)@[(__bridge id)certificate]);
    
    [self evaluateAsyncFunction](serverTrust, dispatch_get_main_queue(), ^void (SecTrustRef trust, SecTrustResultType result) {
        
        if (result == kSecTrustResultProceed || result == kSecTrustResultUnspecified) {
            
            completionHandler(NSURLSessionAuthChallengeUseCredential, [[[self credentialClass] alloc] initWithTrust: trust]);
            
        } else {
            
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, 0);
            
        }
        
    });
    
    CFRelease(certificate);
    
}

@end
