//
//  YLPrivacyPermissionNet.m
//  YLPrivacyPermission
//
//  Created by xyanl on 2020/11/9.
//

#import "YLPrivacyPermissionNet.h"
#import "NetReachability.h"
#import "YLPrivacyPermissionData.h"

@interface YLPrivacyPermissionNet()
@property (nonatomic,strong) NetReachability *hostReachability;
@property (nonatomic, assign) BOOL netReachable;
@property (nonatomic, assign) BOOL permissionGranted;
/**
 实时返回网络状态
 */
@property (nonatomic, copy) void (^onNetStatus)(NetReachWorkStatus netStatus);

/**
 granted : NO 可能没有网络权限,建议用户查看网络权限设置
 */
@property (nonatomic, copy) void (^onNetPermission)(BOOL granted);
@end

@implementation YLPrivacyPermissionNet

+ (instancetype)sharedManager
{
    static YLPrivacyPermissionNet* _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[YLPrivacyPermissionNet alloc] init];
        _sharedInstance.permissionGranted = YES;
    });
    
    return _sharedInstance;
}



/**
 开始监听网络状态，没有网络时自动检查网络权限
 
 @param hostName 域名或ip地址，国内可以使用www.baidu.com，系统API判断是否能连接上改地址，来返回网络状态
 */
- (void)startListenNetWithHostName:(NSString*)hostName
                       onNetStatus:(void(^)(NetReachWorkStatus netStatus))onNetStatus
                   onNetPermission:(void(^)(BOOL granted))onNetPermission
{
    self.onNetStatus = onNetStatus;
    self.onNetPermission = onNetPermission;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NetReachability *reachability = [NetReachability reachabilityWithHostName:hostName];
        self.hostReachability = reachability;
        
        NetReachWorkStatus netStatus = [reachability currentReachabilityStatus];
        [self handNetWithNetStatus:netStatus];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kNetWorkStatusReachabilityChangedNotification object:nil];
        
        [reachability startNotifier];
    });
}

- (void)listenNetPermisson
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [YLPrivacyPermissionData authorizeWithCompletion:^(BOOL granted, BOOL firstTime)
         {
            self.permissionGranted = granted;
            [self handPermission];
        }];
    });
}

- (void)handPermission
{
    if (self.onNetPermission) {
        self.onNetPermission( !(!self.netReachable && !self.permissionGranted) );
    }
}

#pragma mark- 判断网络状态

- (void)reachabilityChanged:(NSNotification *)notification
{
    NetReachability *curReach = [notification object];
    NetReachWorkStatus netStatus = [curReach currentReachabilityStatus];
    
    if (![NSThread isMainThread]) {
        
        NSLog(@"subThread");
    }
    
    
    [self handNetWithNetStatus:netStatus];
}

- (void)handNetWithNetStatus:(NetReachWorkStatus) netStatus
{
    self.netReachable = YES;
    if (netStatus == NetReachWorkNotReachable) {
        self.netReachable = NO;
    }
    
    if (self.onNetStatus) {
        self.onNetStatus(netStatus);
    }
    
    if (self.netReachable) {
        if (self.onNetPermission) {
            self.onNetPermission(YES);
        }
    } else {
        [self listenNetPermisson];
        //        [self handPermission];
    }
}


/// 当前隐私许可状态描述
+ (NSString *)authorizationStatusDescribe:(NetReachWorkStatus) netStatus{
    NSString *strNetStatus = @"";
    switch (netStatus) {
        case NetReachWorkNotReachable:
            NSLog(@"网络不可用");
            strNetStatus = @"网络不可用";
            break;
        case NetReachWorkStatusUnknown:
            NSLog(@"未知网络");
            strNetStatus = @"未知网络";
            break;
        case NetReachWorkStatusWWAN2G:
            NSLog(@"2G网络");
            strNetStatus = @"2G网络";
            break;
        case NetReachWorkStatusWWAN3G:
            strNetStatus = @"3G网络";
            break;
        case NetReachWorkStatusWWAN4G:
            NSLog(@"4G网络");
            strNetStatus = @"4G网络";
            break;
        case NetReachWorkStatusWiFi:
            NSLog(@"WiFi");
            strNetStatus = @"WiFi";
            break;
        default:
            break;
    }
    return strNetStatus;
}

@end
