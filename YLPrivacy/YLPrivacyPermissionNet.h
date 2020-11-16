//
//  YLPrivacyPermissionNet.h
//  YLPrivacyPermission
//
//  Created by xyanl on 2020/11/9.
//

#import <Foundation/Foundation.h>
#import "NetReachability.h"

NS_ASSUME_NONNULL_BEGIN

@interface YLPrivacyPermissionNet : NSObject

+ (instancetype)sharedManager;


/**
 开始监听网络状态，没有网络时自动检查网络权限
 
 @param hostName 域名或ip地址，国内可以使用www.baidu.com，系统API判断是否能连接上改地址，来返回网络状态
 @param onNetStatus 网络状态回调
 @param onNetPermission 网络权限回调，可能没有网络权限如果granted为NO
 */
- (void)startListenNetWithHostName:(NSString*)hostName
                       onNetStatus:(void(^)(NetReachWorkStatus netStatus))onNetStatus
                   onNetPermission:(void(^)(BOOL granted))onNetPermission;

/// 当前隐私许可状态描述
+ (NSString *)authorizationStatusDescribe:(NetReachWorkStatus) netStatus;

@end

NS_ASSUME_NONNULL_END
