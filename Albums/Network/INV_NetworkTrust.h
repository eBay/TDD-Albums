//
//  INV_NetworkTrust.h
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

#import "INV_CertificateOperation.h"

@protocol INV_NetworkTrust_ProtectionSpaceType;

@protocol INV_NetworkTrust_ChallengeType <NSObject>

@property (nonatomic, readonly) id <INV_NetworkTrust_ProtectionSpaceType> protectionSpace;

@end

INV_Extension(NSURLAuthenticationChallenge, INV_NetworkTrust_ChallengeType)

@protocol INV_NetworkTrust_CredentialType <NSObject>

+ (id <INV_NetworkTrust_CredentialType>)alloc;

- (id <INV_NetworkTrust_CredentialType>)initWithTrust:(SecTrustRef)trust;

@end

INV_Extension(NSURLCredential, INV_NetworkTrust_CredentialType)

@protocol INV_NetworkTrust_OperationType <NSObject>

+ (SecCertificateRef)createCertificate CF_RETURNS_RETAINED;

@end

INV_Extension(INV_CertificateOperation, INV_NetworkTrust_OperationType)

@protocol INV_NetworkTrust_ProtectionSpaceType <NSObject>

@property (nonatomic, readonly) SecTrustRef serverTrust;

@end

INV_Extension(NSURLProtectionSpace, INV_NetworkTrust_ProtectionSpaceType)

typedef OSStatus (*INV_NetworkTrust_AnchorCertificatesFunction)(SecTrustRef, CFArrayRef);

typedef void (^INV_NetworkTrust_CompletionHandler)(NSURLSessionAuthChallengeDisposition, id <INV_NetworkTrust_CredentialType>);

typedef OSStatus (*INV_NetworkTrust_EvaluateAsyncFunction)(SecTrustRef, dispatch_queue_t, SecTrustCallback);

@interface INV_NetworkTrust: NSObject

@end

@interface INV_NetworkTrust (Class)

+ (INV_NetworkTrust_AnchorCertificatesFunction)anchorCertificatesFunction;
+ (Class <INV_NetworkTrust_CredentialType>)credentialClass;
+ (INV_NetworkTrust_EvaluateAsyncFunction)evaluateAsyncFunction;
+ (Class <INV_NetworkTrust_OperationType>)operationClass;

@end

@interface INV_NetworkTrust (Start)

+ (void)startWithChallenge:(id <INV_NetworkTrust_ChallengeType>)challenge completionHandler:(INV_NetworkTrust_CompletionHandler)completionHandler;

@end
