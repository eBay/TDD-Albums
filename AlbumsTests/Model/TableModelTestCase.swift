//
//  TableModelTestCase.swift
//  Albums
//
//  Created by Rick van Voorden on 10/30/14.
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

import XCTest

final class TableModel_AlbumTestDouble: NSObject, INV_TableModel_AlbumType {
    
    var dictionary: NSDictionary?
    
    convenience init(dictionary: [NSObject:AnyObject]) {
        
        self.init()
        
        self.dictionary = dictionary
        
    }
    
}

final class TableModel_OperationTestDouble: NSObject, INV_TableModel_OperationType {
    
    var completionHandler: INV_NetworkJSONOperation_CompletionHandler?
    
    var request: NSURLRequest?
    
    func startWithRequest(request: NSURLRequest, completionHandler: INV_NetworkJSONOperation_CompletionHandler) {
        
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
    
    var modelOperation: TableModel_OperationTestDouble {
        
        return (self.model.operation as! TableModel_OperationTestDouble)
        
    }
    
}

extension TableModelTestCase {
    
    func testClass() {
        
        XCTAssertTrue(INV_TableModel.albumClass()! === INV_Album.self)
        
        XCTAssertTrue(INV_TableModel.operationClass()! === INV_NetworkJSONOperation.self)
        
    }
    
}

extension TableModelTestCase {
    
    func testStartError() {
        
        var didStart = false
        
        self.model.startWithCompletionHandler {(success, error) in
            
            didStart = true
            
            XCTAssertFalse(success)
            
            XCTAssertTrue(error! === self.error)
            
            XCTAssertTrue(self.model.albums == nil)
            
        }
        
        XCTAssertTrue(self.modelOperation.request!.URL!.absoluteString == "https://itunes.apple.com/us/rss/topalbums/limit=100/json")
        
        XCTAssertTrue(self.modelOperation.request!.cachePolicy == NSURLRequestCachePolicy.UseProtocolCachePolicy)
        
        XCTAssertTrue(self.modelOperation.request!.timeoutInterval == 60.0)
        
        self.modelOperation.completionHandler!(nil, self.error)
        
        XCTAssertTrue(didStart)
        
    }
    
    func testStartSuccess() {
        
        var didStart = false
        
        self.model.startWithCompletionHandler {(success, error) in
            
            didStart = true
            
            XCTAssertTrue(success)
            
            XCTAssertTrue(error == nil)
            
            let feed = (self.json["feed"] as! NSDictionary)
            
            let entry = (feed["entry"] as! NSArray)
            
            XCTAssertTrue(self.model.albums.count == entry.count)
            
            let dictionary = (entry[0] as! NSDictionary)
            
            XCTAssertTrue(self.model.albums[0].dictionary == dictionary)
            
        }
        
        XCTAssertTrue(self.modelOperation.request!.URL!.absoluteString == "https://itunes.apple.com/us/rss/topalbums/limit=100/json")
        
        XCTAssertTrue(self.modelOperation.request!.cachePolicy == NSURLRequestCachePolicy.UseProtocolCachePolicy)
        
        XCTAssertTrue(self.modelOperation.request!.timeoutInterval == 60.0)
        
        self.modelOperation.completionHandler!(self.json, self.error)
        
        XCTAssertTrue(didStart)
        
    }
    
}

final class TableModelTestDouble: INV_TableModel {
    
    override class func albumClass() -> AnyClass {
        
        return TableModel_AlbumTestDouble.self
        
    }
    
    override class func operationClass() -> AnyClass {
        
        return TableModel_OperationTestDouble.self
        
    }
    
}
