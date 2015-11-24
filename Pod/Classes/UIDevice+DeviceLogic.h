//
//  UIDevice+DeviceLogic.h
//  Pods
//
//  Created by liyou on 15/11/24.
//
//

#import <UIKit/UIKit.h>

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

@interface UIDevice (DeviceLogic)

/// 是否越狱设备
+ (BOOL)isJailBreakDevice;

/// 获取设备类型（已废弃）
+ (NSString *)getDeviceType;

/// 获取网络类型
+ (NetWorkType)getNetworkValue;

/// 获取设备型号
+ (NSString *)machineType;

/// 获取设备mac地址
+ (NSString *)macaddress;

@end
