//
//  YLPrivacyPermissionTracking.m
//  YLPrivacyPermission
//
//  Created by xyanl on 2020/11/9.
//

#import "YLPrivacyPermissionTracking.h"
#import <AdSupport/AdSupport.h>

@implementation YLPrivacyPermissionTracking

+ (BOOL)authorized
{
    if (@available(iOS 14.0, *)) {
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_14_0
        ATTrackingManagerAuthorizationStatus status = [ATTrackingManager trackingAuthorizationStatus];
        return status == ATTrackingManagerAuthorizationStatusAuthorized;
#endif
    }
    else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"// 找到警告的类型
        if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
            return YES;
        }
#pragma clang diagnostic pop
    }
    return NO;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_14_0
+ (ATTrackingManagerAuthorizationStatus)authorizationStatus
{
    return [ATTrackingManager trackingAuthorizationStatus];
}
#endif

+ (void)authorizeWithCompletion:(void(^)(BOOL granted,BOOL firstTime))completion
{
    
    if (@available(iOS 14.0, *)) {
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_14_0
        
        ATTrackingManagerAuthorizationStatus status = [ATTrackingManager trackingAuthorizationStatus];
        
        switch (status) {
            case ATTrackingManagerAuthorizationStatusNotDetermined:
            {
                // 未提示用户
                [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
                            completion(YES,YES);
                            //                            NSString *idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
                        }
                        else {
                            completion(NO,YES);
                            
                        }
                    });
                }];
            }
                break;
            case ATTrackingManagerAuthorizationStatusRestricted:
            case ATTrackingManagerAuthorizationStatusDenied:
            {
                completion(NO,NO);
            }
                break;
            case ATTrackingManagerAuthorizationStatusAuthorized:
            {
                completion(YES,NO);
            }
                
            default:
                break;
        }
#endif
    }
    else {
        //iOS 14以下请求idfa权限
        // 判断在设置-隐私里用户是否打开了广告跟踪
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"// 找到警告的类型
        if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
            completion(YES,NO);
            //NSString *idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
            //NSLog(@"%@",idfa);
        } else {
            //NSLog(@"请在设置-隐私-广告中打开广告跟踪功能");
            completion(NO,NO);
        }
#pragma clang diagnostic pop
    }
}

/// 当前隐私许可状态描述
+ (NSString *)authorizationStatusDescribe{
    NSString *strPermission = @"";
    if (@available(iOS 14.0, *)) {
#ifndef __IPHONE_14_0
#define __IPHONE_14_0    140000
#endif
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_14_0
        switch ([YLPrivacyPermissionTracking authorizationStatus]) {
            case ATTrackingManagerAuthorizationStatusNotDetermined:
                strPermission = @"权限未确定";
                break;
            case ATTrackingManagerAuthorizationStatusRestricted:
                strPermission = @"权限受到限制";
                break;
            case ATTrackingManagerAuthorizationStatusDenied:
                strPermission = @"没有权限,检查系统 设置->隐私->跟踪";
                break;
            case ATTrackingManagerAuthorizationStatusAuthorized:
                strPermission = @"权限已经获取";
                break;
        }
#endif
    }else{
        if ([YLPrivacyPermissionTracking authorized]) {
            strPermission = @"权限已经获取";
        }
        else{
            strPermission = @"没有权限，请检查系统设置(当前系统低于iOS14)";
        }
    }
    return strPermission;
}

@end
