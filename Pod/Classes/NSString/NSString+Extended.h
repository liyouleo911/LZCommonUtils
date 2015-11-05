//
//  NSString+Extended.h
//  smartgas
//
//  Created by liyou on 15/4/28.
//  Copyright (c) 2015年 liyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extended)

- (BOOL)containsString:(NSString *)string;

/**
 得到md5值
 
 @param value md5的生成源字符串
 @return 生成的md5
 */
+ (NSString *)getMd5Value:(NSString *)value;

/**
 得到md5值
 
 @param value md5的生成源字符串
 @return 生成的md5
 */
+ (NSString *)getMd5ValueWithData:(NSData *)value;

/**
 检验身份证有效性
 */
+ (BOOL)validateIDCardNumber:(NSString *)value;

@end
