//
//  EncryptHomeViewController.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/3/26.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "EncryptHomeViewController.h"
#import <CQDemoKit/CJUIKitToastUtil.h>
#import <CQDemoKit/CJUIKitAlertUtil.h>

#import "LoginViewController.h"

#import "TestNetworkClient+TestRequest.h"
#import "TestNetworkClient+TestCache.h"


#import "HealthyNetworkClient.h"
#import "HealthyHTTPSessionManager.h"

@interface EncryptHomeViewController ()

@property (nonatomic, strong) dispatch_queue_t commonConcurrentQueue; //创建并发队列

@end

@implementation EncryptHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = NSLocalizedString(@"Encrypt首页", nil);
    
    
    NSMutableArray *sectionDataModels = [[NSMutableArray alloc] init];
    
    //网络缓存时间相关(Cache)
    {
        CJSectionDataModel *sectionDataModel = [[CJSectionDataModel alloc] init];
        sectionDataModel.theme = @"网络能否请求相关(Just Request)";
        
        {
            CJModuleModel *loginModule = [[CJModuleModel alloc] init];
            loginModule.title = @"登录(健康)";
            loginModule.selector = @selector(testLoginHealth);
            [sectionDataModel.values addObject:loginModule];
        }
        
        {
            CJModuleModel *loginModule = [[CJModuleModel alloc] init];
            loginModule.title = @"LoginViewController";
            loginModule.classEntry = [LoginViewController class];
            [sectionDataModel.values addObject:loginModule];
        }
        
        [sectionDataModels addObject:sectionDataModel];
    }
    
    //网络请求
    {
        CJSectionDataModel *sectionDataModel = [[CJSectionDataModel alloc] init];
        sectionDataModel.theme = @"网络请求";
        
        {
            CJModuleModel *loginModule = [[CJModuleModel alloc] init];
            loginModule.title = @"测试网络请求";
            loginModule.actionBlock = ^{
                [[TestNetworkClient sharedInstance] testRequestWithSuccess:^(CJResponseModel *responseModel) {
                    NSLog(@"接口测试成功。。。%@", responseModel.responseDictionary);
                } failure:^(BOOL isRequestFailure, NSString *errorMessage) {
                    NSLog(@"接口测试失败。。。");
                }];
            };
            [sectionDataModel.values addObject:loginModule];
        }
        
        [sectionDataModels addObject:sectionDataModel];
    }
    
    //网络缓存时间相关(Cache)
    {
        CJSectionDataModel *sectionDataModel = [[CJSectionDataModel alloc] init];
        sectionDataModel.theme = @"网络缓存时间相关(Cache)";
        
        {
            CJModuleModel *loginModule = [[CJModuleModel alloc] init];
            loginModule.title = @"测试缓存时间(请一定要执行验证)";
            loginModule.selector = @selector(testCacheTime);
            [sectionDataModel.values addObject:loginModule];
        }
        
        [sectionDataModels addObject:sectionDataModel];
    }

    self.sectionDataModels = sectionDataModels;
}

- (void)goLogin {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    LoginViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 测试缓存时间
/// 测试缓存时间
- (void)testCacheTime {
    // checkTestCacheTime 检查是否可以开始测试'设置的缓存过期时间是否有效'的问题
    
    [[TestNetworkClient sharedInstance] testEndWithCacheIfExistWithSuccess:^(CJResponseModel *responseModel) {
        [self startTestCacheTime];
        
    } failure:^(BOOL isRequestFailure, NSString *errorMessage) {
        if (isRequestFailure) {
            [CJUIKitAlertUtil showAlertInViewController:self
                                              withTitle:@"网络请求失败，无法测试'设置的缓存过期时间是否有效'的问题，请先保证网络请求成功"
                                                message:errorMessage
                                            cancleBlock:nil
                                                okBlock:nil];
        }
    }];
}

- (void)startTestCacheTime {
    NSLog(@"第一次请求到的肯定是非缓存的数据，否则错误");
    
    [[TestNetworkClient sharedInstance] removeCacheForEndWithCacheIfExistApi];
    
    [[TestNetworkClient sharedInstance] testEndWithCacheIfExistWithSuccess:^(CJResponseModel *responseModel) {
        if (responseModel.isCacheData == NO) {
            [CJUIKitToastUtil showMessage:@"①测试通过：第一次请求到的肯定是非缓存的数据"];
        } else {
            [CJUIKitAlertUtil showAlertInViewController:self
                                              withTitle:@"①测试不通过：第一次请求到的不是非缓存的数据"
                                                message:nil
                                            cancleBlock:nil
                                                okBlock:nil];
        }
    } failure:nil];
    
    NSLog(@"在缓存过期10秒内，请求到的肯定是缓存的数据，否则错误");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[TestNetworkClient sharedInstance] testEndWithCacheIfExistWithSuccess:^(CJResponseModel *responseModel) {
            if (responseModel.isCacheData == YES) {
                [CJUIKitToastUtil showMessage:@"②测试通过：在缓存过期10秒内(现在是5秒)，请求到的肯定是缓存的数据"];
            } else {
                [CJUIKitAlertUtil showAlertInViewController:self
                                                  withTitle:@"②测试不通过：在缓存过期10秒内(现在是5秒)，请求到的不是缓存的数据"
                                                    message:nil
                                                cancleBlock:nil
                                                    okBlock:nil];
            }
        } failure:nil];
    });
    
    NSLog(@"在缓存过期10秒后，请求到的肯定是非缓存的数据，否则错误");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(11 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[TestNetworkClient sharedInstance] testEndWithCacheIfExistWithSuccess:^(CJResponseModel *responseModel) {
            if (responseModel.isCacheData == NO) {
                [CJUIKitToastUtil showMessage:@"③测试通过：在缓存过期10秒后(现在是11秒)，请求到的肯定是非缓存的数据"];
                [CJUIKitAlertUtil showAlertInViewController:self
                                                  withTitle:@"测试缓存时间通过"
                                                    message:nil
                                                cancleBlock:nil
                                                    okBlock:nil];
            } else {
                [CJUIKitAlertUtil showAlertInViewController:self
                                                  withTitle:@"③测试不通过：在缓存过期10秒后(现在是11秒)，请求到的不是非缓存的数据"
                                                    message:nil
                                                cancleBlock:nil
                                                    okBlock:nil];
            }
        } failure:nil];
    });
}

#pragma mark - 测试登录健康

- (void)testLoginHealth {
    [self loginHealthWithCompleteBlock:^(CJResponseModel *responseModel) {
        if (responseModel.statusCode == 0) {
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"登录成功", nil)];
            if (responseModel.cjNetworkLog) {
                [CJUIKitAlertUtil showAlertInViewController:self
                                                  withTitle:@"登录提醒"
                                                    message:responseModel.cjNetworkLog
                                                cancleBlock:nil
                                                    okBlock:nil];
                [CJLogViewWindow appendObject:responseModel.cjNetworkLog];
            }
            
        } else {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"登录失败", nil)];
            
            [CJLogViewWindow appendObject:@"加密页面的健康登录失败"];
            if (responseModel.cjNetworkLog) {
                [CJUIKitAlertUtil showAlertInViewController:self
                                                  withTitle:@"登录提醒"
                                                    message:responseModel.cjNetworkLog
                                                cancleBlock:nil
                                                    okBlock:nil];
                [CJLogViewWindow appendObject:responseModel.cjNetworkLog];
            }
        }
    }];
}

- (void)loginHealthWithCompleteBlock:(void (^)(CJResponseModel *responseModel))completeBlock {
    NSString *apiName = @"/login";
    NSDictionary *params = @{@"username" : @"test",
                             @"password" : @"test",
                             };
    /*
    AFHTTPSessionManager *manager = [HealthyHTTPSessionManager sharedInstance];
    [manager cj_postUrl:UITrackingRunLoopMode params:params settingModel:nil success:^(CJSuccessRequestInfo * _Nullable successRequestInfo) {
        <#code#>
    } failure:^(CJFailureRequestInfo * _Nullable failureRequestInfo) {
        <#code#>
    }];
    */
    [[HealthyNetworkClient sharedInstance] health_postApi:apiName params:params encrypt:YES success:^(HealthResponseModel *responseModel) {
        if (completeBlock) {
            completeBlock(responseModel);
        }
        
    } failure:^(NSString *errorMessage) {
        CJResponseModel *responseModel = [[CJResponseModel alloc] init];
        responseModel.statusCode = -1;
        responseModel.message = NSLocalizedString(@"网络请求失败", nil);
        responseModel.result = nil;
        //responseModel.cjNetworkLog = error.userInfo[@"cjNetworkLog"];
        if (completeBlock) {
            completeBlock(responseModel);
        }
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
