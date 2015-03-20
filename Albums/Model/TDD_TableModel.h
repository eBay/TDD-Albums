//
//  TDD_TableModel.h
//  Albums
//
//  Created by Rick van Voorden on 3/19/15.
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

#import "TDD_Album.h"
#import "TDD_NetworkJSONOperation.h"

@protocol TDD_TableModel_AlbumType <NSObject>

+ (id <TDD_TableModel_AlbumType>)alloc;

- (id <TDD_TableModel_AlbumType>)initWithDictionary:(NSDictionary *)dictionary;

@end

@protocol TDD_TableModel_JSONOperationType <NSObject>

+ (id <TDD_TableModel_JSONOperationType>)alloc;

- (id <TDD_TableModel_JSONOperationType>)init;
- (void)startWithRequest:(NSURLRequest *)request completionHandler:(TDD_NetworkJSONOperation_CompletionHandler)completionHandler;

@end

typedef void (^TDD_TableModel_CompletionHandler)(BOOL, NSError *);

@interface TDD_TableModel: NSObject

@property (nonatomic, readonly) NSArray *albums;

@end

@interface TDD_TableModel (Class)

+ (Class <TDD_TableModel_AlbumType>)albumClass;
+ (Class <TDD_TableModel_JSONOperationType>)jsonOperationClass;

@end

@interface TDD_TableModel (Start)

- (void)startWithCompletionHandler:(TDD_TableModel_CompletionHandler)completionHandler;

@end
