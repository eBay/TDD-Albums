//
//  INV_NetworkJSONHandler.m
//  Albums
//
//  Created by Rick van Voorden on 10/13/14.
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

#import "INV_NetworkJSONHandler.h"

@implementation INV_NetworkJSONHandler

@end

@implementation INV_NetworkJSONHandler (Class)

+ (Class <INV_NetworkJSONHandler_DataHandlerType>)dataHandlerClass {
    
    return [INV_NetworkDataHandler class];
    
}

+ (Class <INV_NetworkJSONHandler_JSONSerializationType>)jsonSerializationClass {
    
    return [NSJSONSerialization class];
    
}

@end

@implementation INV_NetworkJSONHandler (JSON)

+ (id)jsonWithResponse:(INV_NetworkResponse *)response error:(NSError *__autoreleasing*)error {
    
    NSData *data = [[self dataHandlerClass] dataWithResponse: response error: error];
    
    if (data) {
        
        return [[self jsonSerializationClass] JSONObjectWithData: data options: 0 error: error];
        
    }
    
    return 0;
    
}

@end
