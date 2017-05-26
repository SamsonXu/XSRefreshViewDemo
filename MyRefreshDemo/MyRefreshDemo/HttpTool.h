//
//  HttpTool.h
//  TestProject
//
//  Created by iOS－Dev on 16/12/12.
//  Copyright © 2016年 iOS－Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "Define.h"
typedef void (^sucBlock)(id responseObject);
typedef void (^failBlok)();

@interface HttpTool : NSObject

@property (nonatomic, copy) sucBlock suckBlock;
@property (nonatomic, copy) failBlok failBlock;

+ (HttpTool *)share;

- (void)requestWithMethod:(NSString *)method url:(NSString *)url parameters:(id)parameters sucBlock:(sucBlock)sucBlock failBlock:(failBlok)failBlock;

@end
