//
//  NSMutableDictionary+Parser.h
//  LZCommonUtils
//
//  Created by liyou on 15/4/5.
//  Copyright (c) 2015年 liyou. All rights reserved.
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
