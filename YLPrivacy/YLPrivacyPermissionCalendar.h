//
//  YLPrivacyPermissionCalendar.h
//  YLPrivacyPermission
//
//  Created by xyanl on 2020/11/9.
//
//  日历
#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLPrivacyPermissionCalendar : NSObject

+ (BOOL)authorized;

+ (EKAuthorizationStatus)authorizationStatus;

+ (void)authorizeWithCompletion:(void(^)(BOOL granted,BOOL firstTime))completion;

/// 当前隐私许可状态描述
+ (NSString *)authorizationStatusDescribe;

@end

NS_ASSUME_NONNULL_END
