//
//  NSDictionary+Parser.h
//  LZCommonUtils
//
//  Created by liyou on 15/4/5.
//  Copyright (c) 2015年 liyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Parser)

- (BOOL)hasValueForKey:(NSString *)key;

- (NSString *)stringValueForKey:(NSString *)key;
- (BOOL)booleanValueForKey:(NSString *)key;

- (NSNumber *)numberValueForKey:(NSString *)key;
- (int)intValueForKey:(NSString *)key;
- (NSInteger)integerValueForKey:(NSString *)key;
- (float)floatValueForKey:(NSString *)key;
- (double)doubleValueForKey:(NSString *)key;
- (long long)longLongValueForKey:(NSString *)key;

- (NSDictionary *)dictValueForKey:(NSString *)key;
- (NSMutableDictionary *)mutableDictValueForKey:(NSString *)key;

- (NSArray *)arrayValueForKey:(NSString *)key;
- (NSMutableArray *)mutableArrayValueForKey:(NSString *)key;

/* 异常容错处理 */
- (void)setObject:(id)anObject forKey:(id <NSCopying>)aKey;
- (void)removeObjectForKey:(id)aKey;
@end
