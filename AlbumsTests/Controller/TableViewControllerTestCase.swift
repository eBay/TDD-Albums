//
//  TableViewControllerTestCase.swift
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

final class TableViewController_AlbumTestDouble: INV_Album {
    
    override var link: String {
        
        return "http://localhost/"
        
    }
    
}

let TableViewController_ApplicationTestDouble_SharedApplication = TableViewController_ApplicationTestDouble()

final class TableViewController_ApplicationTestDouble: NSObject, INV_TableViewController_ApplicationType {
    
    var url: NSURL?
    
    class func sharedApplication() -> INV_TableViewController_ApplicationType {
        
        return TableViewController_ApplicationTestDouble_SharedApplication
        
    }
    
    func openURL(url: NSURL) {
        
        self.url = url
        
    }
    
}

final class TableViewController_CellTestDouble: NSObject, INV_TableViewController_CellType {
    
    var album: INV_TableViewCell_AlbumType?
    
    var reuseIdentifier: String?
    
    var style: UITableViewCellStyle?
    
    convenience init(style: UITableViewCellStyle, reuseIdentifier: String) {
        
        self.init()
        
        self.style = style
        
        self.reuseIdentifier = reuseIdentifier
        
    }
    
}

final class TableViewController_ModelTestDouble: NSObject, INV_TableViewController_ModelType {
    
    lazy var albums = ([TableViewController_AlbumTestDouble()] as [AnyObject])
    
    var completionHandler: INV_TableModel_CompletionHandler?
    
    func startWithCompletionHandler(completionHandler: INV_TableModel_CompletionHandler) {
        
        self.completionHandler = completionHandler
        
    }
    
}

final class TableViewController_ViewTestDouble: UIView, INV_TableViewController_ViewType {
    
    var cell: INV_TableViewController_CellType?
    
    weak var dataSource: INV_TableViewController_ViewDataSource?
    
    weak var delegate: INV_TableViewController_ViewDelegate?
    
    var didReloadData = false
    
    var identifier: String?
    
    var invFrame: CGRect?
    
    var invStyle: UITableViewStyle?
    
    convenience init(frame: CGRect, style: UITableViewStyle) {
        
        self.init(frame: frame)
        
        self.invFrame = frame
        
        self.invStyle = style
        
    }
    
    func dequeueReusableCellWithIdentifier(identifier: String) -> INV_TableViewController_CellType? {
        
        self.identifier = identifier
        
        return self.cell
        
    }
    
    func reloadData() {
        
        self.didReloadData = true
        
    }
    
}

final class TableViewControllerTestCase: XCTestCase {
    
    lazy var controller = TableViewControllerTestDouble()
    
    var controllerAlertView: INV_TableViewController_AlertViewTestDouble {
        
        return (self.controller.alertView as! INV_TableViewController_AlertViewTestDouble)
        
    }
    
    var controllerModel: TableViewController_ModelTestDouble {
        
        return (self.controller.model as! TableViewController_ModelTestDouble)
        
    }
    
    var controllerView: TableViewController_ViewTestDouble {
        
        return (self.controller.view as! TableViewController_ViewTestDouble)
        
    }
    
}

extension TableViewControllerTestCase {
    
    func testClass() {
        
        XCTAssert(INV_TableViewController.alertViewClass()! === UIAlertView.self)
        
        XCTAssert(INV_TableViewController.applicationClass()! === UIApplication.self)
        
        XCTAssert(INV_TableViewController.cellClass()! === INV_TableViewCell.self)
        
        XCTAssert(INV_TableViewController.modelClass()! === INV_TableModel.self)
        
        XCTAssert(INV_TableViewController.viewClass()! === UITableView.self)
        
    }
    
}

extension TableViewControllerTestCase {
    
    func testLoadView() {
        
        XCTAssert(self.controllerView.invFrame == CGRectZero)
        
        XCTAssert(self.controllerView.invStyle == UITableViewStyle.Plain)
        
        XCTAssert(self.controllerView.dataSource! === self.controller)
        
        XCTAssert(self.controllerView.delegate! === self.controller)
        
    }
    
    func testViewWillAppear() {
        
        self.controller.viewWillAppear(false)
        
        self.controllerModel.completionHandler!(true, nil)
        
        XCTAssert(self.controllerView.didReloadData)
        
    }
    
}

extension TableViewControllerTestCase {
    
    func testNumberOfSectionsInTableView() {
        
        XCTAssert(self.controller.numberOfSectionsInTableView(nil) == 1)
        
    }
    
    func testTableViewCellForRowAtIndexPathReturnsCell() {
        
        self.controllerView.cell = TableViewController_CellTestDouble()
        
        let cell = (self.controller.tableView(self.controllerView, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as! TableViewController_CellTestDouble)
        
        XCTAssert(cell === self.controllerView.cell)
        
        XCTAssert(self.controllerView.identifier == "TableViewController")
        
        XCTAssert(cell.album! === self.controllerModel.albums[0])
        
    }
    
    func testTableViewCellForRowAtIndexPathReturnsNil() {
        
        let cell = (self.controller.tableView(self.controllerView, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as! TableViewController_CellTestDouble)
        
        XCTAssert(cell.style == UITableViewCellStyle.Subtitle)
        
        XCTAssert(cell.reuseIdentifier == "TableViewController")
        
        XCTAssert(self.controllerView.identifier == "TableViewController")
        
        XCTAssert(cell.album! === self.controllerModel.albums[0])
        
    }
    
    func testTableViewNumberOfRowsInSection() {
        
        XCTAssert(self.controller.tableView(nil, numberOfRowsInSection: 0) == self.controllerModel.albums.count)
        
    }
    
}

extension TableViewControllerTestCase {
    
    func testTableViewDidSelectRowAtIndexPath() {
        
        self.controller.tableView(nil, didSelectRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
        
        XCTAssert(self.controllerAlertView.title == "Open in iTunes")
        
        XCTAssert(self.controllerAlertView.message == "Are you sure you want to leave Albums?")
        
        XCTAssert(self.controllerAlertView.delegate! === self.controller)
        
        XCTAssert(self.controllerAlertView.cancelButtonTitle == "Cancel")
        
        XCTAssert(self.controllerAlertView.otherButtonTitles == "OK")
        
        XCTAssert(self.controllerAlertView.didShow);
        
    }
    
}

extension TableViewControllerTestCase {
    
    func testAlertViewClickedCancel() {
        
        self.controller.alertView(nil, clickedButtonAtIndex: 0)
        
        XCTAssert(TableViewController_ApplicationTestDouble_SharedApplication.url == nil)
        
    }
    
    func testAlertViewClickedOK() {
        
        self.controller.tableView(nil, didSelectRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
        
        self.controller.alertView(nil, clickedButtonAtIndex: 1)
        
        let album = (self.controllerModel.albums[0] as! INV_Album)
        
        XCTAssert(TableViewController_ApplicationTestDouble_SharedApplication.url!.absoluteString == album.link)
        
    }
    
}

final class TableViewControllerTestDouble: INV_TableViewController {
    
    override class func alertViewClass() -> AnyClass {
        
        return INV_TableViewController_AlertViewTestDouble.self
        
    }
    
    override class func applicationClass() -> AnyClass {
        
        return TableViewController_ApplicationTestDouble.self
        
    }
    
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
