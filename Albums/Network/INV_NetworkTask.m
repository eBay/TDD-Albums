//
//  INV_NetworkTask.m
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

#import "INV_NetworkTask.h"

@interface INV_NetworkTask ()

@property (nonatomic, strong) id <INV_NetworkTask_TaskType> task;

@end

@implementation INV_NetworkTask

@synthesize session = _session;

- (id <INV_NetworkTask_SessionType>)session {
    
    return INV_LazyPropertyWithClass((self->_session), [[self class] sessionClass]);
    
}

- (void)setSession:(id <INV_NetworkTask_SessionType>)session {
    
    INV_PropertySetter((self->_session), session, {
        
        [(self->_session) cancel];
        
    }, {
        
        
        
    });
    
}

- (void)setTask:(id <INV_NetworkTask_TaskType>)task {
    
    INV_PropertySetter((self->_task), task, {
        
        [(self->_task) cancel];
        
    }, {
        
        [(self->_task) resume];
        
    });
    
}

@end

@implementation INV_NetworkTask (Cancel)

- (void)cancel {
    
    [self setSession: 0];
    
    [self setTask: 0];
    
}

@end

@implementation INV_NetworkTask (Class)

+ (Class <INV_NetworkTask_SessionType>)sessionClass {
    
    return [INV_NetworkSession class];
    
}

@end

@implementation INV_NetworkTask (Object)

- (void)dealloc {
    
    [self cancel];
    
}

@end

@implementation INV_NetworkTask (Start)

- (void)startWithRequest:(NSURLRequest *)request completionHandler:(INV_NetworkSession_SessionType_CompletionHandler)completionHandler {
    
    id <INV_NetworkTask_TaskType> task = [[self session] taskWithRequest: request completionHandler: completionHandler];
    
    [self setTask: task];
    
}

@end
