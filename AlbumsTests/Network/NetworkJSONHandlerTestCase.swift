//
//  NetworkJSONHandlerTestCase.swift
//  Albums
//
//  Created by Rick van Voorden on 2/15/15.
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

extension TDD_NetworkDataHandler: TDD_NetworkJSONHandler_DataHandlerType {
    
    
    
}

var NetworkJSONHandler_DataHandlerTestDouble_Data: NSData?

var NetworkJSONHandler_DataHandlerTestDouble_Error: NSError?

var NetworkJSONHandler_DataHandlerTestDouble_Response: TDD_NetworkResponse?

final class NetworkJSONHandler_DataHandlerTestDouble: NSObject, TDD_NetworkJSONHandler_DataHandlerType {
    
    class func dataWithResponse(response: TDD_NetworkResponse, error: NSErrorPointer) -> NSData? {
        
        NetworkJSONHandler_DataHandlerTestDouble_Response = response
        
        if error != nil {
            
            error.memory = NetworkJSONHandler_DataHandlerTestDouble_Error
            
        }
        
        return NetworkJSONHandler_DataHandlerTestDouble_Data
        
    }
    
}

final class NetworkJSONHandlerTestCase: XCTestCase {
    
    var error: NSError?
    
    lazy var response = TDD_NetworkResponse()
    
    override func tearDown() {
        
        NetworkJSONHandler_DataHandlerTestDouble_Data = nil
        
        NetworkJSONHandler_DataHandlerTestDouble_Error = nil
        
        NetworkJSONHandler_DataHandlerTestDouble_Response = nil
        
    }
    
}

extension NetworkJSONHandlerTestCase {
    
    func testClass() {
        
        XCTAssertTrue(TDD_NetworkJSONHandler.dataHandlerClass()! === TDD_NetworkDataHandler.self)
        
        XCTAssertTrue(TDD_NetworkJSONHandler.jsonSerializationClass()! === NSJSONSerialization.self)
        
    }
    
}

extension NetworkJSONHandlerTestCase {
    
    func testError() {
        
        NetworkJSONHandler_DataHandlerTestDouble_Error = ErrorTestDouble()
        
        XCTAssertTrue(NetworkJSONHandlerTestDouble.jsonWithResponse(self.response, error: &self.error) == nil)
        
        XCTAssertTrue(NetworkJSONHandler_DataHandlerTestDouble_Response! === self.response)
        
        XCTAssertTrue(self.error! === NetworkJSONHandler_DataHandlerTestDouble_Error)
        
    }
    
}

final class NetworkJSONHandlerTestDouble: TDD_NetworkJSONHandler {
    
    override class func dataHandlerClass() -> AnyClass {
        
        return NetworkJSONHandler_DataHandlerTestDouble.self
        
    }
    
}
