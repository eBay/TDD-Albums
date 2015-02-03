//
//  TableViewCellTestCase.swift
//  Albums
//
//  Created by Rick van Voorden on 10/29/14.
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

final class TableViewCell_BeachBoysAlbumTestDouble: NSObject, INV_TableViewCell_AlbumType {
    
    let artist = "Beach Boys"
    
    let image = "http://localhost/pet-sounds.jpeg"
    
    let name = "Pet Sounds"
    
}

final class TableViewCell_BeatlesAlbumTestDouble: NSObject, INV_TableViewCell_AlbumType {
    
    let artist = "Beatles"
    
    let image = "http://localhost/rubber-soul.jpeg"
    
    let name = "Rubber Soul"
    
}

final class TableViewCell_OperationTestDouble: NSObject, INV_TableViewCell_OperationType {
    
    var didCancel = false
    
    var completionHandler: INV_NetworkImageOperation_CompletionHandler?
    
    var request: NSURLRequest?
    
    func cancel() {
        
        self.didCancel = true
        
        self.request = nil
        
        self.completionHandler = nil
        
    }
    
    func startWithRequest(request: NSURLRequest, completionHandler: INV_NetworkImageOperation_CompletionHandler) {
        
        self.request = request
        
        self.completionHandler = completionHandler
        
    }
    
}

final class TableViewCellTestCase: XCTestCase {
    
    lazy var beachBoys = TableViewCell_BeachBoysAlbumTestDouble()
    
    lazy var beatles = TableViewCell_BeatlesAlbumTestDouble()
    
    lazy var cell = TableViewCellTestDouble(style: UITableViewCellStyle.Subtitle, reuseIdentifier: nil)
    
    var cellOperation: TableViewCell_OperationTestDouble {
        
        return (self.cell.operation as TableViewCell_OperationTestDouble)
        
    }
    
    lazy var image = UIImage()
    
}

extension TableViewCellTestCase {
    
    func assertAlbum(album: INV_TableViewCell_AlbumType) {
        
        self.cell.album = album
        
        self.assertCell(album)
        
        self.assertOperation(album)
        
    }
    
    func assertCell(album: INV_TableViewCell_AlbumType) {
        
        XCTAssertTrue(self.cell.textLabel!.text == album.artist)
        
        XCTAssertTrue(self.cell.detailTextLabel!.text == album.name)
        
        XCTAssertTrue(self.cell.imageView!.image == nil)
        
    }
    
    func assertOperation(album: INV_TableViewCell_AlbumType) {
        
        XCTAssertTrue(self.cellOperation.didCancel)
        
        XCTAssertTrue(self.cellOperation.request!.URL.absoluteString == album.image)
        
        XCTAssertTrue(self.cellOperation.request!.cachePolicy == NSURLRequestCachePolicy.UseProtocolCachePolicy)
        
        XCTAssertTrue(self.cellOperation.request!.timeoutInterval == 60.0)
        
        self.cell.didSetNeedsLayout = false
        
        self.cellOperation.completionHandler!(self.image, nil)
        
        XCTAssertTrue(self.cell.imageView!.image! === self.image)
        
        XCTAssertTrue(self.cell.didSetNeedsLayout)
        
    }
    
    func testAlbum() {
        
        self.assertAlbum(self.beachBoys)
        
        self.assertAlbum(self.beatles)
        
    }
    
}

extension TableViewCellTestCase {
    
    func testClass() {
        
        XCTAssertTrue(INV_TableViewCell.operationClass()! === INV_NetworkImageOperation.self)
        
    }
    
}

final class TableViewCellTestDouble: INV_TableViewCell {
    
    var didSetNeedsLayout = false
    
    override class func operationClass() -> AnyClass {
        
        return TableViewCell_OperationTestDouble.self
        
    }
    
    override func setNeedsLayout() {
        
        super.setNeedsLayout()
        
        self.didSetNeedsLayout = true
        
    }
    
}
