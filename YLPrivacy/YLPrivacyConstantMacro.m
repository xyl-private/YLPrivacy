//
//  YLPrivacyConstantMacro.m
//  YLPrivacy
//
//  Created by xyanl on 2020/11/16.
//

#import "YLPrivacyConstantMacro.h"

@implementation YLPrivacyConstantMacro

NSString * YLPrivacyNameFromType(YLPrivacyPermissionType type) {
    NSString *strClass = @"";
    switch (type) {
        case YLPrivacyPermissionType_Location:
            strClass = @"定位";
            break;
        case YLPrivacyPermissionType_Camera:
            strClass = @"相机";
            break;
        case YLPrivacyPermissionType_Photos:
            strClass = @"相册";
            break;
        case YLPrivacyPermissionType_Contacts:
            strClass = @"通讯录";
            break;
        case YLPrivacyPermissionType_Reminders:
            strClass = @"提醒事项";
            break;
        case YLPrivacyPermissionType_Calendar:
            strClass = @"日历";
            break;
        case YLPrivacyPermissionType_Microphone:
            strClass = @"麦克风";
            break;
        case YLPrivacyPermissionType_Health:
            strClass = @"健康";
            break;
        case YLPrivacyPermissionType_DataNetwork:
            strClass = @"网络";
            break;
        case YLPrivacyPermissionType_MediaLibrary:
            strClass = @"媒体库";
            break;
        case YLPrivacyPermissionType_Tracking:
            strClass = @"广告追踪";
            break;
        case YLPrivacyPermissionType_Notification:
            strClass = @"通知";
            break;
        default:
            break;
    }
    return strClass;
}
@end
