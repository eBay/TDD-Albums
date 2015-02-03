//
//  INV_TableViewController.h
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

#import "INV_TableModel.h"
#import "INV_TableViewCell.h"

@protocol INV_TableViewController_AlertViewType;

@protocol INV_TableViewController_AlertViewDelegate <NSObject>

- (void)alertView:(id <INV_TableViewController_AlertViewType>)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@protocol INV_TableViewController_AlertViewType <NSObject>

@property (nonatomic, assign) id <INV_TableViewController_AlertViewDelegate> delegate;

@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *title;

+ (id <INV_TableViewController_AlertViewType>)alloc;

- (id <INV_TableViewController_AlertViewType>)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id <INV_TableViewController_AlertViewDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
- (void)show;

@end

INV_Extension(UIAlertView, INV_TableViewController_AlertViewType)

@protocol INV_TableViewController_ApplicationType <NSObject>

+ (id <INV_TableViewController_ApplicationType>)sharedApplication;

- (void)openURL:(NSURL *)url;

@end

INV_Extension(UIApplication, INV_TableViewController_ApplicationType)

@protocol INV_TableViewController_CellType <NSObject>

+ (id <INV_TableViewController_CellType>)alloc;

@property (nonatomic, strong) id <INV_TableViewCell_AlbumType> album;

- (id <INV_TableViewController_CellType>)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end

INV_Extension(INV_TableViewCell, INV_TableViewController_CellType)

@protocol INV_TableViewController_ModelType <NSObject>

+ (id <INV_TableViewController_ModelType>)alloc;

@property (nonatomic, readonly) NSArray *albums;

- (id <INV_TableViewController_ModelType>)init;
- (void)startWithCompletionHandler:(INV_TableModel_CompletionHandler)completionHandler;

@end

INV_Extension(INV_TableModel, INV_TableViewController_ModelType)

@protocol INV_TableViewController_ViewType;

@protocol INV_TableViewController_ViewDataSource <NSObject>

- (NSInteger)numberOfSectionsInTableView:(id <INV_TableViewController_ViewType>)tableView;
- (id <INV_TableViewController_CellType>)tableView:(id <INV_TableViewController_ViewType>)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)tableView:(id <INV_TableViewController_ViewType>)tableView numberOfRowsInSection:(NSInteger)section;

@end

@protocol INV_TableViewController_ViewDelegate <NSObject>

- (void)tableView:(id <INV_TableViewController_ViewType>)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol INV_TableViewController_ViewType <NSObject>

+ (id <INV_TableViewController_ViewType>)alloc;

@property (nonatomic, assign) id <INV_TableViewController_ViewDataSource> dataSource;
@property (nonatomic, assign) id <INV_TableViewController_ViewDelegate> delegate;

- (id <INV_TableViewController_CellType>)dequeueReusableCellWithIdentifier:(NSString *)identifier;
- (id <INV_TableViewController_ViewType>)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;
- (void)reloadData;

@end

INV_Extension(UITableView, INV_TableViewController_ViewType)

@interface INV_TableViewController: UIViewController

@property (nonatomic, readonly) id <INV_TableViewController_AlertViewType> alertView;
@property (nonatomic, readonly) id <INV_TableViewController_ModelType> model;

@end

@interface INV_TableViewController (Class)

+ (Class <INV_TableViewController_AlertViewType>)alertViewClass;
+ (Class <INV_TableViewController_ApplicationType>)applicationClass;
+ (Class <INV_TableViewController_CellType>)cellClass;
+ (Class <INV_TableViewController_ModelType>)modelClass;
+ (Class <INV_TableViewController_ViewType>)viewClass;

@end

@interface INV_TableViewController (AlertViewDelegate) <INV_TableViewController_AlertViewDelegate>

@end

@interface INV_TableViewController (ViewDataSource) <INV_TableViewController_ViewDataSource>

@end

@interface INV_TableViewController (ViewDelegate) <INV_TableViewController_ViewDelegate>

@end
