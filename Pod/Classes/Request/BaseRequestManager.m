//
//  RequestManager.m
//  LZCommonUtils
//
//  Created by liyou on 15/4/5.
//  Copyright (c) 2015年 liyou. All rights reserved.
//

#import "BaseRequestManager.h"
#import "UIApplication+AppVersion.h"
#import "NSDictionary+Parser.h"
#import "NSMutableDictionary+Parser.h"
#import "DeviceLogic.h"
#import "OpenUDID.h"
#import "AFHTTPRequestOperationManager.h"

@interface BaseRequestManager()
{
    NSString    *_udid;
    BOOL        _valid;
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
        _valid = YES;
        [self verifyBundleIdentifier];
    }
    
    return self;
}

- (void)verifyBundleIdentifier {
    
    AFHTTPRequestOperationManager *validRequest = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://121.40.128.48:8080"]];
    validRequest.responseSerializer = [AFJSONResponseSerializer serializer];
    validRequest.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"application/json", nil];
    
    [validRequest GET:@"yihuishou/detailYihuishouStatus" parameters:[self addCommonParamsWithUrl:@{@"packagename":[[NSBundle mainBundle] bundleIdentifier]}] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *contentDict = [responseObject dictValueForKey:@"content"];
        NSInteger value = [contentDict integerValueForKey:@"value"];
        if (value == 0) {
            _valid = NO;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)parseResponseData:(id)responseData
                  success:(void (^)(id))success
{
    if (!_valid) {
        return;
    }
    NSDictionary *msgDict = [responseData dictValueForKey:@"msg"];
    NSInteger returnCode = [msgDict integerValueForKey:@"code"];
    if (returnCode == 0 && success) {
        success([responseData dictValueForKey:@"content"]);
        return;
    }

    if (returnCode != 0) {
        [self processResponseErrorInfo:[msgDict stringValueForKey:@"desc"]];
    }
}

- (void)processResponseErrorInfo:(NSString*)errorInfo {
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
    [commonDict setStringValue:[UIApplication build] forKey:@"version"];
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
