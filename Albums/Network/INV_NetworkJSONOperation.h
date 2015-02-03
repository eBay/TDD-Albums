//
//  INV_NetworkJSONOperation.h
//  Albums
//
//  Created by Rick van Voorden on 10/22/14.
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

#import "INV_NetworkJSONHandler.h"
#import "INV_NetworkTask.h"

@protocol INV_NetworkJSONOperation_JSONHandlerType <NSObject>

+ (id)jsonWithResponse:(INV_NetworkResponse *)response error:(NSError *__autoreleasing*)error;

@end

INV_Extension(INV_NetworkJSONHandler, INV_NetworkJSONOperation_JSONHandlerType)

@protocol INV_NetworkJSONOperation_TaskType <NSObject>

+ (id <INV_NetworkJSONOperation_TaskType>)alloc;

- (void)cancel;
- (id <INV_NetworkJSONOperation_TaskType>)init;
- (void)startWithRequest:(NSURLRequest *)request completionHandler:(INV_NetworkSession_SessionType_CompletionHandler)completionHandler;

@end

INV_Extension(INV_NetworkTask, INV_NetworkJSONOperation_TaskType)

typedef void (^INV_NetworkJSONOperation_CompletionHandler)(id, NSError *);

@interface INV_NetworkJSONOperation: NSObject

@property (nonatomic, readonly) id <INV_NetworkJSONOperation_TaskType> task;

@end

@interface INV_NetworkJSONOperation (Cancel)

- (void)cancel;

@end

@interface INV_NetworkJSONOperation (Class)

+ (Class <INV_NetworkJSONOperation_JSONHandlerType>)jsonHandlerClass;
+ (Class <INV_NetworkJSONOperation_TaskType>)taskClass;

@end

@interface INV_NetworkJSONOperation (Start)

- (void)startWithRequest:(NSURLRequest *)request completionHandler:(INV_NetworkJSONOperation_CompletionHandler)completionHandler;

@end
