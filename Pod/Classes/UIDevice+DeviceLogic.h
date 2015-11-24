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
    type_Mobile = 2,                // 运营商网络
    type_Wifi = 10,                 // WIFI网络
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
