//
//  TDD_NetworkDataHandler.m
//  Albums
//
//  Created by Rick van Voorden on 2/11/15.
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

#import "TDD_NetworkDataHandler.h"

NSString *const TDD_NetworkDataHandler_ErrorDomain = @"TDD_NetworkDataHandler_ErrorDomain";

const NSInteger TDD_NetworkDataHandler_DataError = 1;

const NSInteger TDD_NetworkDataHandler_ResponseError = 2;

@implementation NSHTTPURLResponse (TDD_NetworkDataHandler)

- (NSInteger)tdd_statusCode {
    
    return [self statusCode];
    
}

@end

@implementation NSURLResponse (TDD_NetworkDataHandler)

- (NSInteger)tdd_statusCode {
    
    return 0;
    
}

@end

@implementation TDD_NetworkDataHandler

@end

@implementation TDD_NetworkDataHandler (Data)

+ (NSData *)dataWithResponse:(TDD_NetworkResponse *)response error:(NSError *__autoreleasing*)error {
    
    switch ([[response response] tdd_statusCode]) {
            
        case 200:
        {
            if (error) {
                
                NSDictionary *userInfo = @{NSUnderlyingErrorKey:[response error]};
                
                *error = [[NSError alloc] initWithDomain: TDD_NetworkDataHandler_ErrorDomain code: TDD_NetworkDataHandler_DataError userInfo: userInfo];
                
            }
            
            break;
        }
        default:
        {
            if (error) {
                
                NSDictionary *userInfo = ([response error] ? @{NSUnderlyingErrorKey:[response error]} : 0);
                
                *error = [[NSError alloc] initWithDomain: TDD_NetworkDataHandler_ErrorDomain code: TDD_NetworkDataHandler_ResponseError userInfo: userInfo];
                
            }
            
            break;
        }
            
    }
    
    return 0;
    
}

@end
