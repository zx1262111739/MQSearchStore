//
//  MQSearchStore.m
//  MQSearchStore
//
//  Created by AQY on 2017/5/3.
//  Copyright © 2017年 AQY. All rights reserved.
//

#import "MQSearchStore.h"

@interface MQSearchStore () {
    
    NSUInteger * searchMark;
}
@property (nonatomic, assign) NSInteger searchLevel;
@property (nonatomic, assign) NSInteger preSearchCotnentLength;
@end
@implementation MQSearchStore
@synthesize dataStore = _dataStore;
- (instancetype)initWithDataStore:(NSArray *)dataStore {
    self = [super init];
    if (self) {
        self.dataStore = dataStore;
    }
    return self;
}
- (void)dealloc {
    if (searchMark != NULL) {
        free(searchMark);
        searchMark = NULL;
    }
}

- (void)resetDataStore:(NSArray *)dataStore {
    self.dataStore = dataStore;
}

- (void)setDataStore:(NSArray *)dataStore {
    
    if (_dataStore != dataStore) {
        _dataStore = dataStore;
        if (searchMark != NULL) {
            free(searchMark);
            searchMark = NULL;
        }
        searchMark = calloc(dataStore.count, sizeof(NSUInteger));
        [self resetSearch];
    }
}

- (void)resetSearch {
    self.preSearchCotnentLength = 0;
    self.searchLevel = 0;
    memset(searchMark, 0, sizeof(NSUInteger) * self.dataStore.count);
}

- (void)searchContent:(NSString *)searchContent compare:(MQSearchStoreCompare)compare completion:(MQSearchStoreCompletion)completion {
    
    BOOL drop = searchContent.length > self.preSearchCotnentLength;
    self.preSearchCotnentLength = searchContent.length;
    
    if (drop) {
        self.searchLevel ++;
    } else {
        self.searchLevel = MAX(0, self.searchLevel - 1);
    }
    
    if (!self.dataStore || (self.searchLevel == 0 && searchContent.length <= 0)) {
        if (completion) {
            completion (nil);
        }
        return;
    }
    
    NSMutableArray * results = [[NSMutableArray alloc] init];
    
    NSInteger searchLevel = MAX(0, (self.searchLevel - 1));
    NSInteger level = self.searchLevel;
    
//    for (int i = 0 ; i < self.dataStore.count; i ++) {
//        id obj = [self.dataStore objectAtIndex:i];
//        if ((searchMark[i] >= searchLevel) && compare(searchContent, obj)) {
//            [results addObject:obj];
//            searchMark[i] = level;
//        }
//    }
    
    NSInteger start = 0;
    NSInteger end = self.dataStore.count - 1;
    
    while (start <= end) {
        
        id obj = [self.dataStore objectAtIndex:start];
        if ((searchMark[start] >= searchLevel) && compare(searchContent, obj)) {
            [results addObject:obj];
            searchMark[start] = level;
        }
        start++;
        
        if (start > end) {
            break;
        }
        
        obj = [self.dataStore objectAtIndex:end];
        if ((searchMark[end] >= searchLevel) && compare(searchContent, obj)) {
            [results addObject:obj];
            searchMark[end] = level;
        }
        end --;
    }
    
    
    if (completion) {
        completion (results);
    }
}
@end
