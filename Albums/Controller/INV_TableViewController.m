//
//  INV_TableViewController.m
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

#import "INV_TableViewController.h"

@interface INV_TableViewController ()

@property (nonatomic, strong) INV_Album *album;

@end

@implementation INV_TableViewController

@synthesize model = _model;

- (id <INV_TableViewController_ModelType>)model {
    
    return INV_LazyPropertyWithClass((self->_model), [[self class] modelClass]);
    
}

- (void)setAlertView:(id <INV_TableViewController_AlertViewType>)alertView {
    
    (self->_alertView) = alertView;
    
}

- (void)setModel:(id <INV_TableViewController_ModelType>)model {
    
    (self->_model) = model;
    
}

@end

@implementation INV_TableViewController (Class)

+ (Class <INV_TableViewController_AlertViewType>)alertViewClass {
    
    return [UIAlertView class];
    
}

+ (Class <INV_TableViewController_ApplicationType>)applicationClass {
    
    return [UIApplication class];
    
}

+ (Class <INV_TableViewController_CellType>)cellClass {
    
    return [INV_TableViewCell class];
    
}

+ (Class <INV_TableViewController_ModelType>)modelClass {
    
    return [INV_TableModel class];
    
}

+ (Class <INV_TableViewController_ViewType>)viewClass {
    
    return [UITableView class];
    
}

@end

@implementation INV_TableViewController (ViewController)

- (void)loadView {
    
    id <INV_TableViewController_ViewType> view = [[[[self class] viewClass] alloc] initWithFrame: CGRectZero style: UITableViewStylePlain];
    
    [view setDataSource: self];
    
    [view setDelegate: self];
    
    [self setView: view];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear: animated];
    
    INV_TableViewController *__weak weakSelf = self;
    
    [[self model] startWithCompletionHandler: ^void (BOOL success, NSError *error) {
        
        id <INV_TableViewController_ViewType> view = [weakSelf view];
        
        [view reloadData];
        
    }];
    
}

@end

@implementation INV_TableViewController (ViewDataSource)

- (NSInteger)numberOfSectionsInTableView:(id <INV_TableViewController_ViewType>)tableView {
    
    return 1;
    
}

- (id <INV_TableViewController_CellType>)tableView:(id <INV_TableViewController_ViewType>)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id <INV_TableViewController_CellType> cell = [tableView dequeueReusableCellWithIdentifier: @"TableViewController"];
    
    if (cell == 0) {
        
        cell = [[[[self class] cellClass] alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: @"TableViewController"];
        
    }
    
    NSUInteger row = [indexPath row];
    
    id <INV_TableViewCell_AlbumType> album = [[[self model] albums] objectAtIndex: row];
    
    [cell setAlbum: album];
    
    return cell;
    
}

- (NSInteger)tableView:(id <INV_TableViewController_ViewType>)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[[self model] albums] count];
    
}

@end

@implementation INV_TableViewController (ViewDelegate)

- (void)tableView:(id <INV_TableViewController_ViewType>)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger row = [indexPath row];
    
    INV_Album *album = [[[self model] albums] objectAtIndex: row];
    
    [self setAlbum: album];
    
    id <INV_TableViewController_AlertViewType> alertView = [[[[self class] alertViewClass] alloc] initWithTitle: @"Open in iTunes" message: @"Are you sure you want to leave Albums?" delegate: self cancelButtonTitle: @"Cancel" otherButtonTitles: @"OK", nil];
    
    [self setAlertView: alertView];
    
    [[self alertView] show];
    
}

@end

@implementation INV_TableViewController (AlertViewDelegate)

- (void)alertView:(id <INV_TableViewController_AlertViewType>)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex) {
        
        NSURL *url = [[NSURL alloc] initWithString: [[self album] link]];
        
        [[[[self class] applicationClass] sharedApplication] openURL: url];
        
    }
    
}

@end
