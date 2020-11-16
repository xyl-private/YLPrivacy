//
//  YLPrivacyPermissionMediaLibrary.h
//  YLPrivacyPermission
//
//  Created by xyanl on 2020/11/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLPrivacyPermissionMediaLibrary : NSObject

+ (BOOL)authorized;

/**
 MediaLibrary permission status
 
 @reture
 0: NotDetermined = 0,
 1: Denied,
 2: Restricted,
 3: Authorized,
 */
+ (NSInteger)authorizationStatus;

+ (void)authorizeWithCompletion:(void(^)(BOOL granted, BOOL firstTime))complection;
/// 当前隐私许可状态描述
+ (NSString *)authorizationStatusDescribe;

@end

NS_ASSUME_NONNULL_END
