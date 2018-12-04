//
//  AFManagerClient.h
//  IntelligentBox
//
//  Created by KW on 2018/8/8.
//  Copyright © 2018年 Zhuhia Jieli Technology. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "AFNetworking.h"

//请求成功回调block
typedef void (^requestSuccessBlock)(id responseObject);
//请求失败回调block
typedef void (^requestFailureBlock)(NSError *error);

@interface AFManagerClient : AFHTTPSessionManager
+ (instancetype)sharedClient;
+ (instancetype)sharedRecv;

- (void)postRequestWithUrl:(NSString *)url
                parameters:(NSDictionary *)params
                   success:(requestSuccessBlock)success
                   failure:(requestFailureBlock)failure;

- (void)getRequestWithUrl:(NSString *)url
               parameters:(NSDictionary *)params
                  success:(requestSuccessBlock)success
                  failure:(requestFailureBlock)failure;
@end
