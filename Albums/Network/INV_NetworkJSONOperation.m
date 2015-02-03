//
//  INV_NetworkJSONOperation.m
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

#import "INV_NetworkJSONOperation.h"

@implementation INV_NetworkJSONOperation

@synthesize task = _task;

- (void)setTask:(id <INV_NetworkJSONOperation_TaskType>)task {
    
    INV_PropertySetter((self->_task), task, {
        
        [(self->_task) cancel];
        
    }, {
        
        
        
    });
    
}

- (id <INV_NetworkJSONOperation_TaskType>)task {
    
    return INV_LazyPropertyWithClass((self->_task), [[self class] taskClass]);
    
}

@end

@implementation INV_NetworkJSONOperation (Cancel)

- (void)cancel {
    
    [self setTask: 0];
    
}

@end

@implementation INV_NetworkJSONOperation (Class)

+ (Class <INV_NetworkJSONOperation_JSONHandlerType>)jsonHandlerClass {
    
    return [INV_NetworkJSONHandler class];
    
}

+ (Class <INV_NetworkJSONOperation_TaskType>)taskClass {
    
    return [INV_NetworkTask class];
    
}

@end

@implementation INV_NetworkJSONOperation (Start)

- (void)startWithRequest:(NSURLRequest *)request completionHandler:(INV_NetworkJSONOperation_CompletionHandler)completionHandler {
    
    INV_NetworkJSONOperation *__weak weakSelf = self;
    
    [[self task] startWithRequest: request completionHandler: ^void (NSData *data, NSURLResponse *response, NSError *error) {
        
        INV_NetworkJSONOperation *strongSelf = weakSelf;
        
        if (strongSelf) {
            
            INV_NetworkResponse *jsonResponse = [[INV_NetworkResponse alloc] init];
            
            [jsonResponse setData: data];
            
            [jsonResponse setResponse: response];
            
            [jsonResponse setError: error];
            
            NSError *jsonError = 0;
            
            completionHandler([[[strongSelf class] jsonHandlerClass] jsonWithResponse: jsonResponse error: &jsonError], jsonError);
            
        }
        
    }];
    
}

@end
