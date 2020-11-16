//
//  YLPrivacyPermissionData.m
//  YLPrivacyPermission
//
//  Created by xyanl on 2020/11/9.
//

#import "YLPrivacyPermissionData.h"
#import <CoreTelephony/CTCellularData.h>

@interface YLPrivacyPermissionData()

@property (nonatomic, strong) id cellularData;
@property (nonatomic, copy) void (^completion)(BOOL granted,BOOL firstTime);
@end

@implementation YLPrivacyPermissionData

+ (instancetype)sharedManager
{
    static YLPrivacyPermissionData* _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[YLPrivacyPermissionData alloc] init];
        
    });
    
    return _sharedInstance;
}


+ (void)authorizeWithCompletion:(void(^)(BOOL granted,BOOL firstTime))completion
{
    if (@available(iOS 10,*)) {
        
        [YLPrivacyPermissionData sharedManager].completion = completion;
        
        if (![YLPrivacyPermissionData sharedManager].cellularData) {
            
            CTCellularData *cellularData = [[CTCellularData alloc] init];
            
            cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (state == kCTCellularDataNotRestricted) {
                        //没有限制
                        [YLPrivacyPermissionData sharedManager].completion(YES,NO);
                        NSLog(@"有网络权限");
                    }
                    else if (state == kCTCellularDataRestrictedStateUnknown)
                    {
                        //                    completion(NO,NO);
                        NSLog(@"没有请求网络或正在等待用户确认权限?");
                    }
                    else{
                        //
                        [YLPrivacyPermissionData sharedManager].completion(NO,NO);
                        NSLog(@"无网络权限");
                    }
                });
            };
            
            //不存储，对象cellularData会销毁
            [YLPrivacyPermissionData sharedManager].cellularData = cellularData;
        }
    }
    else
    {
        completion(YES,NO);
    }

}

@end
