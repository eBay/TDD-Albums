//
//  TDD_NetworkTask.h
//  Albums
//
//  Created by Rick van Voorden on 3/1/15.
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

#import "TDD_NetworkSession.h"

@protocol TDD_NetworkTask_TaskType;

@protocol TDD_NetworkTask_SessionType <NSObject>

+ (id <TDD_NetworkTask_SessionType>)alloc;

- (void)cancel;
- (id <TDD_NetworkTask_SessionType>)init;
- (id <TDD_NetworkTask_TaskType>)taskWithRequest:(NSURLRequest *)request completionHandler:(TDD_NetworkSession_CompletionHandler)completionHandler;

@end

@protocol TDD_NetworkTask_TaskType <NSObject>

- (void)cancel;
- (void)resume;

@end

typedef void (^TDD_NetworkTask_CompletionHandler)(NSData *, NSURLResponse *, NSError *);

@interface TDD_NetworkTask: NSObject

@end

@interface TDD_NetworkTask (Cancel)

- (void)cancel;

@end

@interface TDD_NetworkTask (Class)

+ (Class <TDD_NetworkTask_SessionType>)sessionClass;

@end

@interface TDD_NetworkTask (Start)

- (void)startWithRequest:(NSURLRequest *)request completionHandler:(TDD_NetworkTask_CompletionHandler)completionHandler;

@end
