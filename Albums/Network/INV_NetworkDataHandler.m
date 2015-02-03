//
//  INV_NetworkDataHandler.m
//  Albums
//
//  Created by Rick van Voorden on 1/8/15.
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

#import "INV_NetworkDataHandler.h"

NSString *const INV_NetworkDataHandler_ErrorDomain = @"INV_NetworkDataHandler_ErrorDomain";

const NSInteger INV_NetworkDataHandler_DataError = 1;

const NSInteger INV_NetworkDataHandler_ResponseError = 2;

@implementation NSHTTPURLResponse (INV_NetworkDataHandler)

- (NSInteger)inv_statusCode {
    
    return [self statusCode];
    
}

@end

@implementation NSURLResponse (INV_NetworkDataHandler)

- (NSInteger)inv_statusCode {
    
    return 0;
    
}

@end

@implementation INV_NetworkDataHandler

@end

@implementation INV_NetworkDataHandler (Data)

+ (NSData *)dataWithResponse:(INV_NetworkResponse *)response error:(NSError *__autoreleasing*)error {
    
    switch ([[response response] inv_statusCode]) {
            
        case 200:
        {
            if ([response data]) {
                
                return [response data];
                
            }
            
            if (error) {
                
                NSDictionary *userInfo = ([response error] ? @{NSUnderlyingErrorKey:[response error]} : 0);
                
                *error = [[NSError alloc] initWithDomain: INV_NetworkDataHandler_ErrorDomain code: INV_NetworkDataHandler_DataError userInfo: userInfo];
                
            }
            
            break;
        }
        default:
        {
            if (error) {
                
                NSDictionary *userInfo = ([response error] ? @{NSUnderlyingErrorKey:[response error]} : 0);
                
                *error = [[NSError alloc] initWithDomain: INV_NetworkDataHandler_ErrorDomain code: INV_NetworkDataHandler_ResponseError userInfo: userInfo];
                
            }
            
            break;
        }
            
    }
    
    return 0;
    
}

@end
