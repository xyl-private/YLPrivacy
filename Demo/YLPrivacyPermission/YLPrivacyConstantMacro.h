//
//  YLPrivacyConstantMacro.h
//  YLPrivacy
//
//  Created by xyanl on 2020/11/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,YLPrivacyPermissionType)
{
    /// 网络
    YLPrivacyPermissionType_DataNetwork,
    /// 定位
    YLPrivacyPermissionType_Location,
    /// 相机
    YLPrivacyPermissionType_Camera,
    /// 相册
    YLPrivacyPermissionType_Photos,
    /// 媒体库
    YLPrivacyPermissionType_MediaLibrary,
    /// 麦克风
    YLPrivacyPermissionType_Microphone,
    /// 通讯录
    YLPrivacyPermissionType_Contacts,
    /// 提醒事项
    YLPrivacyPermissionType_Reminders,
    /// 日历
    YLPrivacyPermissionType_Calendar,
    /// 健康
    YLPrivacyPermissionType_Health,
    /// 广告追踪
    YLPrivacyPermissionType_Tracking,
    /// 通知
    YLPrivacyPermissionType_Notification
};

@interface YLPrivacyConstantMacro : NSObject

/// bannner 图 类型
FOUNDATION_EXTERN NSString * YLPrivacyNameFromType(YLPrivacyPermissionType type);

@end

NS_ASSUME_NONNULL_END
