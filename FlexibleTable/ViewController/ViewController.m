//
//  ViewController.m
//  FlexibleTable
//
//  Created by daisuke on 2016/1/20.
//  Copyright © 2016年 dse12345z. All rights reserved.
//

#import "ViewController.h"
#import "FlexibleTable.h"
#import "SearchView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%td", indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    SearchView *searchView = [[SearchView alloc] initFromXib];
    [FlexibleTable initWithScrollView:self.tableView views:@[searchView] minOffsetY:20.0f];
}

@end
