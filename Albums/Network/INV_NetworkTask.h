//
//  INV_NetworkTask.h
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

#import "INV_NetworkSession.h"

@protocol INV_NetworkTask_TaskType;

@protocol INV_NetworkTask_SessionType <NSObject>

+ (id <INV_NetworkTask_SessionType>)alloc;

- (void)cancel;
- (id <INV_NetworkTask_SessionType>)init;
- (id <INV_NetworkTask_TaskType>)taskWithRequest:(NSURLRequest *)request completionHandler:(INV_NetworkSession_SessionType_CompletionHandler)completionHandler;

@end

INV_Extension(INV_NetworkSession, INV_NetworkTask_SessionType)

@protocol INV_NetworkTask_TaskType <NSObject>

- (void)cancel;
- (void)resume;

@end

INV_Extension(NSURLSessionTask, INV_NetworkTask_TaskType)

@interface INV_NetworkTask: NSObject

@property (nonatomic, readonly) id <INV_NetworkTask_SessionType> session;

@end

@interface INV_NetworkTask (Cancel)

- (void)cancel;

@end

@interface INV_NetworkTask (Class)

+ (Class <INV_NetworkTask_SessionType>)sessionClass;

@end

@interface INV_NetworkTask (Start)

- (void)startWithRequest:(NSURLRequest *)request completionHandler:(INV_NetworkSession_SessionType_CompletionHandler)completionHandler;

@end
