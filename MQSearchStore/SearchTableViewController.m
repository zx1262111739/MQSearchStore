//
//  SearchTableViewController.m
//  MQSearchStore
//
//  Created by AQY on 2017/5/3.
//  Copyright © 2017年 AQY. All rights reserved.
//

#import "SearchTableViewController.h"
#import "MQSearchStore.h"

@interface SearchTableViewController ()

@property (nonatomic, copy) NSArray <NSString *> * dataArray;
@property (nonatomic, strong) MQSearchStore * searchStore;
@end

@implementation SearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view insertSubview:[UIView new] atIndex:0];
}
- (void)dealloc {
    
}
- (MQSearchStore *)searchStore {
    if (!_searchStore) {
        _searchStore = [[MQSearchStore alloc] initWithDataStore:nil];
    }
    return _searchStore;
}

- (void)setSearchSource:(NSArray<NSString *> *)searchSource {
    [self.searchStore resetDataStore:searchSource];
    _searchSource = searchSource;
}

// MARK: - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    if ([searchController.searchBar.text isEqualToString:@""]) {
        [self.searchStore resetSearch];
        return;
    }
    
    clock_t start = clock();
    
    [self.searchStore searchContent:searchController.searchBar.text compare:^(NSString *searchConent, NSString * obj) {
         return [[obj lowercaseString] containsString:[searchConent lowercaseString]];
    } completion:^(NSArray *results) {
        self.dataArray = results;
    }];
    
//    @autoreleasepool {
//        NSMutableArray * mArray = [[NSMutableArray alloc] init];
//        for (NSString * str in self.searchSource) {
//            if ([[str lowercaseString] containsString:[searchController.searchBar.text lowercaseString]]) {
//                [mArray addObject:str];
//            }
//        }
//        self.dataArray = [mArray copy];
//    }
//    
    clock_t end = clock();
    NSLog(@"%2f ms", (end - start) * 1.0 / 1000);
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}


@end
