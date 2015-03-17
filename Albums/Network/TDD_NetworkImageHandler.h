//
//  TDD_NetworkImageHandler.h
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

@import UIKit;

#import "TDD_NetworkHandler.h"

@protocol TDD_NetworkImageHandler_DataHandlerType <NSObject>

+ (NSData *)dataWithResponse:(TDD_NetworkResponse *)response error:(NSError *__autoreleasing*)error;

@end

@protocol TDD_NetworkImageHandler_ImageType <NSObject>

+ (id <TDD_NetworkImageHandler_ImageType>)alloc;

- (id <TDD_NetworkImageHandler_ImageType>)initWithData:(NSData *)data scale:(CGFloat)scale;

@end

@protocol TDD_NetworkImageHandler_ScreenType <NSObject>

+ (id <TDD_NetworkImageHandler_ScreenType>)mainScreen;

@property (nonatomic, readonly) CGFloat scale;

@end

@interface TDD_NetworkImageHandler: TDD_NetworkHandler

@end

@interface TDD_NetworkImageHandler (Class)

+ (Class <TDD_NetworkImageHandler_ImageType>)imageClass;
+ (Class <TDD_NetworkImageHandler_ScreenType>)screenClass;

@end

@interface TDD_NetworkImageHandler (Image)

+ (id)imageWithResponse:(TDD_NetworkResponse *)response error:(NSError *__autoreleasing*)error;

@end
