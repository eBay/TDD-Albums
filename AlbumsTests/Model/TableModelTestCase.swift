//
//  TableModelTestCase.swift
//  Albums
//
//  Created by Rick van Voorden on 3/19/15.
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

final class TableModel_AlbumTestDouble: NSObject, TDD_TableModel_AlbumType {
    
    var dictionary: NSDictionary?
    
    convenience init(dictionary: [NSObject:AnyObject]) {
        
        self.init()
        
        self.dictionary = dictionary
        
    }
    
}

var TableModel_JSONOperationTestDouble_Self: TableModel_JSONOperationTestDouble?

final class TableModel_JSONOperationTestDouble: NSObject, TDD_TableModel_JSONOperationType {
    
    override init() {
        
        super.init()
        
        TableModel_JSONOperationTestDouble_Self = self
        
    }
    
    var completionHandler: TDD_NetworkJSONOperation_CompletionHandler?
    
    var didCancel = false
    
    var request: NSURLRequest?
    
    func cancel() {
        
        self.didCancel = true
        
    }
    
    func startWithRequest(request: NSURLRequest, completionHandler: TDD_NetworkJSONOperation_CompletionHandler) {
        
        self.request = request
        
        self.completionHandler = completionHandler
        
    }
    
}

final class TableModelTestCase: XCTestCase {
    
    lazy var error = ErrorTestDouble()
    
    lazy var json: NSDictionary = {
        
        let url = NSBundle(identifier: "com.ebay.AlbumsTests")!.URLForResource("Albums", withExtension: "json")!
        
        let data = NSData(contentsOfURL: url, options: nil, error: nil)!
        
        return (NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil)! as! NSDictionary)
        
        }()
    
    lazy var model = TableModelTestDouble()
    
    override func tearDown() {
        
        TableModel_JSONOperationTestDouble_Self = nil
        
    }
    
}

extension TableModelTestCase {
    
    func testCancel() {
        
        self.model.startWithCompletionHandler(nil)
        
        let jsonOperation = TableModel_JSONOperationTestDouble_Self!
        
        self.model.cancel()
        
        XCTAssert(jsonOperation.didCancel)
        
    }
    
    func testCancelByItself() {
        
        self.model.cancel()
        
        XCTAssert(TableModel_JSONOperationTestDouble_Self == nil)
        
    }
    
}

extension TableModelTestCase {
    
    func testClass() {
        
        XCTAssert(TDD_TableModel.albumClass()! === TDD_Album.self)
        
        XCTAssert(TDD_TableModel.jsonOperationClass()! === TDD_NetworkJSONOperation.self)
        
    }
    
}

extension TableModelTestCase {
    
    func assertJSONOperation() {
        
        XCTAssert(TableModel_JSONOperationTestDouble_Self!.request!.URL!.absoluteString == "https://itunes.apple.com/us/rss/topalbums/limit=100/json")
        
        XCTAssert(TableModel_JSONOperationTestDouble_Self!.request!.cachePolicy == NSURLRequestCachePolicy.UseProtocolCachePolicy)
        
        XCTAssert(TableModel_JSONOperationTestDouble_Self!.request!.timeoutInterval == 60.0)
        
    }
    
    func assertJSONOperationError() {
        
        self.assertJSONOperation()
        
        TableModel_JSONOperationTestDouble_Self!.completionHandler!(nil, self.error)
        
    }
    
    func assertJSONOperationSuccess() {
        
        self.assertJSONOperation()
        
        TableModel_JSONOperationTestDouble_Self!.completionHandler!(self.json, self.error)
        
    }
    
    func testStartError() {
        
        var didAssertError = false
        
        self.model.startWithCompletionHandler {(success, error) in
            
            XCTAssert(success == false)
            
            XCTAssert(error! === self.error)
            
            XCTAssert(self.model.albums == nil)
            
            didAssertError = true
            
        }
        
        self.assertJSONOperationError()
        
        XCTAssert(didAssertError)
        
    }
    
    func testStartSuccess() {
        
        var didAssertSuccess = false
        
        self.model.startWithCompletionHandler {(success, error) in
            
            XCTAssert(success)
            
            XCTAssert(error == nil)
            
            let feed = (self.json["feed"] as! [NSObject:AnyObject])
            
            let entry = (feed["entry"] as! [[NSObject:AnyObject]])
            
            XCTAssert(self.model.albums.count == entry.count)
            
            for index in 0..<entry.count {
                
                XCTAssert(self.model.albums[index].dictionary == entry[index])
                
            }
            
            didAssertSuccess = true
            
        }
        
        self.assertJSONOperationSuccess()
        
        XCTAssert(didAssertSuccess)
        
    }
    
}

final class TableModelTestDouble: TDD_TableModel {
    
    override class func albumClass() -> AnyClass {
        
        return TableModel_AlbumTestDouble.self
        
    }
    
    override class func jsonOperationClass() -> AnyClass {
        
        return TableModel_JSONOperationTestDouble.self
        
    }
    
}
