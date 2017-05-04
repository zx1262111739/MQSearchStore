//
//  MQSearchStore.h
//  MQSearchStore
//
//  Created by AQY on 2017/5/3.
//  Copyright © 2017年 AQY. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef BOOL(^MQSearchStoreCompare)(NSString * searchConent, id obj);
typedef void(^MQSearchStoreCompletion)(NSArray * results);

@interface MQSearchStore : NSObject

@property (nonatomic, strong, readonly) NSArray * dataStore;

- (instancetype)initWithDataStore:(NSArray *)dataStore;
- (void)resetDataStore:(NSArray *)dataStore;

- (void)resetSearch;
- (void)searchContent:(NSString *)searchContent compare:(MQSearchStoreCompare)compare completion:(MQSearchStoreCompletion)completion;
@end
