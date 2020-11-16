//
//  YLPrivacyPermissionTracking.h
//  YLPrivacyPermission
//
//  Created by xyanl on 2020/11/9.
//

#import <Foundation/Foundation.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
NS_ASSUME_NONNULL_BEGIN


#ifndef __IPHONE_14_0
    #define __IPHONE_14_0    140000
#endif

@interface YLPrivacyPermissionTracking : NSObject

+ (BOOL)authorized;

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_14_0
+ (ATTrackingManagerAuthorizationStatus)authorizationStatus API_AVAILABLE(ios(14.0));
#endif

+ (void)authorizeWithCompletion:(void(^)(BOOL granted ,BOOL firstTime ))completion;
/// 当前隐私许可状态描述
+ (NSString *)authorizationStatusDescribe;

@end

NS_ASSUME_NONNULL_END
