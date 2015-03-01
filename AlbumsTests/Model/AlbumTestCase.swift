//
//  AlbumTestCase.swift
//  Albums
//
//  Created by Rick van Voorden on 10/28/14.
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

final class AlbumTestCase: XCTestCase {
    
    lazy var json: NSDictionary = {
        
        let url = NSBundle(identifier: "com.ebay.AlbumsTests")!.URLForResource("Albums", withExtension: "json")!
        
        let data = NSData(contentsOfURL: url, options: nil, error: nil)!
        
        return (NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil)! as! NSDictionary)
        
        }()
    
}

extension AlbumTestCase {
    
    func testObject() {
        
        let feed = (self.json["feed"] as! [NSObject:AnyObject])
        
        let entry = (feed["entry"] as! [AnyObject])
        
        let dictionary = (entry[0] as! [NSObject:AnyObject])
        
        let album = INV_Album(dictionary: dictionary)
        
        XCTAssert(album.artist == ((dictionary["im:artist"] as! NSDictionary)["label"] as! String))
        
        XCTAssert(album.image == (((dictionary["im:image"] as! NSArray)[2] as! NSDictionary)["label"] as! String))
        
        XCTAssert(album.link == (((dictionary["link"] as! NSDictionary)["attributes"] as! NSDictionary)["href"] as! String))
        
        XCTAssert(album.name == ((dictionary["im:name"] as! NSDictionary)["label"] as! String))
        
    }
    
}
