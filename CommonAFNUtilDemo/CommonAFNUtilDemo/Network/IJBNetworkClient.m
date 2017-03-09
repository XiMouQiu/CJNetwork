//
//  IJBNetworkClient.m
//  CommonAFNUtilDemo
//
//  Created by 李超前 on 2017/3/6.
//  Copyright © 2017年 ciyouzen. All rights reserved.
//

#import "IJBNetworkClient.h"

@implementation IJBNetworkClient

+ (IJBNetworkClient *)sharedInstance {
    static IJBNetworkClient *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (NSURLSessionDataTask *)postWithPath:(NSString *)Url
                                params:(NSDictionary *)params
                               success:(HPSuccess)success
                               failure:(HPFailure)failure
{
    NSLog(@"Url = %@", Url);
    NSLog(@"params = %@", params);
    
    AFHTTPSessionManager *manager = [IjinbuHTTPSessionManager sharedInstance];
    
    NSString *sign = [self signWithParams:params path:nil];
    NSLog(@"sign = %@", sign);
    [manager.requestSerializer setValue:sign forHTTPHeaderField:@"sign"];
    
    NSURLSessionDataTask *dataTask =
    [self useManager:manager postRequestUrl:Url parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"请求ijinbu成功");
        NSLog(@"responseObject = %@", responseObject);
        IjinbuResponseModel *responseModel = [[IjinbuResponseModel alloc] initWithDictionary:responseObject error:nil];
        if ([responseModel.status integerValue] == 1) {
            NSLog(@"登录ijinbu成功");
            if (success) {
                success(responseModel);
            }
            
        } else {
            NSLog(@"登录ijinbu失败");
            
            if (failure) {
                failure(nil);
            }
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *errorMessage = [error localizedDescription];
        NSLog(@"请求ijinbu失败:%@", errorMessage);
        if (failure) {
            failure(nil);
        }
    }];
    
    return dataTask;
}


- (NSString *)signWithParams:(NSDictionary *)params path:(NSString*)path
{
#if 0
    return [[NSString stringWithFormat:@"%@123456", [HPDevice deviceId]] md5Hash];
#else
    NSURL *url = [NSURL URLWithString:path];
    NSString *q = [url query];
    NSArray *kvs = [q componentsSeparatedByString:@"&"];
    NSMutableDictionary *d = [NSMutableDictionary dictionaryWithDictionary:params];
    for (NSString *item in kvs)
    {
        NSArray *a = [item componentsSeparatedByString:@"="];
        if (a.count > 1)
            [d setValue:a[1] forKey:a[0]];
        else if (a.count == 1)
            [d setValue:@"" forKey:a[0]];
    }
    NSArray *keys = [[d allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return [obj1 compare:obj2];
    }];
    NSMutableString *string = [NSMutableString string];
    for (NSUInteger i = 0; i < keys.count; i++) {
        NSObject *value = [d valueForKey:keys[i]];
        [string appendFormat:@"%@%@", keys[i], value!=[NSNull null]?value:@""];
    }
    if (string.length > 0)
    {
        //        [string appendString:@"appKey=9a628966c0f3ff45cf3c68a92ea0ec2a"];
    }
    return [string MD5];
#endif
}


@end
