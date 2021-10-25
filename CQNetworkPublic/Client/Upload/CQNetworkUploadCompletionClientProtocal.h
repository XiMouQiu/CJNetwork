//
//  CQNetworkUploadCompletionClientProtocal.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/6/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#ifndef CQNetworkUploadCompletionClientProtocal_h
#define CQNetworkUploadCompletionClientProtocal_h

#import "CJRequestNetworkEnum.h"
#import "CJResponseModel.h"
#import <CJNetworkFileModel/CJUploadFileModel.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CQNetworkUploadCompletionClientProtocal <NSObject>

#pragma mark - Protocal为了解耦需要由分类来实现的方法
@required
#pragma mark - RealApi
/*
 *  上传文件的请求方法：只是上传文件，不对上传过程中的各个时刻信息的进行保存
 *
 *  @param apiSuffix        apiSuffix
 *  @param urlParams        urlParams(需要拼接到url后的参数)
 *  @param formParams       formParams(除fileKey之外需要作为表单提交的参数)
 *  @param uploadFileModels 文件数据：要上传的数据组uploadFileModels
 *  @param uploadProgress   uploadProgress
 *  @param completeBlock    上传结束执行的回调
 *
 *  @return 上传文件的请求
 */
- (nullable NSURLSessionDataTask *)real1_uploadApi:(NSString *)apiSuffix
                                         urlParams:(nullable id)urlParams
                                        formParams:(nullable id)formParams
                                  uploadFileModels:(nullable NSArray<CJUploadFileModel *> *)uploadFileModels
                                          progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                     completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock;

- (NSURLSessionDataTask *)real1_uploadUrl:(NSString *)Url
                                urlParams:(nullable id)urlParams
                               formParams:(nullable id)formParams
                         uploadFileModels:(nullable NSArray<CJUploadFileModel *> *)uploadFileModels
                                 progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                            completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock;


@optional
#pragma mark - simulateApi
// 为方便接口的重复利用回调中的responseModel使用id类型
- (NSURLSessionDataTask *)simulate1_uploadApi:(NSString *)apiSuffix
                                    urlParams:(nullable id)urlParams
                                   formParams:(nullable id)formParams
                             uploadFileModels:(nullable NSArray<CJUploadFileModel *> *)uploadFileModels
                                     progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                completeBlock:(void (^)(CJResponeFailureType failureType, id responseModel))completeBlock;


@optional
#pragma mark - localApi
// 为方便接口的重复利用回调中的responseModel使用id类型
- (nullable NSURLSessionDataTask *)local1_uploadApi:(NSString *)apiSuffix
                                          urlParams:(nullable id)urlParams
                                         formParams:(nullable id)formParams
                                   uploadFileModels:(nullable NSArray<CJUploadFileModel *> *)uploadFileModels
                                           progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                      completeBlock:(void (^)(CJResponeFailureType failureType, id responseModel))completeBlock;

@end


#endif /* CQNetworkUploadCompletionClientProtocal_h */

NS_ASSUME_NONNULL_END
