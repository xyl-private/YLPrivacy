//
//  YLPrivacyPermissionHealth.m
//  YLPrivacyPermission
//
//  Created by xyanl on 2020/11/9.
//

#import "YLPrivacyPermissionHealth.h"
#import <HealthKit/HealthKit.h>

@implementation YLPrivacyPermissionHealth

+ (BOOL)authorized
{
    return [self authorizationStatus] == HKAuthorizationStatusSharingAuthorized;
}

/**
 health status
 
 @return
 0 : NotDetermined
 1 : SharingDenied
 2 : SharingAuthorized
 3 : not support
 */
+ (NSInteger)authorizationStatus
{
    if (@available(iOS 8,*)) {
        
        if (![HKHealthStore isHealthDataAvailable]){
            return HKAuthorizationStatusSharingDenied;
        }
        
        NSMutableSet *readTypes = [NSMutableSet set];
        NSMutableSet *writeTypes = [NSMutableSet set];
        
        HKHealthStore *healthStore = [[HKHealthStore alloc] init];
        NSMutableSet *allTypes = [NSMutableSet set];
        [allTypes unionSet:readTypes];
        [allTypes unionSet:writeTypes];
        for (HKObjectType *sampleType in allTypes) {
            HKAuthorizationStatus status = [healthStore authorizationStatusForType:sampleType];
            return status;
        }
        
        return HKAuthorizationStatusSharingDenied;
    }
    
    return 3;
}

/*!
 @method        isHealthDataAvailable
 @abstract      Returns YES if HealthKit is supported on the device.
 @discussion    HealthKit is not supported on all iOS devices.  Using HKHealthStore APIs on devices which are not
 supported will result in errors with the HKErrorHealthDataUnavailable code.  Call isHealthDataAvailable
 before attempting to use other parts of the framework.
 */
+ (BOOL)isHealthDataAvailable
{
    if (@available(iOS 8,*)) {
        return [HKHealthStore isHealthDataAvailable];
    }
    return NO;
}

+ (void)authorizeWithCompletion:(void(^)(BOOL granted,BOOL firstTime))completion
{
    if ( @available(iOS 8,*) )
    {
        if (![HKHealthStore isHealthDataAvailable])
        {
            completion(NO,YES);
            return;
        }
        
        NSMutableSet *readTypes = [NSMutableSet set];
        NSMutableSet *writeTypes = [NSMutableSet set];
        
        HKHealthStore *healthStore = [[HKHealthStore alloc] init];
        NSMutableSet *allTypes = [NSMutableSet set];
        [allTypes unionSet:readTypes];
        [allTypes unionSet:writeTypes];
        
        if (allTypes.count <= 0 ) {
            //设备不支持健康
            completion(NO,YES);
            return;
        }
        
        for (HKObjectType *healthType in allTypes) {
            HKAuthorizationStatus status = [healthStore authorizationStatusForType:healthType];
            switch (status) {
                case HKAuthorizationStatusNotDetermined:
                {
                    HKHealthStore *healthStore = [[HKHealthStore alloc] init];
                    [healthStore requestAuthorizationToShareTypes:writeTypes
                                                        readTypes:readTypes
                                                       completion:^(BOOL success, NSError *error) {
                        if (completion) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                completion(success,YES);
                            });
                        }
                    }];
                } break;
                case HKAuthorizationStatusSharingAuthorized: {
                    if (completion) {
                        completion(YES, NO);
                    }
                } break;
                case HKAuthorizationStatusSharingDenied: {
                    if (completion) {
                        completion(YES, NO);
                    }
                } break;
            }
        }
    } else if (completion) {
        completion(YES, NO);
    }
}

/// 当前隐私许可状态描述
+ (NSString *)authorizationStatusDescribe{
    NSString *strPermission = @"";
    switch ([YLPrivacyPermissionHealth authorizationStatus]) {
        case HKAuthorizationStatusNotDetermined:
            strPermission = @"权限未确定";
            break;
        case HKAuthorizationStatusSharingDenied:
            strPermission = @"没有权限";
            break;
        case HKAuthorizationStatusSharingAuthorized:
            strPermission = @"权限已经获取";
            break;
        case 3:
            strPermission = @"系统不支持";
            break;
    }
    return strPermission;
}

@end
