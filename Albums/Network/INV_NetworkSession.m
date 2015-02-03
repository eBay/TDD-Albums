//
//  INV_NetworkSession.m
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

#import "INV_NetworkSession.h"

@interface INV_NetworkSession ()

@property (nonatomic, strong) id <INV_NetworkSession_SessionType> session;

@end

@implementation INV_NetworkSession

@synthesize session = _session;

- (id <INV_NetworkSession_SessionType>)session {
    
    return INV_LazyPropertyWithExpression((self->_session), {
        
        id <INV_NetworkSession_ConfigurationType> ephemeralSessionConfiguration = [[[self class] configurationClass] ephemeralSessionConfiguration];
        
        id <INV_NetworkSession_SessionType> session = [[[self class] sessionClass] sessionWithConfiguration: ephemeralSessionConfiguration delegate: self delegateQueue: 0];
        
        [self setSession: session];
        
    });
    
}

- (void)setSession:(id <INV_NetworkSession_SessionType>)session {
    
    INV_PropertySetter((self->_session), session, {
        
        [(self->_session) invalidateAndCancel];
        
    }, {
        
        
        
    });
    
}

@end

@implementation INV_NetworkSession (Cancel)

- (void)cancel {
    
    [self setSession: 0];
    
}

@end

@implementation INV_NetworkSession (Class)

+ (Class <INV_NetworkSession_ConfigurationType>)configurationClass {
    
    return [NSURLSessionConfiguration class];
    
}

+ (Class <INV_NetworkSession_QueueType>)queueClass {
    
    return [NSOperationQueue class];
    
}

+ (Class <INV_NetworkSession_SessionType>)sessionClass {
    
    return [NSURLSession class];
    
}

+ (Class <INV_NetworkSession_TrustType>)trustClass {
    
    return [INV_NetworkTrust class];
    
}

@end

@implementation INV_NetworkSession (SessionDelegate)

- (void)URLSession:(id <INV_NetworkSession_SessionType>)session didReceiveChallenge:(id <INV_NetworkTrust_ChallengeType>)challenge completionHandler:(INV_NetworkTrust_CompletionHandler)completionHandler {
    
    [[[self class] trustClass] startWithChallenge: challenge completionHandler: completionHandler];
    
}

@end

@implementation INV_NetworkSession (Task)

- (id)taskWithRequest:(NSURLRequest *)request completionHandler:(INV_NetworkSession_SessionType_CompletionHandler)completionHandler {
    
    INV_NetworkSession *__weak weakSelf = self;
    
    return [[self session] dataTaskWithRequest: request completionHandler: ^void (NSData *data, NSURLResponse *response, NSError *error) {
        
        [[[[weakSelf class] queueClass] mainQueue] addOperationWithBlock: ^void (void) {
            
            completionHandler(data, response, error);
            
        }];
        
    }];
    
}

@end
