//
//  ViewController.m
//  MQSearchStore
//
//  Created by AQY on 2017/5/3.
//  Copyright © 2017年 AQY. All rights reserved.
//

#import "ViewController.h"
#import "SearchTableViewController.h"

#define ROWS 20
@interface ViewController ()

@property (nonatomic, strong) UISearchController * searchController;
@property (nonatomic, strong) NSArray <NSString *> * dataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray * mArray = [[NSMutableArray alloc] initWithCapacity:sizeof(NSString *) * ROWS];
    char str[8] = {0};
    
    for (int i = 0; i < ROWS; i ++) {
        for (int j = 0; j < 8; j ++) {
            str[j] = arc4random() % 74 + 49;
        }
        [mArray addObject:[NSString stringWithFormat:@"%s", str]];
    }
    self.dataArray = [mArray copy];
    SearchTableViewController * vc = [[SearchTableViewController alloc] init];
    vc.searchSource = self.dataArray;
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:vc];
    self.searchController.searchResultsUpdater = vc;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
}


// MARK: - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}


@end
