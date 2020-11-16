//
//  YLPrivacyPermissionMicrophone.h
//  YLPrivacyPermission
//
//  Created by xyanl on 2020/11/9.
//
//  麦克风
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLPrivacyPermissionMicrophone : NSObject

+ (BOOL)authorized;

/**
 permission status
 
 0 ：AVAudioSessionRecordPermissionUndetermined
 1 ：AVAudioSessionRecordPermissionDenied
 2 ：AVAudioSessionRecordPermissionGranted
 
 @return status
 */
+ (NSInteger)authorizationStatus;

+ (void)authorizeWithCompletion:(void(^)(BOOL granted,BOOL firstTime))completion;

/// 当前隐私许可状态描述
+ (NSString *)authorizationStatusDescribe;

@end

NS_ASSUME_NONNULL_END
