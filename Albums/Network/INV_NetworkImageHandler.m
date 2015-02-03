//
//  INV_NetworkImageHandler.m
//  Albums
//
//  Created by Rick van Voorden on 10/16/14.
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

@implementation INV_NetworkImageHandler

@end

@implementation INV_NetworkImageHandler (Class)

+ (Class <INV_NetworkImageHandler_DataHandlerType>)dataHandlerClass {
    
    return [INV_NetworkDataHandler class];
    
}

+ (Class <INV_NetworkImageHandler_ImageType>)imageClass {
    
    return [UIImage class];
    
}

+ (Class <INV_NetworkImageHandler_ScreenType>)screenClass {
    
    return [UIScreen class];
    
}

@end

@implementation INV_NetworkImageHandler (Image)

+ (id <INV_NetworkImageHandler_ImageType>)imageWithResponse:(INV_NetworkResponse *)response error:(NSError *__autoreleasing *)error {
    
    NSData *data = [[self dataHandlerClass] dataWithResponse: response error: error];
    
    if (data) {
        
        CGFloat scale = [[[self screenClass] mainScreen] scale];
        
        return [[[self imageClass] alloc] initWithData: data scale: scale];
        
    }
    
    return 0;
    
}

@end
