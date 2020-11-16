//
//  YLPrivacyPermissionNotification.m
//  YLPrivacyPermission
//
//  Created by xyanl on 2020/11/9.
//

#import "YLPrivacyPermissionNotification.h"
#import <UserNotifications/UserNotifications.h>
#import <UIKit/UIKit.h>

@interface YLPrivacyPermissionNotification()

@end

@implementation YLPrivacyPermissionNotification

+ (BOOL)authorized
{
    return [self authorizationStatus] >= 2;
}

/**
 access authorizationStatus
 0: NotDetermined
 1: denied
 2: authorized
 3: 不影响用户操作的通知
 4: clips：临时允许
 */
+ (NSInteger)authorizationStatus
{
    if (@available(iOS 10.0, *)) {
        
        dispatch_semaphore_t sem = dispatch_semaphore_create(0); // 创建信号量
        
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        
        dispatch_group_t group = dispatch_group_create();
        
        dispatch_group_enter(group);
        
        __block UNAuthorizationStatus authorizationStatus;
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            
            authorizationStatus = settings.authorizationStatus;
            dispatch_semaphore_signal(sem); // 发送信号量
            
        }];
        
        dispatch_semaphore_wait(sem , DISPATCH_TIME_FOREVER); // 等待信号量
        return authorizationStatus;
    }else{
        
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone == setting.types) {
            
            NSString* preRequest = [[NSUserDefaults standardUserDefaults] valueForKey:@"YLPrivacyPermissionNotification"];
            
            if (preRequest) {
                return 1;
            }
            
            return 0;
        }
        return 2;
    }
    
    return 0;
}

+ (void)authorizeWithCompletion:(void(^)(BOOL granted,BOOL firstTime))completion
{
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        
        BOOL firstTime = [self authorizationStatus] == 0;
        
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                completion(granted,firstTime);
            });
            
            
            if (granted) {
                [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                    if (settings.authorizationStatus == UNAuthorizationStatusAuthorized){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[UIApplication sharedApplication] registerForRemoteNotifications];
                        });
                    }
                }];
            }
        }];
    }
    else{
        
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone == setting.types) {
            
            NSString* preRequest = [[NSUserDefaults standardUserDefaults] valueForKey:@"YLPrivacyPermissionNotification"];
            
            if (preRequest) {
                
                completion(NO,NO);
                return;
            }
        }
        
        //request
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)])
        {
            UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }
        
        [[NSUserDefaults standardUserDefaults]setObject:@"requested" forKey:@"YLPrivacyPermissionNotification"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}

/// 当前隐私许可状态描述
+ (NSString *)authorizationStatusDescribe{
    NSString *strPermission = @"";
    /**
     access authorizationStatus
     0: NotDetermined
     1: denied
     2: authorized
     3: 不影响用户操作的通知
     4: clips：临时允许
     */
    switch ( [YLPrivacyPermissionNotification authorizationStatus] ) {
        case 0:
            strPermission = @"权限未确定";
            break;
        case 1:
            strPermission = @"没有权限";
            break;
        case 2:
            strPermission = @"权限已经获取";
            break;
        case 3:
            strPermission = @"权限已经获取:不影响用户操作的通知权限";
            break;
        case 4:
            strPermission = @"clips权限临时权限已获取";
            break;
        default:
            break;
    }
    return strPermission;
}
@end
