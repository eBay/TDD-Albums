//
//  INV_CertificateSerializationTestCase.m
//  Albums
//
//  Created by Rick van Voorden on 11/3/14.
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

#import "INV_CertificateSerializationTestCase.h"
#import "INV_Shared.h"

static id INV_CertificateSerialization_SerializationFunctionTestDouble_Allocator = 0;

static id INV_CertificateSerialization_SerializationFunctionTestDouble_Certificate = 0;

static id INV_CertificateSerialization_SerializationFunctionTestDouble_Data = 0;

static SecCertificateRef INV_CertificateSerialization_SerializationFunctionTestDouble(CFAllocatorRef allocator, CFDataRef data) {
    
    INV_CertificateSerialization_SerializationFunctionTestDouble_Allocator = (__bridge id)allocator;
    
    INV_CertificateSerialization_SerializationFunctionTestDouble_Data = (__bridge id)data;
    
    return (__bridge SecCertificateRef)INV_CertificateSerialization_SerializationFunctionTestDouble_Certificate;
    
}

@implementation INV_CertificateSerializationTestCase

@synthesize data = _data;

- (NSData *)data {
    
    return INV_LazyPropertyWithExpression((self->_data), {
        
        uint8_t bytes[1] = { 0 };
        
        (self->_data) = [[NSData alloc] initWithBytes: bytes length: 1];
        
    });
    
}

@end

@implementation INV_CertificateSerializationTestCase (Certificate)

- (void)testCertificate {
    
    INV_CertificateSerialization_SerializationFunctionTestDouble_Certificate = [[NSObject alloc] init];
    
    XCTAssert([INV_CertificateSerializationTestDouble createCertificateWithData: [self data]] == (__bridge SecCertificateRef)INV_CertificateSerialization_SerializationFunctionTestDouble_Certificate);
    
    XCTAssert(INV_CertificateSerialization_SerializationFunctionTestDouble_Allocator == 0);
    
    XCTAssert(INV_CertificateSerialization_SerializationFunctionTestDouble_Data == [self data]);
    
}

@end

@implementation INV_CertificateSerializationTestCase (Class)

- (void)testClass {
    
    XCTAssert([INV_CertificateSerialization serializationFunction] == SecCertificateCreateWithData);
    
}

@end

@implementation INV_CertificateSerializationTestDouble

+ (INV_CertificateSerialization_SerializationFunction)serializationFunction {
    
    return INV_CertificateSerialization_SerializationFunctionTestDouble;
    
}

@end
