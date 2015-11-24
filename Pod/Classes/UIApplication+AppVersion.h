//
//  UIApplication+AppVersion.h
//  Pods
//
//  Created by liyou on 15/11/24.
//
//

#import <UIKit/UIKit.h>

@interface UIApplication (AppVersion)

///获取应用的version
+ (NSString *)appVersion;

///获取应用的build
+ (NSString *)build;

///获取应用version和build号的组合，如v1.0(1.0.1)
+ (NSString *)versionBuild;
@end
