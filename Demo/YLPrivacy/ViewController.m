//
//  ViewController.m
//  YLPrivacyPermission
//
//  Created by xyanl on 2020/11/9.
//

#import "ViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}

- (IBAction)settingAction:(id)sender {
    [self.navigationController pushViewController:[NSClassFromString(@"YLPrivacyPermissionController") new] animated:YES];
}

@end
