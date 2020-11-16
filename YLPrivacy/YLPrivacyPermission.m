//
//  YLPrivacyPermission.m
//  YLPrivacyPermission
//
//  Created by xyanl on 2020/11/9.
//

#import "YLPrivacyPermission.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <objc/message.h>


typedef void(^completionPermissionHandler)(BOOL granted,BOOL firstTime);


@implementation YLPrivacyPermission


+ (BOOL)isServicesEnabledWithType:(YLPrivacyPermissionType)type
{
    if (type == YLPrivacyPermissionType_Location)
    {
        SEL sel = NSSelectorFromString(@"isServicesEnabled");
        BOOL ret  = ((BOOL *(*)(id,SEL))objc_msgSend)( NSClassFromString(@"YLPrivacyPermissionLocation"), sel);
        
        return ret;
    }
    return YES;
}

+ (BOOL)isDeviceSupportedWithType:(YLPrivacyPermissionType)type
{
    if (type == YLPrivacyPermissionType_Health) {
        
        SEL sel = NSSelectorFromString(@"isHealthDataAvailable");
        BOOL ret  = ((BOOL *(*)(id,SEL))objc_msgSend)( NSClassFromString(@"YLPrivacyPermissionHealth"), sel);
        return ret;
    }
    return YES;
}

+ (BOOL)authorizedWithType:(YLPrivacyPermissionType)type
{
    NSString *strClass = nil;
    switch (type) {
        case YLPrivacyPermissionType_Location:
            strClass = @"YLPrivacyPermissionLocation";
            break;
        case YLPrivacyPermissionType_Camera:
            strClass = @"YLPrivacyPermissionCamera";
            break;
        case YLPrivacyPermissionType_Photos:
            strClass = @"YLPrivacyPermissionPhotos";
            break;
        case YLPrivacyPermissionType_Contacts:
            strClass = @"YLPrivacyPermissionContacts";
            break;
        case YLPrivacyPermissionType_Reminders:
            strClass = @"YLPrivacyPermissionReminders";
            break;
        case YLPrivacyPermissionType_Calendar:
            strClass = @"YLPrivacyPermissionCalendar";
            break;
        case YLPrivacyPermissionType_Microphone:
            strClass = @"YLPrivacyPermissionMicrophone";
            break;
        case YLPrivacyPermissionType_Health:
            strClass = @"YLPrivacyPermissionHealth";
            break;
        case YLPrivacyPermissionType_DataNetwork:
            break;
        case YLPrivacyPermissionType_MediaLibrary:
            strClass = @"YLPrivacyPermissionMediaLibrary";
            break;
        case YLPrivacyPermissionType_Tracking:
            strClass = @"YLPrivacyPermissionTracking";
            break;
        case YLPrivacyPermissionType_Notification:
            strClass = @"YLPrivacyPermissionNotification";
            break;
            
        default:
            break;
    }
    
    SEL sel = NSSelectorFromString(@"authorized");
    if (strClass) {
        BOOL ret  = ((BOOL *(*)(id,SEL))objc_msgSend)( NSClassFromString(strClass), sel);
        return ret;
    }
    
    return NO;
}

+ (void)authorizeWithType:(YLPrivacyPermissionType)type completion:(void(^)(BOOL granted,BOOL firstTime))completion
{
    NSString *strClass = nil;
    switch (type) {
        case YLPrivacyPermissionType_Location:
            strClass = @"YLPrivacyPermissionLocation";
            break;
        case YLPrivacyPermissionType_Camera:
            strClass = @"YLPrivacyPermissionCamera";
            break;
        case YLPrivacyPermissionType_Photos:
            strClass = @"YLPrivacyPermissionPhotos";
            break;
        case YLPrivacyPermissionType_Contacts:
            strClass = @"YLPrivacyPermissionContacts";
            break;
        case YLPrivacyPermissionType_Reminders:
            strClass = @"YLPrivacyPermissionReminders";
            break;
        case YLPrivacyPermissionType_Calendar:
            strClass = @"YLPrivacyPermissionCalendar";
            break;
        case YLPrivacyPermissionType_Microphone:
            strClass = @"YLPrivacyPermissionMicrophone";
            break;
        case YLPrivacyPermissionType_Health:
            strClass = @"YLPrivacyPermissionHealth";
            break;
        case YLPrivacyPermissionType_DataNetwork:
            strClass = @"YLPrivacyPermissionData";
            break;
        case YLPrivacyPermissionType_MediaLibrary:
            strClass = @"YLPrivacyPermissionMediaLibrary";
            break;
        case YLPrivacyPermissionType_Tracking:
            strClass = @"YLPrivacyPermissionTracking";
            break;
        case YLPrivacyPermissionType_Notification:
            strClass = @"YLPrivacyPermissionNotification";
            break;
            
        default:
            break;
    }
    
    if (strClass) {
        SEL sel = NSSelectorFromString(@"authorizeWithCompletion:");
        ((void(*)(id,SEL, completionPermissionHandler))objc_msgSend)(NSClassFromString(strClass),sel, completion);
    }
}

@end

