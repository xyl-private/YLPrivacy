//
//  YLPrivacyPermissionContacts.h
//  YLPrivacyPermission
//
//  Created by xyanl on 2020/11/9.
//
//  联系人
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLPrivacyPermissionContacts : NSObject

+ (BOOL)authorized;

/**
 access authorizationStatus
 
 @return ABAuthorizationStatus(prior to iOS 9) or CNAuthorizationStatus(after iOS 9)
 */
+ (NSInteger)authorizationStatus;

+ (void)authorizeWithCompletion:(void(^)(BOOL granted,BOOL firstTime))completion;

/// 当前隐私许可状态描述
+ (NSString *)authorizationStatusDescribe;

@end

NS_ASSUME_NONNULL_END
