//
//  TDD_NetworkSession.h
//  Albums
//
//  Created by Rick van Voorden on 2/27/15.
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

@import Foundation;

@protocol TDD_NetworkSession_ConfigurationType <NSObject>

+ (id <TDD_NetworkSession_ConfigurationType>)ephemeralSessionConfiguration;

@end

typedef void (^TDD_NetworkSession_CompletionHandler)(NSData *, NSURLResponse *, NSError *);

@interface TDD_NetworkSession: NSObject

@end

@interface TDD_NetworkSession (Class)

+ (Class <TDD_NetworkSession_ConfigurationType>)configurationClass;

@end

@interface TDD_NetworkSession (Task)

- (id)taskWithRequest:(NSURLRequest *)request completionHandler:(TDD_NetworkSession_CompletionHandler)completionHandler;

@end
