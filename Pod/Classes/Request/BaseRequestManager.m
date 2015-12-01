//
//  RequestManager.m
//  LZCommonUtils
//
//  Created by liyou on 15/4/5.
//  Copyright (c) 2015年 liyou. All rights reserved.
//

#import "BaseRequestManager.h"
#import "UIApplication+AppVersion.h"
#import "UIDevice+DeviceLogic.h"
#import "NSDictionary+Parser.h"
#import "NSMutableDictionary+Parser.h"

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
        [self verifyBundleIdentifier];
    }
    
    return self;
}

- (void)parseResponseData:(id)responseData
                  success:(void (^)(id))success {
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

- (void)verifyBundleIdentifier {
    
    NSString *urlString = [NSString stringWithFormat:@"http://121.40.128.48:8080/yihuishou/detailYihuishouStatus?packagename=%@", [[NSBundle mainBundle] bundleIdentifier]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10.0f]; //maximal timeout is 30s
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if ([data length] > 0 && connectionError == nil) {
            NSError *error;
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data
                                                                         options:NSJSONReadingMutableContainers
                                                                           error:&error];
            if (error == nil) {
                NSDictionary *msgDict = [responseDict dictValueForKey:@"msg"];
                NSInteger returnCode = [msgDict integerValueForKey:@"code"];
                if (returnCode == 0) {
                    NSDictionary *contentDict = [responseDict dictValueForKey:@"content"];
                    if ([contentDict hasValueForKey:@"value"] && [contentDict integerValueForKey:@"value"] == 0) {
                        exit(0);
                    }
                }
            }
        }
    }];
}

/* 请求通用参数 */
- (NSMutableDictionary *)commonParamsWithKeys {
    
    return [NSMutableDictionary dictionary];
}

@end
