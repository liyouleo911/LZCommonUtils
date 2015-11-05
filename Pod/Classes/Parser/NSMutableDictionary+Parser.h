//
//  NSMutableDictionary+Parser.h
//  Weather
//
//  Created by suguiyang@91.com on 15-02-15.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Parser)

- (void)setObjectValue:(id)value forKey:(NSString *)key;
- (void)setStringValue:(NSString *)value forKey:(NSString *)key;

- (void)setBooleanValue:(BOOL)value forKey:(NSString *)key;
- (void)setIntValue:(int)value forKey:(NSString *)key;
- (void)setIntegerValue:(NSInteger)value forKey:(NSString *)key;
- (void)setFloatValue:(float)value forKey:(NSString *)key;
- (void)setDoubleValue:(double)value forKey:(NSString *)key;
@end
