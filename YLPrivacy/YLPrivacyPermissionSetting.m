//
//  YLPrivacyPermissionSetting.m
//  YLPrivacyPermission
//
//  Created by xyanl on 2020/11/9.
//

#import "YLPrivacyPermissionSetting.h"
#import <UIKit/UIKit.h>

@implementation YLPrivacyPermissionSetting

#pragma mark-  disPlayAppPrivacySetting

+ (void)displayAppPrivacySettings
{
    if (@available(iOS 8,*))
    {
        if (UIApplicationOpenSettingsURLString != NULL)
        {
            NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            
            if (@available(iOS 10,*)) {
                [[UIApplication sharedApplication]openURL:appSettings options:@{} completionHandler:^(BOOL success) {
                }];
            }
            else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"// 找到警告的类型
                [[UIApplication sharedApplication]openURL:appSettings];
#pragma clang diagnostic pop
            }
        }
    }
}

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
                                         setting:(NSString*)setting
{
    if (@available(iOS 8,*)) {
        
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        if (cancel.length > 0) {
            //cancel
            UIAlertAction *action = [UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            }];
            [alertController addAction:action];
        }
        //ok
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:setting style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self displayAppPrivacySettings];
        }];
        [alertController addAction:okAction];
        [[self yl_getCurrentVC] presentViewController:alertController animated:YES completion:nil];
    }
}

//获取当前屏幕显示的viewcontroller
+ (UIViewController *) yl_getCurrentVC
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    return currentVC;
}

+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        rootVC = [rootVC presentedViewController];
    }
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
    } else {
        // 根视图为非导航类
        currentVC = rootVC;
    }
    return currentVC;
}

@end
