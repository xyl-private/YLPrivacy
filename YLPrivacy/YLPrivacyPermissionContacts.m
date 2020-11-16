//
//  YLPrivacyPermissionContacts.m
//  YLPrivacyPermission
//
//  Created by xyanl on 2020/11/9.
//

#import "YLPrivacyPermissionContacts.h"
#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>

@implementation YLPrivacyPermissionContacts


+ (BOOL)authorized
{
    if (@available(iOS 9,*)) {
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        return status ==  CNAuthorizationStatusAuthorized;
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"// 找到警告的类型
        ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
        return status == kABAuthorizationStatusAuthorized;
#pragma clang diagnostic pop
    }
}

/**
 access authorizationStatus
 
 @return ABAuthorizationStatus:prior to iOS 9 or CNAuthorizationStatus after iOS 9
 */
+ (NSInteger)authorizationStatus
{
    NSInteger status;
    if (@available(iOS 9,*)) {
        status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    }
    else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"// 找到警告的类型
        status = ABAddressBookGetAuthorizationStatus();
#pragma clang diagnostic pop
    }
    return status;
}

+ (void)authorizeWithCompletion:(void(^)(BOOL granted,BOOL firstTime))completion
{
    if (@available(iOS 9,*))
    {
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        switch (status)
        {
            case CNAuthorizationStatusAuthorized:
            {
                if (completion) {
                    completion(YES,NO);
                }
            }
                break;
            case CNAuthorizationStatusDenied:
            case CNAuthorizationStatusRestricted:
            {
                if (completion) {
                    completion(NO,NO);
                }
            }
                break;
            case CNAuthorizationStatusNotDetermined:
            {
                [[CNContactStore new] requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (completion) {
                            completion(granted,YES);
                        }
                    });
                }];
                
            }
                break;
        }
    }
    else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"// 找到警告的类型
        ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
        switch (status) {
            case kABAuthorizationStatusAuthorized: {
                if (completion) {
                    completion(YES,NO);
                }
            } break;
            case kABAuthorizationStatusNotDetermined: {
                ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
                ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                    if (completion) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completion(granted,YES);
                        });
                    }
                });
            } break;
            case kABAuthorizationStatusRestricted:
            case kABAuthorizationStatusDenied: {
                if (completion) {
                    completion(NO,NO);
                }
            } break;
        }
#pragma clang diagnostic pop
    }
}

/// 当前隐私许可状态描述
+ (NSString *)authorizationStatusDescribe{
    NSString *strPermission = @"";
    switch ([YLPrivacyPermissionContacts authorizationStatus]) {
        case 0:
            strPermission = @"权限未确定";
            break;
        case 1:
            strPermission = @"权限受到限制";
            break;
        case 2:
            strPermission = @"没有权限";
            break;
        case 3:
            strPermission = @"权限已经获取";
            break;
    }
    return strPermission;
}

@end
