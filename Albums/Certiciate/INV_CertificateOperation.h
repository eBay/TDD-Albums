//
//  INV_CertificateOperation.h
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

#import "INV_CertificateSerialization.h"
#import "INV_Shared.h"

@protocol INV_CertificateOperation_DataType <NSObject>

+ (id <INV_CertificateOperation_DataType>)alloc;

- (id <INV_CertificateOperation_DataType>)initWithBase64EncodedString:(NSString *)base64EncodedString options:(NSDataBase64DecodingOptions)options;

@end

INV_Extension(NSData, INV_CertificateOperation_DataType)

@protocol INV_CertificateOperation_SerializationType <NSObject>

+ (SecCertificateRef)createCertificateWithData:(id <INV_CertificateOperation_DataType>)data CF_RETURNS_RETAINED;

@end

INV_Extension(INV_CertificateSerialization, INV_CertificateOperation_SerializationType)

@interface INV_CertificateOperation: NSObject

@end

@interface INV_CertificateOperation (Certificate)

+ (SecCertificateRef)createCertificate CF_RETURNS_RETAINED;

@end

@interface INV_CertificateOperation (Class)

+ (Class <INV_CertificateOperation_DataType>)dataClass;
+ (Class <INV_CertificateOperation_SerializationType>)serializationClass;

@end
