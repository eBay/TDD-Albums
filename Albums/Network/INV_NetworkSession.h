//
//  INV_NetworkSession.h
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

#import "INV_NetworkTrust.h"

@protocol INV_NetworkSession_ConfigurationType <NSObject>

+ (id <INV_NetworkSession_ConfigurationType>)ephemeralSessionConfiguration;

@end

INV_Extension(NSURLSessionConfiguration, INV_NetworkSession_ConfigurationType)

@protocol INV_NetworkSession_QueueType <NSObject>

+ (id <INV_NetworkSession_QueueType>)mainQueue;

- (void)addOperationWithBlock:(dispatch_block_t)block;

@end

INV_Extension(NSOperationQueue, INV_NetworkSession_QueueType)

@protocol INV_NetworkSession_SessionType;

@protocol INV_NetworkSession_SessionDelegate <NSObject>

- (void)URLSession:(id <INV_NetworkSession_SessionType>)session didReceiveChallenge:(id <INV_NetworkTrust_ChallengeType>)challenge completionHandler:(INV_NetworkTrust_CompletionHandler)completionHandler;

@end

typedef void (^INV_NetworkSession_SessionType_CompletionHandler)(NSData *, NSURLResponse *, NSError *);

@protocol INV_NetworkSession_SessionType <NSObject>

+ (id <INV_NetworkSession_SessionType>)sessionWithConfiguration:(id <INV_NetworkSession_ConfigurationType>)configuration delegate:(id <INV_NetworkSession_SessionDelegate>)delegate delegateQueue:(NSOperationQueue *)delegateQueue;

- (id)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(INV_NetworkSession_SessionType_CompletionHandler)completionHandler;
- (void)invalidateAndCancel;

@end

INV_Extension(NSURLSession, INV_NetworkSession_SessionType)

@protocol INV_NetworkSession_TrustType <NSObject>

+ (void)startWithChallenge:(id <INV_NetworkTrust_ChallengeType>)challenge completionHandler:(INV_NetworkTrust_CompletionHandler)completionHandler;

@end

INV_Extension(INV_NetworkTrust, INV_NetworkSession_TrustType)

@interface INV_NetworkSession: NSObject

@end

@interface INV_NetworkSession (Cancel)

- (void)cancel;

@end

@interface INV_NetworkSession (Class)

+ (Class <INV_NetworkSession_ConfigurationType>)configurationClass;
+ (Class <INV_NetworkSession_QueueType>)queueClass;
+ (Class <INV_NetworkSession_SessionType>)sessionClass;
+ (Class <INV_NetworkSession_TrustType>)trustClass;

@end

@interface INV_NetworkSession (SessionDelegate) <INV_NetworkSession_SessionDelegate>

@end

@interface INV_NetworkSession (Task)

- (id)taskWithRequest:(NSURLRequest *)request completionHandler:(INV_NetworkSession_SessionType_CompletionHandler)completionHandler;

@end
