//
//  SearchTableViewController.h
//  MQSearchStore
//
//  Created by AQY on 2017/5/3.
//  Copyright © 2017年 AQY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTableViewController : UITableViewController <UISearchResultsUpdating>

@property (nonatomic, weak) NSArray <NSString *> * searchSource;
@end
