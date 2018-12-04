//
//  AFManagerClient.m
//  IntelligentBox
//
//  Created by KW on 2018/8/8.
//  Copyright © 2018年 Zhuhia Jieli Technology. All rights reserved.
//

#import "AFManagerClient.h"

static NSString * const AFAppDotNetAPIBussinessURLString = @"http://suoaiaibox.100memory.com/";

@implementation AFManagerClient

+ (instancetype)sharedClient {
    static AFManagerClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFManagerClient alloc] initWithBaseURL:[NSURL URLWithString:AFAppDotNetAPIBussinessURLString]];
        
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        
        _sharedClient.requestSerializer.timeoutInterval = 10;
    });
    return _sharedClient;
}

+ (instancetype)sharedRecv {
    static AFManagerClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFManagerClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        _sharedClient.requestSerializer.timeoutInterval = 10;
    });
    return _sharedClient;
}

- (void)postRequestWithUrl:(NSString *)url
                parameters:(NSDictionary *)params
                   success:(requestSuccessBlock)success
                   failure:(requestFailureBlock)failure{
    
    [self POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *result = [responseObject objectForKey:@"result"];
        if([result isEqualToString:@"notLoginYet"]){
            
        }else{
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)getRequestWithUrl:(NSString *)url
               parameters:(NSDictionary *)params
                  success:(requestSuccessBlock)success
                  failure:(requestFailureBlock)failure{
    [self GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *result = [responseObject objectForKey:@"result"];
        if([result isEqualToString:@"notLoginYet"]){
            
        }else{
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

@end
