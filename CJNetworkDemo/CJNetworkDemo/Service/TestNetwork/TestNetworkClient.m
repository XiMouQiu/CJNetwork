//
//  TestNetworkClient.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/12/20.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "TestNetworkClient.h"
#import "TestHTTPSessionManager.h"


@implementation TestNetworkClient

+ (TestNetworkClient *)sharedInstance {
    static TestNetworkClient *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (nullable NSURLSessionDataTask *)test_postUrl:(nullable NSString *)Url
                                       params:(nullable id)params
                                        cache:(BOOL)cache
                                completeBlock:(void (^)(CJResponseModel *responseModel))completeBlock
{
    AFHTTPSessionManager *manager = [TestHTTPSessionManager sharedInstance];
    
    NSURLSessionDataTask *URLSessionDataTask =
    [manager cjCache_postUrl:Url params:params shouldCache:cache encrypt:NO encryptBlock:nil decryptBlock:nil progress:nil logType:CJNetworkLogTypeConsoleLog success:^(CJSuccessNetworkInfo * _Nullable successNetworkInfo, BOOL isCacheData) {
        NSDictionary *responseDictionary = successNetworkInfo.responseObject;
        CJResponseModel *responseModel = [[CJResponseModel alloc] init];
        responseModel.status = [responseDictionary[@"status"] integerValue];
        responseModel.message = responseDictionary[@"message"];
        responseModel.result = responseDictionary[@"result"];
        responseModel.isCacheData = isCacheData;
        if (completeBlock) {
            completeBlock(responseModel);
        }
        
    } failure:^(CJFailureNetworkInfo * _Nullable failureNetworkInfo) {
        CJResponseModel *responseModel = [[CJResponseModel alloc] init];
        responseModel.status = -1;
        responseModel.message = NSLocalizedString(@"网络请求失败", nil);
        responseModel.result = nil;
        responseModel.isCacheData = NO;
        if (completeBlock) {
            completeBlock(responseModel);
        }
    }];
    return URLSessionDataTask;
}

- (void)requestBaiduHomeCompleteBlock:(void (^)(CJResponseModel *responseModel))completeBlock {
    NSString *Url = @"https://www.baidu.com";
    NSDictionary *parameters = nil;
    
    [self test_postUrl:Url params:parameters cache:NO completeBlock:completeBlock];
}

@end
