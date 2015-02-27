//
//  NetworkImageHandlerTestCase.swift
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

import XCTest

extension TDD_NetworkDataHandler: TDD_NetworkImageHandler_DataHandlerType {
    
    
    
}

var NetworkImageHandler_DataHandlerTestDouble_Data: NSData?

var NetworkImageHandler_DataHandlerTestDouble_Error: NSError?

var NetworkImageHandler_DataHandlerTestDouble_Response: TDD_NetworkResponse?

final class NetworkImageHandler_DataHandlerTestDouble: NSObject, TDD_NetworkImageHandler_DataHandlerType {
    
    class func dataWithResponse(response: TDD_NetworkResponse, error: NSErrorPointer) -> NSData? {
        
        NetworkImageHandler_DataHandlerTestDouble_Response = response
        
        if error != nil {
            
            error.memory = NetworkImageHandler_DataHandlerTestDouble_Error
            
        }
        
        return NetworkImageHandler_DataHandlerTestDouble_Data
        
    }
    
}

extension UIImage: TDD_NetworkImageHandler_ImageType {
    
    
    
}

final class NetworkImageHandler_ImageTestDouble: NSObject, TDD_NetworkImageHandler_ImageType {
    
    var data: NSData?
    
    var scale: CGFloat?
    
    convenience init(data: NSData, scale: CGFloat) {
        
        self.init()
        
        self.data = data
        
        self.scale = scale
        
    }
    
}

final class NetworkImageHandlerTestCase: XCTestCase {
    
    var error: NSError?
    
    lazy var response = TDD_NetworkResponse()
    
    override func tearDown() {
        
        NetworkImageHandler_DataHandlerTestDouble_Data = nil
        
        NetworkImageHandler_DataHandlerTestDouble_Error = nil
        
        NetworkImageHandler_DataHandlerTestDouble_Response = nil
        
    }
    
}

extension NetworkImageHandlerTestCase {
    
    func testClass() {
        
        XCTAssertTrue(TDD_NetworkImageHandler.dataHandlerClass()! === TDD_NetworkDataHandler.self)
        
        XCTAssertTrue(TDD_NetworkImageHandler.imageClass()! === UIImage.self)
        
    }
    
}

extension NetworkImageHandlerTestCase {
    
    func testError() {
        
        NetworkImageHandler_DataHandlerTestDouble_Error = ErrorTestDouble()
        
        XCTAssertTrue(NetworkImageHandlerTestDouble.imageWithResponse(self.response, error: &self.error) == nil)
        
        XCTAssertTrue(NetworkImageHandler_DataHandlerTestDouble_Response! === self.response)
        
        XCTAssertTrue(self.error! === NetworkImageHandler_DataHandlerTestDouble_Error)
        
    }
    
    func testSuccess() {
        
        NetworkImageHandler_DataHandlerTestDouble_Data = DataTestDouble()
        
        NetworkImageHandler_DataHandlerTestDouble_Error = ErrorTestDouble()
        
        let image = (NetworkImageHandlerTestDouble.imageWithResponse(self.response, error: &self.error) as! NetworkImageHandler_ImageTestDouble)
        
        XCTAssertTrue(image.data! === NetworkImageHandler_DataHandlerTestDouble_Data)
        
        XCTAssertTrue(image.scale == 0)
        
        XCTAssertTrue(NetworkImageHandler_DataHandlerTestDouble_Response! === self.response)
        
        XCTAssertTrue(self.error! === NetworkImageHandler_DataHandlerTestDouble_Error)
        
    }
    
}

final class NetworkImageHandlerTestDouble: TDD_NetworkImageHandler {
    
    override class func dataHandlerClass() -> AnyClass {
        
        return NetworkImageHandler_DataHandlerTestDouble.self
        
    }
    
    override class func imageClass() -> AnyClass {
        
        return NetworkImageHandler_ImageTestDouble.self
        
    }
    
}
