//
//  BaseRequestManager.h
//  LZCommonUtils
//
//  Created by liyou on 15/4/5.
//  Copyright (c) 2015年 liyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseRequestManager : NSObject

+ (instancetype)defaultManager;
- (NSMutableDictionary*)addCommonParamsWithUrl:(NSDictionary*)dict;
- (void)parseResponseData:(id)responseData success:(void(^)(id object))success;
@end
