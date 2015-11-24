//
//  UIDevice+DeviceLogic.m
//  Pods
//
//  Created by liyou on 15/11/24.
//
//

#import "UIDevice+DeviceLogic.h"
#import "Reachability.h"
#import "sys/utsname.h"
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

@implementation UIDevice (DeviceLogic)

+ (BOOL)isJailBreakDevice {
    //    if (system("ls") == 0) {
    //        return YES;
    //    }
    //    return [[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/lib/apt/"];
    BOOL jailbroken = NO;
    NSString *cydiaPath = @"/Applications/Cydia.app";
    NSString *aptPath = @"/private/var/lib/apt/";
    if ([[NSFileManager defaultManager] fileExistsAtPath:cydiaPath]) {
        jailbroken = YES;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:aptPath]) {
        jailbroken = YES;
    }
    return jailbroken;
}

+ (NetWorkType)getNetworkValue
{
    NetWorkType networkType = type_Unknow;
    
    NetworkStatus status = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    
    switch (status) {
        case NotReachable:
            networkType = type_Unknow;
            break;
            
        case ReachableViaWiFi:
            networkType = type_Wifi;
            break;
            
        case ReachableViaWWAN:
            networkType = type_MobileUnknow;
            break;
            
        default:
            break;
    }
    
    return networkType;
}

+ (NSString *)getSysInfoByName:(char *)typeSpecifier
{
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    
    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
    
    free(answer);
    return results;
}

+ (NSString *)getDeviceType {
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *machine = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return machine;
}

+ (NSString *)machineType
{
    return [self getSysInfoByName:"hw.machine"];
}

+ (NSString *)macaddress
{
    int					mib[6];
    size_t				len;
    char				*buf;
    unsigned char		*ptr;
    struct if_msghdr	*ifm;
    struct sockaddr_dl	*sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0
        || sysctl(mib, 6, NULL, &len, NULL, 0) < 0
        || (buf = (char *)malloc(len)) == NULL
        || sysctl(mib, 6, buf, &len, NULL, 0) < 0)
        return NULL;
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    return [outstring uppercaseString];
}

@end
