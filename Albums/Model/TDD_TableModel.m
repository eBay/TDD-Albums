//
//  TDD_TableModel.m
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

#import "TDD_Shared.h"
#import "TDD_TableModel.h"

@interface TDD_TableModel ()

@property (nonatomic, strong) NSArray *albums;
@property (nonatomic, strong) id <TDD_TableModel_JSONOperationType> jsonOperation;

@end

@implementation TDD_TableModel

@synthesize jsonOperation = _jsonOperation;

- (id <TDD_TableModel_JSONOperationType>)jsonOperation {
    
    return TDD_LazyPropertyWithClass((self->_jsonOperation), [[self class] jsonOperationClass]);
    
}

@end

@implementation TDD_TableModel (Cancel)

- (void)cancel {
    
    [[self jsonOperation] cancel];
    
}

@end

@implementation TDD_TableModel (Class)

+ (Class <TDD_TableModel_AlbumType>)albumClass {
    
    return [TDD_Album class];
    
}

+ (Class <TDD_TableModel_JSONOperationType>)jsonOperationClass {
    
    return [TDD_NetworkJSONOperation class];
    
}

@end

@implementation TDD_TableModel (Start)

- (void)json:(id)json {
    
    NSMutableArray *newArray = [[NSMutableArray alloc] init];
    
    [[[json objectForKey: @"feed"] objectForKey: @"entry"] enumerateObjectsUsingBlock: ^void (NSDictionary *dictionary, NSUInteger index, BOOL *stop) {
        
        id <TDD_TableModel_AlbumType> album = [[[[self class] albumClass] alloc] initWithDictionary: dictionary];
        
        [newArray addObject: album];
        
    }];
    
    [self setAlbums: newArray];
    
}

- (NSURLRequest *)request {
    
    NSURL *url = [[NSURL alloc] initWithString: @"https://itunes.apple.com/us/rss/topalbums/limit=100/json"];
    
    return [[NSURLRequest alloc] initWithURL: url];
    
}

- (void)startWithCompletionHandler:(TDD_TableModel_CompletionHandler)completionHandler {
    
    TDD_TableModel *__weak weakSelf = self;
    
    [[self jsonOperation] startWithRequest: [self request] completionHandler: ^void (id json, NSError *error) {
        
        TDD_TableModel *strongSelf = weakSelf;
        
        if (strongSelf) {
            
            if (json) {
                
                [strongSelf json: json];
                
                completionHandler(YES, 0);
                
            } else {
                
                completionHandler(NO, error);
                
            }
            
        }
        
    }];
    
}

@end
