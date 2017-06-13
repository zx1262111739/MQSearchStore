//
//  MQSearchStore.m
//  MQSearchStore
//
//  Created by AQY on 2017/5/3.
//  Copyright © 2017年 AQY. All rights reserved.
//

#import "MQSearchStore.h"

@interface MQSearchStore () {
    
    NSUInteger * _recordSearchMark;
}

@property (nonatomic, assign) NSUInteger searchLevel;
@property (nonatomic, assign) NSUInteger preSearchCotnentLength;

@property (nonatomic, assign) NSUInteger recordArrayCount;
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
    if (_recordSearchMark != NULL) {
        free(_recordSearchMark);
        _recordSearchMark = NULL;
    }
}

- (void)resetDataStore:(NSArray *)dataStore {
    self.dataStore = dataStore;
}

- (void)setDataStore:(NSArray *)dataStore {
    
    if (_dataStore != dataStore) {
        _dataStore = dataStore;
        
        [self resetSearch];
        [self recalloc];
    }
}

- (void)recalloc {
    
    if (self.recordArrayCount == self.dataStore.count) return;
    
    self.recordArrayCount = self.dataStore.count;
    
    if (_recordSearchMark != NULL) {
        free(_recordSearchMark);
        _recordSearchMark = NULL;
    }
    if (self.dataStore.count > 0) {
        _recordSearchMark = calloc(self.recordArrayCount, sizeof(NSUInteger));
    }
}

- (void)resetSearch {
    self.preSearchCotnentLength = 0;
    self.searchLevel = 0;
    
    if (self.recordArrayCount > 0) {
        memset(_recordSearchMark, 0, self.recordArrayCount * sizeof(NSUInteger));
    }
}

- (void)searchContent:(NSString *)searchContent compare:(MQSearchStoreCompare)compare completion:(MQSearchStoreCompletion)completion {
    
    // First Search
    if (self.preSearchCotnentLength == 0) {
        [self recalloc];
    }
    
    if (_recordSearchMark == NULL) {
        if (completion) {
            completion (nil);
        }
        return;
    }
    
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
    
    for (int i = 0 ; i < self.dataStore.count; i ++) {
        id obj = [self.dataStore objectAtIndex:i];
        if ((_recordSearchMark[i] >= searchLevel) && compare(searchContent, obj)) {
            [results addObject:obj];
            _recordSearchMark[i] = level;
        }
    }
    
//    NSInteger start = 0;
//    NSInteger end = self.dataStore.count - 1;
//
//    while (start <= end) {
//
//        id obj = [self.dataStore objectAtIndex:start];
//        if ((searchMark[start] >= searchLevel) && compare(searchContent, obj)) {
//            [results addObject:obj];
//            searchMark[start] = level;
//        }
//        start++;
//
//        if (start > end) {
//            break;
//        }
//
//        obj = [self.dataStore objectAtIndex:end];
//        if ((searchMark[end] >= searchLevel) && compare(searchContent, obj)) {
//            [results addObject:obj];
//            searchMark[end] = level;
//        }
//        end --;
//    }
    
    if (completion) {
        completion (results);
    }
}
@end
