//
//  YLPrivacyPermissionController.m
//  YLPrivacyPermission
//
//  Created by xyanl on 2020/11/9.
//

#import "YLPrivacyPermissionController.h"
#import "YLPrivacyPermissionTableViewCell.h"
#import "YLPrivacyPermission.h"
#import "YLPrivacyPermissionPhotos.h"
#import "YLPrivacyPermissionCamera.h"
#import "YLPrivacyPermissionLocation.h"
#import "YLPrivacyPermissionMicrophone.h"
#import "YLPrivacyPermissionNet.h"
#import "YLPrivacyPermissionTracking.h"
#import "YLPrivacyPermissionMediaLibrary.h"
#import "YLPrivacyPermissionContacts.h"
#import "YLPrivacyPermissionReminders.h"
#import "YLPrivacyPermissionCalendar.h"
#import "YLPrivacyPermissionHealth.h"
#import "YLPrivacyPermissionNotification.h"
#import "YLPrivacyPermissionSetting.h"

@interface YLPrivacyPermissionController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *listView;

@property (nonatomic, strong) NSArray *listContent;

@property (nonatomic, copy) NSString *strNetStatus;
@property (nonatomic, assign) BOOL netAuthorized;
@end

@implementation YLPrivacyPermissionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"权限获取测试";
    self.netAuthorized = NO;
    self.listContent = @[
        @{@"name":@"相册",@"type":@(YLPrivacyPermissionType_Photos),@"img":@"ic_logo_photo"},
        @{@"name":@"相机",@"type":@(YLPrivacyPermissionType_Camera),@"img":@"ic_logo_camera"},
        @{@"name":@"位置",@"type":@(YLPrivacyPermissionType_Location),@"img":@"ic_logo_location"},
        @{@"name":@"麦克风",@"type":@(YLPrivacyPermissionType_Microphone),@"img":@"ic_logo_microphone"},
        @{@"name":@"网络",@"type":@(YLPrivacyPermissionType_DataNetwork),@"img":@"ic_logo_net"},
        @{@"name":@"推送",@"type":@(YLPrivacyPermissionType_Notification),@"img":@"ic_logo_push"},
        @{@"name":@"广告跟踪",@"type":@(YLPrivacyPermissionType_Tracking),@"img":@"ic_logo_ad"},
        @{@"name":@"媒体库",@"type":@(YLPrivacyPermissionType_MediaLibrary),@"img":@"ic_logo_media"},
        @{@"name":@"联系人",@"type":@(YLPrivacyPermissionType_Contacts),@"img":@"ic_logo_contact"},
        @{@"name":@"提醒事项",@"type":@(YLPrivacyPermissionType_Reminders),@"img":@"ic_logo_reminder"},
        @{@"name":@"日历",@"type":@(YLPrivacyPermissionType_Calendar),@"img":@"ic_logo_calendar"},
        @{@"name":@"健康",@"type":@(YLPrivacyPermissionType_Health),@"img":@"ic_logo_health"}
    ];
    
    _listView.delegate = self;
    _listView.dataSource = self;
    _listView.rowHeight = 64;
    [_listView registerNib:[UINib nibWithNibName:@"YLPrivacyPermissionTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [_listView reloadData];
    
    //监听网络权限
    [self netPermissionlisten];
    [[NSNotificationCenter defaultCenter] addObserver:self.listView selector:@selector(reloadData) name:UIApplicationDidBecomeActiveNotification object:nil];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listContent.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YLPrivacyPermissionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.enableLabel.layer.cornerRadius = 4;
    cell.enableLabel.layer.masksToBounds = YES;
    
    NSDictionary *content = self.listContent[indexPath.row];
    
    NSNumber *numType = content[@"type"];
    
    cell.topLable.text = content[@"name"];
    cell.leftImageView.image = [UIImage imageNamed:content[@"img"]];
    cell.rightImageView.hidden = YES;
    cell.enableLabel.hidden = YES;
    
    YLPrivacyPermissionType type = numType.integerValue;
    NSString *strPermission = @"";
    
    //可统一接口获取权限状态
    BOOL permissionEnabled = [YLPrivacyPermission authorizedWithType:numType.integerValue];
    //    BOOL enabled = [YLPrivacyPermission isServicesEnabledWithType:YLPrivacyPermissionType_Location];
    
    switch (type) {
        case YLPrivacyPermissionType_Photos:
        {
            strPermission = [YLPrivacyPermissionPhotos authorizationStatusDescribe];
        } break;
        case YLPrivacyPermissionType_Camera:
        {
            strPermission = [YLPrivacyPermissionCamera authorizationStatusDescribe];
        } break;
        case YLPrivacyPermissionType_Location:
        {
            if ([YLPrivacyPermissionLocation isServicesEnabled]) {
                strPermission = [YLPrivacyPermissionCamera authorizationStatusDescribe];
            }else {
                strPermission = @"系统定位未开启,请在 设置->定位服务 开启";
            }
        } break;
        case YLPrivacyPermissionType_Microphone:
        {
            strPermission = [YLPrivacyPermissionMicrophone authorizationStatusDescribe];
        } break;
        case YLPrivacyPermissionType_DataNetwork:
        {
            strPermission = _strNetStatus;
            permissionEnabled = _netAuthorized;
        } break;
        case YLPrivacyPermissionType_Tracking:
        {
            strPermission = [YLPrivacyPermissionTracking authorizationStatusDescribe];
        } break;
        case YLPrivacyPermissionType_MediaLibrary:
        {
            strPermission = [YLPrivacyPermissionMediaLibrary authorizationStatusDescribe];
        } break;
        case YLPrivacyPermissionType_Contacts:
        {
            strPermission = [YLPrivacyPermissionContacts authorizationStatusDescribe];
        } break;
        case YLPrivacyPermissionType_Reminders:
        {
            strPermission = [YLPrivacyPermissionReminders authorizationStatusDescribe];
        } break;
        case YLPrivacyPermissionType_Calendar:
        {
            strPermission = [YLPrivacyPermissionCalendar authorizationStatusDescribe];
        } break;
        case YLPrivacyPermissionType_Health:
        {
            if ([YLPrivacyPermissionHealth isHealthDataAvailable]) {
                strPermission = [YLPrivacyPermissionHealth authorizationStatusDescribe];
            } else {
                strPermission = @"设备不支持";
            }
            strPermission = [NSString stringWithFormat:@"%@-注意:健康权限需要证书增加配置",strPermission];
        } break;
        case YLPrivacyPermissionType_Notification:
        {
            strPermission = [YLPrivacyPermissionNotification authorizationStatusDescribe];
        } break;
        default:
            break;
    }
    
    cell.bottomLabel.text = strPermission;
    if (permissionEnabled) {
        cell.rightImageView.hidden = NO;
    } else{
        cell.enableLabel.hidden = NO;
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *content = self.listContent[indexPath.row];
    NSNumber *numType = content[@"type"];
    YLPrivacyPermissionType type = numType.integerValue;
    if (type == YLPrivacyPermissionType_Location) {
        if (![YLPrivacyPermissionLocation isServicesEnabled]) {
            [YLPrivacyPermissionSetting showAlertToDislayPrivacySettingWithTitle:@"提示" msg:@"请在系统 设置->隐私->定位服务 开启" cancel:@"" setting:@"知道了"];
            return;
        }
    } else if(type == YLPrivacyPermissionType_DataNetwork) {
        [YLPrivacyPermissionSetting showAlertToDislayPrivacySettingWithTitle:@"提示" msg:@"是否前往设置修改权限" cancel:@"取消" setting:@"设置"];
        return;
    }
    
    [YLPrivacyPermission authorizeWithType:numType.integerValue completion:^(BOOL granted, BOOL firstTime) {
        [self.listView reloadData];
        if (!granted) {
            NSString *msg = [NSString stringWithFormat:@"没有 %@ 权限，是否前往设置",YLPrivacyNameFromType(numType.integerValue)];
            if (numType.integerValue == YLPrivacyPermissionType_Tracking) {
                if (@available(iOS 14.0, *)) {
                    msg = @"没有广告权限,是否前往设置(App跟踪权限 需要检查系统权限是否开启 设置->隐私->跟踪)";
                }else{
                    msg = @"没有广告权限,需要检查系统权限是否开启 设置->隐私->广告->限制广告跟踪)";
                    [YLPrivacyPermissionSetting showAlertToDislayPrivacySettingWithTitle:@"提示" msg:msg cancel:@"" setting:@"知道了"];
                    return;
                }
            }
            [YLPrivacyPermissionSetting showAlertToDislayPrivacySettingWithTitle:@"提示" msg:msg cancel:@"" setting:@"知道了"];
        }
    }];
    
}

#pragma mark- 网络请求
- (void)netGetRequest
{
    //1，创建请求地址
    NSString *urlString = @"https://tcc.taobao.com/cc/json/mobile_tel_segment.htm?tel=15852509988";
    //对字符进行处理
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    //2.创建请求类
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //3.创建会话（单例）
    NSURLSession *sharedSession = [NSURLSession sharedSession];
    
    //4.根据会话创建任务
    NSURLSessionDataTask *dataTask = [sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"%@",data);
    }];
    
    //5.启动任务
    [dataTask resume];
}

- (void)netPermissionlisten
{
    __weak __typeof(self) weakSelf = self;
    NSString *hostName = @"www.baidu.com";
    [[YLPrivacyPermissionNet sharedManager] startListenNetWithHostName:hostName onNetStatus:^(NetReachWorkStatus netStatus) {
        /// 打印当前状态
        __strong __typeof(self) strongSelf = weakSelf;
        strongSelf.strNetStatus = [YLPrivacyPermissionNet authorizationStatusDescribe:netStatus];
    } onNetPermission:^(BOOL granted) {
        __strong __typeof(self) strongSelf = weakSelf;
        strongSelf.netAuthorized = granted;
        if (!granted) {
            strongSelf.strNetStatus = @"可能没有网络权限或系统网络关闭了";
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.listView reloadData];
        });
        
    }];
}

@end
