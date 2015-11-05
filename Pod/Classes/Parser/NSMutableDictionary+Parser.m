//
//  NSMutableDictionary+Parser.m
//  Weather
//
//  Created by suguiyang@91.com on 15-02-15.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "NSMutableDictionary+Parser.h"

@implementation NSMutableDictionary (Parser)

- (void)setObjectValue:(id)value forKey:(NSString *)key
{
    if (value != nil) {
        [self setObject:value forKey:key];
    } else {
        NSLog(@"Set nil object value for key: %@", key);
        [self removeObjectForKey:key];
    }
}

- (void)setStringValue:(NSString *)value forKey:(NSString *)key
{
    if (value != nil && [value isKindOfClass:[NSString class]]) {
        [self setObjectValue:value forKey:key];
    } else {
        NSLog(@"Set string value for key: %@ is invalid: %@", key, value);
        [self setObjectValue:@"" forKey:key];
    }
}

- (void)setBooleanValue:(BOOL)value forKey:(NSString *)key
{
    [self setObjectValue:@(value) forKey:key];
}

- (void)setIntValue:(int)value forKey:(NSString *)key
{
    [self setObjectValue:@(value) forKey:key];
}

- (void)setIntegerValue:(NSInteger)value forKey:(NSString *)key
{
    [self setObjectValue:@(value) forKey:key];
}

- (void)setFloatValue:(float)value forKey:(NSString *)key
{
    [self setObjectValue:@(value) forKey:key];
}

- (void)setDoubleValue:(double)value forKey:(NSString *)key
{
    [self setObjectValue:@(value) forKey:key];
}

@end
