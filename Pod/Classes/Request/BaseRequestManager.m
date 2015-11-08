//
//  RequestManager.m
//  LZCommonUtils
//
//  Created by liyou on 15/4/5.
//  Copyright (c) 2015年 liyou. All rights reserved.
//

#import "BaseRequestManager.h"
#import "NSDictionary+Parser.h"
#import "NSMutableDictionary+Parser.h"
#import "DeviceLogic.h"
#import "OpenUDID.h"

@interface BaseRequestManager()
{
    NSString    *_udid;
}
@end

static BaseRequestManager *manager;
@implementation BaseRequestManager

#pragma mark - Public

+ (instancetype)defaultManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[[self class] alloc] init];
    });
    return manager;
}

- (instancetype)init {
    
    if (self = [super init]) {
        _udid = [OpenUDID value];
    }
    
    return self;
}

- (void)parseResponseData:(id)responseData
                  success:(void (^)(id))success
{
    NSDictionary *msgDict = [responseData dictValueForKey:@"msg"];
    NSInteger returnCode = [msgDict integerValueForKey:@"code"];
    if (returnCode == 0 && success) {
        success([responseData dictValueForKey:@"content"]);
        return;
    }

    if (returnCode != 0) {
        [self processWrongResponse];
    }
}

- (void)processWrongResponse {
}

- (NSMutableDictionary*)addCommonParamsWithUrl:(NSDictionary*)dict
{
    if (dict == nil || [dict count] == 0) {
        return [self commonParamsWithKeys];
    }
    
    NSMutableDictionary *rtnDict = [dict mutableCopy];
    [rtnDict addEntriesFromDictionary:[self commonParamsWithKeys]];
    return rtnDict;
}

#pragma mark - Private

/* 请求通用参数 */
- (NSMutableDictionary *)commonParamsWithKeys
{
    NSMutableDictionary *commonDict = [[NSMutableDictionary alloc] init];
#ifndef DEBUG
    NSDate *curDate = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    [commonDict setStringValue:[dateFormatter stringFromDate:curDate] forKey:@"time"];
#endif
    [commonDict setStringValue:_udid forKey:@"driverId"];
    [commonDict setStringValue:@"ios" forKey:@"platform"];
    [commonDict setStringValue:[UIDevice currentDevice].systemVersion forKey:@"release"];
    [commonDict setStringValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey] forKey:@"version"];
    if ([DeviceLogic getNetworkValue] == type_Wifi) {
        [commonDict setStringValue:@"wifi" forKey:@"netType"];
    } else {
        [commonDict setStringValue:@"gprs" forKey:@"netType"];
    }
    [commonDict setStringValue:[DeviceLogic machineType] forKey:@"model"];
    [commonDict setStringValue:@"Apple" forKey:@"brand"];
    
    return commonDict;
}

@end
