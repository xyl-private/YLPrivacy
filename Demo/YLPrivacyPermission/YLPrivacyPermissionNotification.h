//
//  YLPrivacyPermissionNotification.h
//  YLPrivacyPermission
//
//  Created by xyanl on 2020/11/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLPrivacyPermissionNotification : NSObject

+ (BOOL)authorized;

/**
 access authorizationStatus
 0: NotDetermined
 1: denied
 2: authorized
 3: 不影响用户操作的通知
 4: clips：临时允许
 */
+ (NSInteger)authorizationStatus;

+ (void)authorizeWithCompletion:(void(^)(BOOL granted,BOOL firstTime))completion;

/// 当前隐私许可状态描述
+ (NSString *)authorizationStatusDescribe;

@end

NS_ASSUME_NONNULL_END
