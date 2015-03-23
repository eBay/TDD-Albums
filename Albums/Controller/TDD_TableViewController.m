//
//  TDD_TableViewController.m
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

#import "TDD_Shared.h"
#import "TDD_TableViewController.h"

@implementation TDD_TableViewController

- (id <TDD_TableViewController_ModelType>)model {
    
    return [[[[self class] modelClass] alloc] init];
    
}

@end

@implementation TDD_TableViewController (Class)

+ (Class <TDD_TableViewController_CellType>)cellClass {
    
    return [TDD_TableViewCell class];
    
}

+ (Class <TDD_TableViewController_ModelType>)modelClass {
    
    return [TDD_TableModel class];
    
}

+ (Class <TDD_TableViewController_ViewType>)viewClass {
    
    return [UITableView class];
    
}

@end

@implementation TDD_TableViewController (ViewController)

- (void)loadView {
    
    id <TDD_TableViewController_ViewType> view = [[[[self class] viewClass] alloc] initWithFrame: CGRectZero style: UITableViewStylePlain];
    
    [view setDataSource: self];
    
    [self setView: view];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear: animated];
    
    TDD_TableViewController *__weak weakSelf = self;
    
    [[self model] startWithCompletionHandler: ^void (BOOL success, NSError *error) {
        
        id <TDD_TableViewController_ViewType> view = [weakSelf view];
        
        [view reloadData];
        
    }];
    
}

@end

@implementation TDD_TableViewController (ViewDataSource)

- (NSInteger)numberOfSectionsInTableView:(id <TDD_TableViewController_ViewType>)tableView {
    
    return 1;
    
}

@end
