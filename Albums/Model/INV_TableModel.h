//
//  INV_TableModel.h
//  Albums
//
//  Created by Rick van Voorden on 10/30/14.
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

#import "INV_Album.h"
#import "INV_NetworkJSONOperation.h"

@protocol INV_TableModel_AlbumType <NSObject>

+ (id <INV_TableModel_AlbumType>)alloc;

- (id <INV_TableModel_AlbumType>)initWithDictionary:(NSDictionary *)dictionary;

@end

INV_Extension(INV_Album, INV_TableModel_AlbumType)

@protocol INV_TableModel_OperationType <NSObject>

+ (id <INV_TableModel_OperationType>)alloc;

- (id <INV_TableModel_OperationType>)init;
- (void)startWithRequest:(NSURLRequest *)request completionHandler:(INV_NetworkJSONOperation_CompletionHandler)completionHandler;

@end

INV_Extension(INV_NetworkJSONOperation, INV_TableModel_OperationType)

typedef void (^INV_TableModel_CompletionHandler)(BOOL, NSError *);

@interface INV_TableModel: NSObject

@property (nonatomic, readonly) NSArray *albums;
@property (nonatomic, readonly) id <INV_TableModel_OperationType> operation;

@end

@interface INV_TableModel (Class)

+ (Class <INV_TableModel_AlbumType>)albumClass;
+ (Class <INV_TableModel_OperationType>)operationClass;

@end

@interface INV_TableModel (Start)

- (void)startWithCompletionHandler:(INV_TableModel_CompletionHandler)completionHandler;

@end
