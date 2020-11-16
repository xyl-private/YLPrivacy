//
//  YLPrivacyPermissionSetting.h
//  YLPrivacyPermission
//
//  Created by xyanl on 2020/11/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLPrivacyPermissionSetting : NSObject

#pragma mark- guide user to show App privacy setting
/**
 show App privacy settings
 */
+ (void)displayAppPrivacySettings;

/**
 show dialog to guide user to show App privacy setting
 
 @param title title
 @param message privacy message
 @param cancel cancel button text
 @param setting setting button text,if user tap this button ,will show App privacy setting
 */
+ (void)showAlertToDislayPrivacySettingWithTitle:(NSString*)title
                                             msg:(NSString*)message
                                          cancel:(NSString*)cancel
                                         setting:(NSString*)setting;

@end

NS_ASSUME_NONNULL_END
