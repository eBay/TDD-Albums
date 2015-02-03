//
//  INV_NetworkImageOperation.h
//  Albums
//
//  Created by Rick van Voorden on 10/27/14.
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

#import "INV_NetworkImageHandler.h"
#import "INV_NetworkTask.h"

@protocol INV_NetworkImageOperation_ImageHandlerType <NSObject>

+ (id)imageWithResponse:(INV_NetworkResponse *)response error:(NSError *__autoreleasing*)error;

@end

INV_Extension(INV_NetworkImageHandler, INV_NetworkImageOperation_ImageHandlerType)

@protocol INV_NetworkImageOperation_TaskType <NSObject>

+ (id <INV_NetworkImageOperation_TaskType>)alloc;

- (void)cancel;
- (id <INV_NetworkImageOperation_TaskType>)init;
- (void)startWithRequest:(NSURLRequest *)request completionHandler:(INV_NetworkSession_SessionType_CompletionHandler)completionHandler;

@end

INV_Extension(INV_NetworkTask, INV_NetworkImageOperation_TaskType)

typedef void (^INV_NetworkImageOperation_CompletionHandler)(id, NSError *);

@interface INV_NetworkImageOperation: NSObject

@property (nonatomic, readonly) id <INV_NetworkImageOperation_TaskType> task;

@end

@interface INV_NetworkImageOperation (Cancel)

- (void)cancel;

@end

@interface INV_NetworkImageOperation (Class)

+ (Class <INV_NetworkImageOperation_ImageHandlerType>)imageHandlerClass;
+ (Class <INV_NetworkImageOperation_TaskType>)taskClass;

@end

@interface INV_NetworkImageOperation (Start)

- (void)startWithRequest:(NSURLRequest *)request completionHandler:(INV_NetworkImageOperation_CompletionHandler)completionHandler;

@end
