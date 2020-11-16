//
//  YLPrivacyPermissionLocation.h
//  YLPrivacyPermission
//
//  Created by xyanl on 2020/11/9.
//
//  定位
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
    
NS_ASSUME_NONNULL_BEGIN

@interface YLPrivacyPermissionLocation : NSObject

/**
 @return YES if GPS system service enabled,NO if GPS system service is not enabled
 */
+ (BOOL)isServicesEnabled;

+ (BOOL)authorized;

+ (CLAuthorizationStatus)authorizationStatus;

+ (void)authorizeWithCompletion:(void(^)(BOOL granted,BOOL firstTime))completion;
/// 当前隐私许可状态描述
+ (NSString *)authorizationStatusDescribe;
@end

NS_ASSUME_NONNULL_END
