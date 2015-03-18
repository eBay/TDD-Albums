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

var NetworkJSONHandler_DataHandlerTestDouble_Data: NSData?

var NetworkJSONHandler_DataHandlerTestDouble_Error: NSError?

var NetworkJSONHandler_DataHandlerTestDouble_Response: TDD_NetworkResponse?

final class NetworkJSONHandler_DataHandlerTestDouble: NSObject, TDD_NetworkHandler_DataHandlerType {
    
    class func dataWithResponse(response: TDD_NetworkResponse, error: NSErrorPointer) -> NSData? {
        
        NetworkJSONHandler_DataHandlerTestDouble_Response = response
        
        if error != nil {
            
            error.memory = NetworkJSONHandler_DataHandlerTestDouble_Error
            
        }
        
        return NetworkJSONHandler_DataHandlerTestDouble_Data
        
    }
    
}

var NetworkJSONHandler_JSONSerializationTestDouble_Data: NSData?

var NetworkJSONHandler_JSONSerializationTestDouble_Error: NSError?

var NetworkJSONHandler_JSONSerializationTestDouble_JSON: NSObject?

var NetworkJSONHandler_JSONSerializationTestDouble_Options: NSJSONReadingOptions?

final class NetworkJSONHandler_JSONSerializationTestDouble: NSObject, TDD_NetworkJSONHandler_JSONSerializationType {
    
    class func JSONObjectWithData(data: NSData, options: NSJSONReadingOptions, error: NSErrorPointer) -> AnyObject? {
        
        NetworkJSONHandler_JSONSerializationTestDouble_Data = data
        
        NetworkJSONHandler_JSONSerializationTestDouble_Options = options
        
        if error != nil {
            
            error.memory = NetworkJSONHandler_JSONSerializationTestDouble_Error
            
        }
        
        return NetworkJSONHandler_JSONSerializationTestDouble_JSON
        
    }
    
}

final class NetworkJSONHandlerTestCase: XCTestCase {
    
    var error: NSError?
    
    lazy var response = TDD_NetworkResponse()
    
    override func tearDown() {
        
        NetworkJSONHandler_DataHandlerTestDouble_Data = nil
        
        NetworkJSONHandler_DataHandlerTestDouble_Error = nil
        
        NetworkJSONHandler_DataHandlerTestDouble_Response = nil
        
        NetworkJSONHandler_JSONSerializationTestDouble_Data = nil
        
        NetworkJSONHandler_JSONSerializationTestDouble_Error = nil
        
        NetworkJSONHandler_JSONSerializationTestDouble_JSON = nil
        
        NetworkJSONHandler_JSONSerializationTestDouble_Options = nil
        
    }
    
}

extension NetworkJSONHandlerTestCase {
    
    func testClass() {
        
        XCTAssert(TDD_NetworkJSONHandler.dataHandlerClass()! === TDD_NetworkDataHandler.self)
        
        XCTAssert(TDD_NetworkJSONHandler.jsonSerializationClass()! === NSJSONSerialization.self)
        
    }
    
}

extension NetworkJSONHandlerTestCase {
    
    func testError() {
        
        NetworkJSONHandler_DataHandlerTestDouble_Error = ErrorTestDouble()
        
        XCTAssert(NetworkJSONHandlerTestDouble.jsonWithResponse(self.response, error: &self.error) == nil)
        
        XCTAssert(NetworkJSONHandler_DataHandlerTestDouble_Response! === self.response)
        
        XCTAssert(self.error! === NetworkJSONHandler_DataHandlerTestDouble_Error)
        
    }
    
    func testSuccess() {
        
        NetworkJSONHandler_DataHandlerTestDouble_Data = DataTestDouble()
        
        NetworkJSONHandler_JSONSerializationTestDouble_JSON = NSObject()
        
        NetworkJSONHandler_JSONSerializationTestDouble_Error = ErrorTestDouble()
        
        XCTAssert(NetworkJSONHandlerTestDouble.jsonWithResponse(self.response, error: &self.error)! === NetworkJSONHandler_JSONSerializationTestDouble_JSON)
        
        XCTAssert(NetworkJSONHandler_JSONSerializationTestDouble_Data! === NetworkJSONHandler_DataHandlerTestDouble_Data)
        
        XCTAssert(NetworkJSONHandler_JSONSerializationTestDouble_Options!.rawValue == 0)
        
        XCTAssert(NetworkJSONHandler_DataHandlerTestDouble_Response! === self.response)
        
        XCTAssert(self.error! === NetworkJSONHandler_JSONSerializationTestDouble_Error)
        
    }
    
}

final class NetworkJSONHandlerTestDouble: TDD_NetworkJSONHandler {
    
    override class func dataHandlerClass() -> AnyClass {
        
        return NetworkJSONHandler_DataHandlerTestDouble.self
        
    }
    
    override class func jsonSerializationClass() -> AnyClass {
        
        return NetworkJSONHandler_JSONSerializationTestDouble.self
        
    }
    
}
