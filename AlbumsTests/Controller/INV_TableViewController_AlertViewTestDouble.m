//
//  INV_TableViewController_AlertViewTestDouble.m
//  Albums
//
//  Created by Rick van Voorden on 11/21/14.
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

#import "INV_TableViewController_AlertViewTestDouble.h"

@implementation INV_TableViewController_AlertViewTestDouble

- (id <INV_TableViewController_AlertViewType>)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id <INV_TableViewController_AlertViewDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
    
    self = [self init];
    
    if (self) {
        
        [self setTitle: title];
        
        [self setMessage: message];
        
        [self setDelegate: delegate];
        
        [self setCancelButtonTitle: cancelButtonTitle];
        
        [self setOtherButtonTitles: otherButtonTitles];
        
    }
    
    return self;
    
}

- (void)show {
    
    [self setDidShow: YES];
    
}

@end
