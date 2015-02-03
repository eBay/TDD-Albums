//
//  INV_TableViewCell.m
//  Albums
//
//  Created by Rick van Voorden on 10/29/14.
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

#import "INV_TableViewCell.h"

@implementation INV_TableViewCell

@synthesize operation = _operation;

- (id <INV_TableViewCell_OperationType>)operation {
    
    return INV_LazyPropertyWithClass((self->_operation), [[self class] operationClass]);
    
}

- (void)setAlbum:(id <INV_TableViewCell_AlbumType>)album {
    
    INV_PropertySetter((self->_album), album, {
        
        [[self imageView] setImage: 0];
        
        [[self operation] cancel];
        
    }, {
        
        [[self textLabel] setText: [(self->_album) artist]];
        
        [[self detailTextLabel] setText: [(self->_album) name]];
        
        if ([(self->_album) image]) {
            
            NSURL *url = [[NSURL alloc] initWithString: [(self->_album) image]];
            
            NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
            
            INV_TableViewCell *__weak weakSelf = self;
            
            [[self operation] startWithRequest: request completionHandler: ^void (id image, NSError *error) {
                
                [[weakSelf imageView] setImage: image];
                
                [weakSelf setNeedsLayout];
                
            }];
            
        }
        
    });
    
}

@end

@implementation INV_TableViewCell (Class)

+ (Class <INV_TableViewCell_OperationType>)operationClass {
    
    return [INV_NetworkImageOperation class];
    
}

@end
