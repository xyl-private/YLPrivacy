//
//  YLPrivacyPermissionLocation.m
//  YLPrivacyPermission
//
//  Created by xyanl on 2020/11/9.
//

#import "YLPrivacyPermissionLocation.h"
#import <UIKit/UIKit.h>

#ifndef __IPHONE_14_0
#define __IPHONE_14_0    140000
#endif

@interface YLPrivacyPermissionLocation()<CLLocationManagerDelegate>
@property(nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic, copy) void (^permissionCompletion)(BOOL granted,BOOL firstTime);
@property (nonatomic, assign) BOOL firstTime;
@end

@implementation YLPrivacyPermissionLocation

+ (instancetype)sharedManager
{
    static YLPrivacyPermissionLocation* _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[YLPrivacyPermissionLocation alloc] init];
    });
    
    return _sharedInstance;
}

+ (BOOL)isServicesEnabled
{
    return [CLLocationManager locationServicesEnabled];
}

+ (BOOL)authorized
{
    if (@available(iOS 8,*)) {
        CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
        return (authorizationStatus == kCLAuthorizationStatusAuthorizedAlways || authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse);
    }
    else if (@available(iOS 14,*))
    {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_14_0
        CLAuthorizationStatus authorizationStatus = [[YLPrivacyPermissionLocation sharedManager].locationManager authorizationStatus];
        
        return (authorizationStatus == kCLAuthorizationStatusAuthorizedAlways || authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse);
#endif
    }
    
    return YES;
}

+ (CLAuthorizationStatus)authorizationStatus;
{
    if (@available(iOS 14,*))
    {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_14_0
        
        CLAuthorizationStatus authorizationStatus = [[YLPrivacyPermissionLocation sharedManager].locationManager authorizationStatus];
        return authorizationStatus;
#endif
    }
    
    return  [CLLocationManager authorizationStatus];
}

+ (void)authorizeWithCompletion:(void(^)(BOOL granted,BOOL firstTime))completion;
{
    CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
    [YLPrivacyPermissionLocation sharedManager].firstTime = NO;
    switch (authorizationStatus) {
        case kCLAuthorizationStatusAuthorizedAlways://kCLAuthorizationStatusAuthorized both equal 3
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            if (completion) {
                completion(YES,NO);
            }
        } break;
        case kCLAuthorizationStatusNotDetermined:
        {
            if (![self isServicesEnabled]) {
                if (completion) {
                    completion(NO,NO);
                }
                return;
            }
            
            [YLPrivacyPermissionLocation sharedManager].firstTime = YES;
            [[YLPrivacyPermissionLocation sharedManager] startGps:completion];
        }
            break;
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted: {
            if (completion) {
                completion(NO,NO);
            }
        } break;
    }
}

- (CLLocationManager*)locationManager
{
    if (!_locationManager) {
        
        _locationManager = [[CLLocationManager alloc] init];
    }
    return _locationManager;
}

- (void)startGps:(void(^)(BOOL granted,BOOL firstTime))completion
{
    if ( self.locationManager != nil ) {
        [self stopGps];
    }
    
    self.permissionCompletion = completion;
    
    //    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    
    if (@available(iOS 8,*)) {
        
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
            BOOL hasAlwaysKey = [[NSBundle mainBundle]
                                 objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"] != nil;
            BOOL hasWhenInUseKey =
            [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"] !=
            nil;
            if (hasAlwaysKey) {
                [_locationManager requestAlwaysAuthorization];
            } else if (hasWhenInUseKey) {
                [_locationManager requestWhenInUseAuthorization];
            } else {
                // At least one of the keys NSLocationAlwaysUsageDescription or
                // NSLocationWhenInUseUsageDescription MUST be present in the Info.plist
                // file to use location services on iOS 8+.
                NSAssert(hasAlwaysKey || hasWhenInUseKey,
                         @"To use location services in iOS 8+, your Info.plist must "
                         @"provide a value for either "
                         @"NSLocationWhenInUseUsageDescription or "
                         @"NSLocationAlwaysUsageDescription.");
            }
        }
    }
    [self.locationManager startUpdatingLocation];
}

- (void)stopGps
{
    if ( self.locationManager )
    {
        [_locationManager stopUpdatingLocation];
        self.locationManager = nil;
    }
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:{
            //access permission,first callback this status
        } break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways: {
            [self stopGps];
            if (_permissionCompletion) {
                _permissionCompletion(YES,self.firstTime);
            }
            self.permissionCompletion = nil;
        } break;
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted: {
            
            [self stopGps];
            if (_permissionCompletion) {
                _permissionCompletion(NO,self.firstTime);
            }
            self.permissionCompletion = nil;
            break;
        }
    }
    
}

/// 当前隐私许可状态描述
+ (NSString *)authorizationStatusDescribe{
    NSString *strPermission = @"";
    switch ([YLPrivacyPermissionLocation authorizationStatus]) {
        case kCLAuthorizationStatusNotDetermined:
            strPermission = @"权限未确定";
            break;
        case kCLAuthorizationStatusRestricted:
            strPermission = @"权限受到限制";
            break;
        case kCLAuthorizationStatusDenied:
            strPermission = @"没有权限";
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
            strPermission = @"拥有一直使用位置权限";
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            strPermission = @"拥有使用时获取位置权限";
            break;
            
        default:
            break;
    }
    return strPermission;
}

@end
