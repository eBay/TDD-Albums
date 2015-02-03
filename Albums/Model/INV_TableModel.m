//
//  INV_TableModel.m
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

#import "INV_TableModel.h"

@implementation INV_TableModel

@synthesize operation = _operation;

- (id <INV_TableModel_OperationType>)operation {
    
    return INV_LazyPropertyWithClass((self->_operation), [[self class] operationClass]);
    
}

- (void)setAlbums:(NSArray *)albums {
    
    (self->_albums) = albums;
    
}

@end

@implementation INV_TableModel (Class)

+ (Class <INV_TableModel_AlbumType>)albumClass {
    
    return [INV_Album class];
    
}

+ (Class <INV_TableModel_OperationType>)operationClass {
    
    return [INV_NetworkJSONOperation class];
    
}

@end

@implementation INV_TableModel (Start)

- (void)json:(id)json {
    
    NSMutableArray *newArray = [[NSMutableArray alloc] init];
    
    [[[json objectForKey: @"feed"] objectForKey: @"entry"] enumerateObjectsUsingBlock: ^void (NSDictionary *dictionary, NSUInteger index, BOOL *stop) {
        
        id <INV_TableModel_AlbumType> album = [[[[self class] albumClass] alloc] initWithDictionary: dictionary];
        
        [newArray addObject: album];
        
    }];
    
    [self setAlbums: newArray];
    
}

- (void)startWithCompletionHandler:(INV_TableModel_CompletionHandler)completionHandler {
    
    NSURL *url = [[NSURL alloc] initWithString: @"https://itunes.apple.com/us/rss/topalbums/limit=100/json"];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
    
    INV_TableModel *__weak weakSelf = self;
    
    [[self operation] startWithRequest: request completionHandler: ^void (id json, NSError *error) {
        
        INV_TableModel *strongSelf = weakSelf;
        
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
