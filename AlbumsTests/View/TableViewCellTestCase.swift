//
//  TableViewCellTestCase.swift
//  Albums
//
//  Created by Rick van Voorden on 3/21/15.
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

final class TableViewCell_BeachBoysAlbumTestDouble: NSObject, TDD_TableViewCell_AlbumType {
    
    let artist = "Beach Boys"
    
    let image = "http://localhost/pet-sounds.jpeg"
    
    let name = "Pet Sounds"
    
}

final class TableViewCell_BeatlesAlbumTestDouble: NSObject, TDD_TableViewCell_AlbumType {
    
    let artist = "Beatles"
    
    let image = "http://localhost/rubber-soul.jpeg"
    
    let name = "Rubber Soul"
    
}

final class TableViewCellTestCase: XCTestCase {
    
    lazy var beachBoys = TableViewCell_BeachBoysAlbumTestDouble()
    
    lazy var beatles = TableViewCell_BeatlesAlbumTestDouble()
    
    lazy var cell = TDD_TableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: nil)
    
}

extension TableViewCellTestCase {
    
    func assertCell(album: TDD_TableViewCell_AlbumType?) {
        
        XCTAssert(self.cell.textLabel!.text == album?.artist)
        
        XCTAssert(self.cell.detailTextLabel!.text == album?.name)
        
        XCTAssert(self.cell.imageView!.image == nil)
        
    }
    
    func testAlbum() {
        
        self.cell.album = self.beachBoys
        
        self.assertCell(self.beachBoys)
        
        self.cell.album = self.beatles
        
        self.assertCell(self.beatles)
        
        self.cell.album = nil
        
        self.assertCell(nil)
        
    }
    
}

extension TableViewCellTestCase {
    
    func testClass() {
        
        XCTAssert(TDD_TableViewCell.imageOperationClass()! === TDD_NetworkImageOperation.self)
        
    }
    
}
