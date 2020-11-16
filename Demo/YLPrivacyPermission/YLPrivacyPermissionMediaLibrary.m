//
//  YLPrivacyPermissionMediaLibrary.m
//  YLPrivacyPermission
//
//  Created by xyanl on 2020/11/9.
//

#import "YLPrivacyPermissionMediaLibrary.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation YLPrivacyPermissionMediaLibrary

+ (BOOL)authorized {
    return [self authorizationStatus] == 3;
}

/**
 0: MPMediaLibraryAuthorizationStatusNotDetermined = 0,
 1: MPMediaLibraryAuthorizationStatusDenied,
 2: MPMediaLibraryAuthorizationStatusRestricted,
 3: MPMediaLibraryAuthorizationStatusAuthorized,
 */
+ (NSInteger)authorizationStatus {
    if (@available(iOS 9.3, *)) {
        return [MPMediaLibrary authorizationStatus];
    } else {
        return 3;
    }
}

+ (void)authorizeWithCompletion:(void(^)(BOOL granted, BOOL firstTime))complection {
    if (@available(iOS 9.3, *)) {
        MPMediaLibraryAuthorizationStatus status = [MPMediaLibrary authorizationStatus];
        switch (status) {
            case MPMediaLibraryAuthorizationStatusAuthorized:
            {
                if (complection) {
                    complection(YES, NO);
                }
            } break;
            case MPMediaLibraryAuthorizationStatusRestricted:
            case MPMediaLibraryAuthorizationStatusDenied:
            {
                if (complection) {
                    complection(NO, NO);
                }
            } break;
            case MPMediaLibraryAuthorizationStatusNotDetermined:
            {
                [MPMediaLibrary requestAuthorization:^(MPMediaLibraryAuthorizationStatus status) {
                    if (complection) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            complection(status == MPMediaLibraryAuthorizationStatusAuthorized, YES);
                        });
                    }
                    
                }];
            } break;
            default:
            {
                if (complection) {
                    complection(NO, NO);
                }
            } break;
        }
    } else {
        complection(YES, NO);
    }
}

/// 当前隐私许可状态描述
+ (NSString *)authorizationStatusDescribe{
    NSString *strPermission = @"";
    switch ([YLPrivacyPermissionMediaLibrary authorizationStatus]) {
        case MPMediaLibraryAuthorizationStatusNotDetermined:
            strPermission = @"权限未确定";
            break;
        case MPMediaLibraryAuthorizationStatusDenied:
            strPermission = @"权限受到限制";
            break;
        case MPMediaLibraryAuthorizationStatusRestricted:
            strPermission = @"没有权限";
            break;
        case MPMediaLibraryAuthorizationStatusAuthorized:
            strPermission = @"权限已经获取";
            break;
    }
    return strPermission;
}
@end
