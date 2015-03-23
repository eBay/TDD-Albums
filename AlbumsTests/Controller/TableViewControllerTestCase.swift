//
//  TableViewControllerTestCase.swift
//  Albums
//
//  Created by Rick van Voorden on 3/22/15.
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

final class TableViewController_CellTestDouble: NSObject, TDD_TableViewController_CellType {
    
    var album: TDD_TableViewCell_AlbumType?
    
    var reuseIdentifier: String?
    
    var style: UITableViewCellStyle?
    
    convenience init(style: UITableViewCellStyle, reuseIdentifier: String) {
        
        self.init()
        
        self.style = style
        
        self.reuseIdentifier = reuseIdentifier
        
    }
    
}

var TableViewController_ModelTestDouble_Self: TableViewController_ModelTestDouble?

final class TableViewController_ModelTestDouble: NSObject, TDD_TableViewController_ModelType {
    
    override init() {
        
        super.init()
        
        TableViewController_ModelTestDouble_Self = self
        
    }
    
    lazy var albums = ([TDD_Album(), TDD_Album(), TDD_Album()] as [AnyObject])
    
    var completionHandler: TDD_TableModel_CompletionHandler?
    
    func startWithCompletionHandler(completionHandler: TDD_TableModel_CompletionHandler) {
        
        self.completionHandler = completionHandler
        
    }
    
}

final class TableViewController_ViewTestDouble: UIView, TDD_TableViewController_ViewType {
    
    weak var dataSource: TDD_TableViewController_ViewDataSource?
    
    var tddCell: TDD_TableViewController_CellType?
    
    var tddDidReloadData = false
    
    var tddFrame: CGRect?
    
    var tddIdentifier: String?
    
    var tddStyle: UITableViewStyle?
    
    convenience init(frame: CGRect, style: UITableViewStyle) {
        
        self.init(frame: frame)
        
        self.tddFrame = frame
        
        self.tddStyle = style
        
    }
    
    func dequeueReusableCellWithIdentifier(identifier: String) -> TDD_TableViewController_CellType? {
        
        self.tddIdentifier = identifier
        
        return self.tddCell
        
    }
    
    func reloadData() {
        
        self.tddDidReloadData = true
        
    }
    
}

final class TableViewControllerTestCase: XCTestCase {
    
    lazy var controller = TableViewControllerTestDouble()
    
    var controllerView: TableViewController_ViewTestDouble {
        
        return (self.controller.view as! TableViewController_ViewTestDouble)
        
    }
    
    override func tearDown() {
        
        TableViewController_ModelTestDouble_Self = nil
        
    }
    
}

extension TableViewControllerTestCase {
    
    func testClass() {
        
        XCTAssert(TDD_TableViewController.cellClass()! === TDD_TableViewCell.self)
        
        XCTAssert(TDD_TableViewController.modelClass()! === TDD_TableModel.self)
        
        XCTAssert(TDD_TableViewController.viewClass()! === UITableView.self)
        
    }
    
}

extension TableViewControllerTestCase {
    
    func testLoadView() {
        
        XCTAssert(self.controllerView.tddFrame == CGRectZero)
        
        XCTAssert(self.controllerView.tddStyle == UITableViewStyle.Plain)
        
        XCTAssert(self.controllerView.dataSource! === self.controller)
        
    }
    
    func testViewWillAppear() {
        
        self.controller.viewWillAppear(false)
        
        TableViewController_ModelTestDouble_Self!.completionHandler!(true, nil)
        
        XCTAssert(self.controllerView.tddDidReloadData)
        
    }
    
}

extension TableViewControllerTestCase {
    
    func testNumberOfSectionsInTableView() {
        
        XCTAssert(self.controller.numberOfSectionsInTableView(nil) == 1)
        
    }
    
    func testTableViewNumberOfRowsInSection() {
        
        XCTAssert(self.controller.tableView(nil, numberOfRowsInSection: 0) == TableViewController_ModelTestDouble_Self!.albums.count)
        
    }
    
}

final class TableViewControllerTestDouble: TDD_TableViewController {
    
    override class func cellClass() -> AnyClass {
        
        return TableViewController_CellTestDouble.self
        
    }
    
    override class func modelClass() -> AnyClass {
        
        return TableViewController_ModelTestDouble.self
        
    }
    
    override class func viewClass() -> AnyClass {
        
        return TableViewController_ViewTestDouble.self
        
    }
    
}
