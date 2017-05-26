//
//  HttpTool.m
//  TestProject
//
//  Created by iOS－Dev on 16/12/12.
//  Copyright © 2016年 iOS－Dev. All rights reserved.
//

#import "HttpTool.h"

@implementation HttpTool

+ (HttpTool *)share{
    
    static HttpTool *tool;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
       
        if (!tool) {
            tool = [[HttpTool alloc]init];
        }
    });
    return tool;
    
}

- (void)getWithUrl:(NSString *)url parameters:(id)parameters sucBlock:(sucBlock)sucBlock failBlok:(failBlok)failBlock{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)requestWithMethod:(NSString *)method url:(NSString *)url parameters:(id)parameters sucBlock:(sucBlock)sucBlock failBlock:(failBlok)failBlock{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", nil];
    if ([method isEqualToString:KGET]) {
        [manager GET:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            if (sucBlock) {
                sucBlock(responseObject);
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            NSLog(@"error:%@",error.description);
            failBlock();
        }];
    }
    
    if ([method isEqualToString:KPOST]) {
        [manager POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            if (sucBlock) {
                sucBlock(responseObject);
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"error:%@",error.description);
            failBlock();
        }];
    }
    
    if ([method isEqualToString:KPUT]) {
        [manager PUT:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            if (sucBlock) {
                sucBlock(responseObject);
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"error:%@",error.description);
            failBlock();
        }];
    }
}

@end
