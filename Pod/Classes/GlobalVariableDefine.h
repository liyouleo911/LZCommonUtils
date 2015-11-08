//
//  GlobalVariableDefine.h
//  LZCommonUtils
//
//  Created by liyou on 15/4/5.
//  Copyright (c) 2015年 liyou. All rights reserved.
//

#define BoolString(value) (value ? @"true" : @"false")
#define IntegerString(value) [NSString stringWithFormat:@"%d", (int)(value)]
#define FloatString(value) [NSString stringWithFormat:@"%f", (float)(value)]
#define HexColor(value) (value/255.0)
#define NSStringFromCString(string) [NSString stringWithCString:string encoding:NSUTF8StringEncoding]

#define kDDLogFunction @"%s line:%d", __func__, __LINE__

#define BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define MAIN(block) dispatch_async(dispatch_get_main_queue(), block)


#define kProfileTime_Begin NSTimeInterval profile_start_time = CFAbsoluteTimeGetCurrent()

#define kProfileTime_End NSLog(@"\n\n%s line:%d %f seconds.\n\n", __func__, __LINE__, CFAbsoluteTimeGetCurrent() - profile_start_time)

#define NDBlokCopy(destination,source) if(destination) { \
                                          Block_release(destination); \
                                          destination = nil;      \
                                        } \
                                        destination = Block_copy(source);

#define NDBlockRelease(destination)     if (destination) { \
                                            Block_release(destination); \
                                            destination = nil;   \
                                        }


extern void *(^addObserver)(id object, SEL selector, NSString *name);

extern void *(^removeObserver)(id object, NSString *name);

extern void *(^sendNotify)(NSString *name, id obj);

extern void *(^sendNotifyWithInfo)(NSString *name, id obj, NSDictionary *info);

extern void *(^sendNotifyOnMain)(NSString *name, id obj);

extern void *(^sendNotifyWithInfoOnMain)(NSString *name, id obj, NSDictionary *info);
