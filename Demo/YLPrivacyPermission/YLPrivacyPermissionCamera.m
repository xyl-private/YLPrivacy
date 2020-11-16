//
//  YLPrivacyPermissionCamera.m
//  YLPrivacyPermission
//
//  Created by xyanl on 2020/11/9.
//

#import "YLPrivacyPermissionCamera.h"

@implementation YLPrivacyPermissionCamera

+ (BOOL)authorized
{
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)])
    {
        AVAuthorizationStatus permission =
        [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        return permission == AVAuthorizationStatusAuthorized;
        
    } else {
        // Prior to iOS 7 all apps were authorized.
        return YES;
    }
}

+ (AVAuthorizationStatus)authorizationStatus
{
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)])
    {
        return [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    } else {
        // Prior to iOS 7 all apps were authorized.
        return AVAuthorizationStatusAuthorized;
    }
}

+ (void)authorizeWithCompletion:(void(^)(BOOL granted,BOOL firstTime))completion
{
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
        AVAuthorizationStatus permission =
        [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        switch (permission) {
            case AVAuthorizationStatusAuthorized:
                completion(YES,NO);
                break;
            case AVAuthorizationStatusDenied:
            case AVAuthorizationStatusRestricted:
                completion(NO,NO);
                break;
            case AVAuthorizationStatusNotDetermined:
            {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                                         completionHandler:^(BOOL granted) {
                    if (completion) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completion(granted,YES);
                        });
                    }
                }];
                
            }
                break;
        }
    } else {
        // Prior to iOS 7 all apps were authorized.
        completion(YES,NO);
    }
}

/// 当前隐私许可状态描述
+ (NSString *)authorizationStatusDescribe{
    NSString *strPermission = @"";
    switch ([YLPrivacyPermissionCamera authorizationStatus]) {
        case AVAuthorizationStatusNotDetermined:
            strPermission = @"用户还没有决定客户端是否可以访问硬件。";
            break;
        case AVAuthorizationStatusRestricted:
            strPermission = @"权限受到限制";
            break;
        case AVAuthorizationStatusDenied:
            strPermission = @"没有权限";
            break;
        case AVAuthorizationStatusAuthorized:
            strPermission = @"权限已经获取";
            break;
        default:
            break;
    }
    return strPermission;
}

@end
