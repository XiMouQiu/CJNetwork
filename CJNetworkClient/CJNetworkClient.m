//
//  CJNetworkClient.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/6/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#import "CJNetworkClient.h"
#import <objc/runtime.h>

@interface CJNetworkClient () {
    
}

@end



@implementation CJNetworkClient

- (instancetype)init {
    self = [super init];
    if (self) {
        __weak typeof(self)weakSelf = self;
        _completeFullUrlBlock = ^NSString *(NSString *baseUrl, NSString *apiSuffix) {
            return [weakSelf __completeFullUrlWithBaseUrl:baseUrl apiSuffix:apiSuffix];
        };
        
        _completeAllParamsBlock = ^NSDictionary *(NSDictionary *customParams) {
            NSMutableDictionary *allParams = [[NSMutableDictionary alloc] init];
            if (weakSelf.commonParams) {
                [allParams addEntriesFromDictionary:weakSelf.commonParams];
            }
            if (customParams) {
                [allParams addEntriesFromDictionary:customParams];
            }
            return allParams;
            //return [environmentManager completeParamsWithCustomParams:customParams];
        };
    }
    return self;
}

- (void)setupCleanHTTPSessionManager:(AFHTTPSessionManager *)cleanHTTPSessionManager
             cryptHTTPSessionManager:(AFHTTPSessionManager *)cryptHTTPSessionManager
{
    NSAssert(cleanHTTPSessionManager || cryptHTTPSessionManager, @"不加密和加密的不可以同时都没有");
    _cleanHTTPSessionManager = cleanHTTPSessionManager;
    _cryptHTTPSessionManager = cryptHTTPSessionManager;
}

/*
- (void)setupHTTPSessionManager:(AFHTTPSessionManager *)httpSessionManager cryptWithParamsEncryptHandle:(NSDictionary * _Nonnull (^)(id _Nonnull))paramsCryptHandle responseDataDecryptHandle:(id  _Nonnull (^)(id _Nonnull))responseDataDecryptHandle
{
    _httpSessionManager = httpSessionManager;
    _paramsCryptHandle = paramsCryptHandle;
    _responseDataDecryptHandle = responseDataDecryptHandle;
}
//*/

- (void)setupGetSuccessResponseModelBlock:(CJNetworkClientGetSuccessResponseModelBlock)getSuccessResponseModelBlock
                checkIsCommonFailureBlock:(BOOL(^)(CJResponseModel *responseModel))checkIsCommonFailureBlock
             getFailureResponseModelBlock:(CJNetworkClientGetFailureResponseModelBlock)getFailureResponseModelBlock
{
    NSAssert(getSuccessResponseModelBlock, @"getSuccessResponseModelBlock不能为空");
    NSAssert(getFailureResponseModelBlock, @"getFailureResponseModelBlock不能为空");
    _getSuccessResponseModelBlock = getSuccessResponseModelBlock;
    _checkIsCommonFailureBlock = checkIsCommonFailureBlock;
    _getFailureResponseModelBlock = getFailureResponseModelBlock;
}

/*
#pragma mark - 单例
+ (instancetype)sharedInstance {
    id sharedInstance = objc_getAssociatedObject(self, @"cjNetworkClientSharedInstance");
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL] init];
        objc_setAssociatedObject(self, @"cjNetworkClientSharedInstance", sharedInstance, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return sharedInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

- (id)copyWithZone:(nullable NSZone *)zone {
    return [[self class] sharedInstance];
}
*/



#pragma mark - Private
- (NSString *)__completeFullUrlWithBaseUrl:(NSString *)baseUrl apiSuffix:(NSString *)apiSuffix {
    NSMutableString *fullUrl = [NSMutableString string];
    [fullUrl appendFormat:@"%@", baseUrl];
    
    if ([self.baseUrl hasSuffix:@"/"] == NO) {
        if ([apiSuffix hasPrefix:@"/"]) {
            [fullUrl appendFormat:@"%@", apiSuffix];
        } else { //shouldAddSlash
            [fullUrl appendFormat:@"/%@", apiSuffix];
        }
    } else {
        if ([apiSuffix hasPrefix:@"/"]) {//shouldRemoveSlash
            [fullUrl appendFormat:@"%@", [apiSuffix substringFromIndex:1]];
        } else {
            [fullUrl appendFormat:@"%@", apiSuffix];
        }
    }
    return [fullUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //return [environmentManager completeUrlWithApiSuffix:apiSuffix];
}

@end
