//
//  YLPrivacyPermissionReminders.m
//  YLPrivacyPermission
//
//  Created by xyanl on 2020/11/9.
//

#import "YLPrivacyPermissionReminders.h"

@implementation YLPrivacyPermissionReminders

+ (BOOL)authorized
{
    return [self authorizationStatus] == EKAuthorizationStatusAuthorized;
}

+ (EKAuthorizationStatus)authorizationStatus
{
    EKAuthorizationStatus status =
    [EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder];
    return  status;
}

+ (void)authorizeWithCompletion:(void(^)(BOOL granted,BOOL firstTime))completion
{
    EKAuthorizationStatus status = [self authorizationStatus];
    switch (status) {
        case EKAuthorizationStatusAuthorized: {
            if (completion) {
                completion(YES, NO);
            }
        } break;
        case EKAuthorizationStatusNotDetermined:
        {
            EKEventStore *eventStore = [[EKEventStore alloc] init];
            [eventStore requestAccessToEntityType:EKEntityTypeReminder
                                       completion:^(BOOL granted, NSError *error) {
                if (completion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(granted,YES);
                    });
                }
            }];
        } break;
        case EKAuthorizationStatusRestricted:
        case EKAuthorizationStatusDenied: {
            if (completion) {
                completion(NO, NO);
            }
        } break;
    }
}

/// 当前隐私许可状态描述
+ (NSString *)authorizationStatusDescribe{
    NSString *strPermission = @"";
    switch ([YLPrivacyPermissionReminders authorizationStatus]) {
        case EKAuthorizationStatusNotDetermined:
            strPermission = @"权限未确定";
            break;
        case EKAuthorizationStatusRestricted:
            strPermission = @"权限受到限制";
            break;
        case EKAuthorizationStatusDenied:
            strPermission = @"没有权限";
            break;
        case EKAuthorizationStatusAuthorized:
            strPermission = @"权限已经获取";
            break;
    }
    return strPermission;
}

@end
