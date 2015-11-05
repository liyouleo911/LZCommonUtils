//
//  StringLogic.h
//  Weather
//
//  Created by logiph on 3/1/13.
//
//
#import <Foundation/Foundation.h>

/**
 NSString相关的一些业务逻辑
 
 @warning 由原来的Pubfunction中拆分开来的子函数，注释是后来添加上的，如有不正确的地方，请更新一下。
 */
@interface StringLogic : NSObject

/**
 判断参数是否为NSString，以及nil或者为空字符串
 
 @param value 待判断的参数
 */
+ (BOOL)stringIsNullOrEmpty:(NSString *)value;

/**
 将字符前后的空白字符删除
 
 @param value 待处理的字符串
 @param 返回处理后的新的字符串
 */
+ (NSString *)trimString:(NSString *)value;

/**
 判断字符串是否为数字字符串，即全为0~9
 
 @param value 待判断的字符串
 @return YES 字符串里包含的全部都是数字，NO 包含有其他字符
 */
+ (BOOL)isNumberString:(NSString *)value;

/**
 判断字符串是否为有效的密码，即全为0~9,a~z,A~Z
 
 @param value 待判断的字符串
 @return YES 字符串里包含的全部都是有效字符，NO 包含有其他字符
 */
+ (BOOL)isValidPassword:(NSString *)value;

/**
 判断字符串是否全部为汉字
 
 @param value 待判断的字符串
 @return YES 字符串里包含的全部都是汉字，NO 包含有其他字符
 */
+ (BOOL)stringIsChineseCharacters:(NSString *)value;

/**
 将字符串中包含的单引号替换成sqlite数据库中的单引号，否则执行sql语句的时候会出错
 
 @param value 待转换字符串
 @return 新生成的sqlite格式的字符串
 */
+ (NSString *)formatNSString4Sqlite:(NSString *)value;

/**
 如果为NSNull，则返回@""
 
 @param value 待转换字符串
 @return `value`为[NSNull null]返回@""，否则返回`value`本身
 */
+ (NSString *)changeStringValue:(id)value;

/**
 将`oldText`中的`subText`替换成`newSubText`
 
 */
+ (NSString *)replaceStr:(NSString *)oldText
                        :(NSString *)subText
                        :(NSString *)newSubText;

+ (NSString *)formatString4PhoneNumber:(NSString*)value;

+ (BOOL)isValidPhoneNumber:(NSString*)value;

@end
