//
//  DeviceLogic.h
//  LZCommonUtils
//
//  Created by liyou on 15/4/5.
//  Copyright (c) 2015年 liyou. All rights reserved.
//

typedef enum {
    type_Unknow = 0,                // 未知
    type_Wifi = 10,                 // WIFI网络
    type_USB = 20,                  // USB网络
    type_MobileUnknow = 30,         // 运营商
    type_MobileUnknow_10010 = 31,   // 联通
    type_MobileUnknow_10000 = 32,   // 电信
    type_Mobile2G = 50,             // 2G
    type_Mobile2G_10010 = 51,       // 联通2G
    type_Mobile2G_10000 = 52,       // 电信2G
    type_Mobile2G_10086 = 53,       // 移动2G
    type_MobileUnknow_10086 = 53,   // 移动网络
    type_Mobile3G = 60,             // 3G
    type_Mobile3G_10010 = 61,       // 联通3G
    type_Mobile3G_10000 = 62,       // 电信3G
    type_Mobile3G_10086 = 63,       // 移动3G
} NetWorkType;

/**
 设备相关的一些业务逻辑接口
 */
@interface DeviceLogic : NSObject

+ (BOOL)isJailBreakDevice;

+ (NSString *)getDeviceType;

+ (NetWorkType)getNetworkValue;

+ (NSString *)machineType;

// mac地址
+ (NSString *)macaddress;

@end
