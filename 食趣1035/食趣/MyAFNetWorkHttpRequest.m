//
//  MyAFNetWorkHttpRequest.m
//  UI_爱限免
//
//  Created by zhangxueming on 15/10/14.
//  Copyright © 2015年 Eric. All rights reserved.
//

#import "MyAFNetWorkHttpRequest.h"
#import "AFNetworking.h"

@implementation MyAFNetWorkHttpRequest

- (id)initWithRequest:(NSString *)urlString block:(AFNetWorkBlock)tempBlock
{
    if (self = [super init]) {
        if (_actionBlock) {
            _actionBlock = nil;//让这个block对象最快从内存中释放
        }
        self.actionBlock = tempBlock;
        [self httpRequestWith:urlString];
    }
    return self;
}

- (void)httpRequestWith:(NSString *)urlString
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.actionBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@", error.localizedDescription);
    }];
}
@end
