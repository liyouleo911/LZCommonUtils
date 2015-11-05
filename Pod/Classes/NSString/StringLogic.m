//
//  StringLogic.m
//  LZCommonUtils
//
//  Created by liyou on 15/4/5.
//  Copyright (c) 2015年 liyou. All rights reserved.
//

#import "StringLogic.h"

@implementation StringLogic

+ (BOOL)stringIsNullOrEmpty:(NSString *)value {
	if (value == nil) {
		return YES;
	}
	if (![value isKindOfClass:[NSString class]]) {
		return YES;
	}
	if ([[value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
		return YES;
	}
	return NO;
}

+ (NSString *)trimString:(NSString *)value {
    if (value) {
        NSMutableString *mStr   = [value mutableCopy];
        CFStringTrimWhitespace((CFMutableStringRef)mStr);
        NSString        *result = [mStr copy];
        return result;
    }
    return @"";
}

+ (BOOL)isNumberString:(NSString *)value {
	for (int i = 0; i < [value length]; i++) {
		if ([value characterAtIndex:i] < '0' || [value characterAtIndex:i] > '9') {
			return FALSE;
		}
	}
	return TRUE;
}

+ (BOOL)isValidPassword:(NSString *)value {
    for (int i = 0; i < [value length]; i++) {
        if (!([value characterAtIndex:i] >= '0' && [value characterAtIndex:i] <= '9') &&
            !([value characterAtIndex:i] >= 'a' && [value characterAtIndex:i] <= 'z') &&
            !([value characterAtIndex:i] >= 'A' && [value characterAtIndex:i] <= 'Z')) {
            return FALSE;
        }
    }
    return TRUE;
}

//可能存在nsull情况，对它进行转换
+ (NSString *)changeStringValue:(id)value {
    if ([NSNull null] == value) {
        return @"";
    } else {
        return value;
    }
}

+ (NSString *)formatNSString4Sqlite:(NSString *)value {
	if (![value isKindOfClass:[NSString class]]) {
		return @"";
	}
	NSRange range = [value rangeOfString:@"'"];
	if (range.length > 0) {
		return [value stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
	}
	return value;
}


+ (BOOL)stringIsChineseCharacters:(NSString *)value {

    if (value == nil) {
		return NO;
	}
	
	if (![value isKindOfClass:[NSString class]]) {
		return NO;
	}
	
	int len = (int)(value.length);
	if (len == 0) {
		return YES;
	}
    
	for (int i=0; i<len; i++) {
		unichar uc = [value characterAtIndex:i];
		if (uc<0x4e00 || uc>0x9fa5 )
			return NO;
	}
	
	return YES;
    
}

+ (NSString *)replaceStr:(NSString *)oldText
                        :(NSString *)subText
                        :(NSString *)newSubText {
    
    NSString *result = [oldText stringByReplacingOccurrencesOfString:subText
                                                          withString:newSubText];
    return result;
}

+ (NSString *)formatString4PhoneNumber:(NSString *)value
{
    NSCharacterSet *whitespaces = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSPredicate *noEmptyString = [NSPredicate predicateWithFormat:@"SELF != ''"];
    
    NSArray *parts = [value componentsSeparatedByCharactersInSet:whitespaces];
    NSArray *filteredArray = [parts filteredArrayUsingPredicate:noEmptyString];
    NSString *nonWhiteSpaceValue = [filteredArray componentsJoinedByString:@""];
    
    return [self replaceStr:nonWhiteSpaceValue :@"-" :@""];
}

+ (BOOL)isValidPhoneNumber:(NSString *)value {
    
    for (int i = 0; i < [value length]; i++) {
        if ([value characterAtIndex:i] >= '0' && [value characterAtIndex:i] <= '9') {
            continue;
        }
        if (i == 0 && [value characterAtIndex:i] == '+') {
            continue;
        }
        return FALSE;
    }
    return TRUE;
}

@end
