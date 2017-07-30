//
//  MyAFNetWorkHttpRequest.h
//  UI_爱限免
//
//  Created by zhangxueming on 15/10/14.
//  Copyright © 2015年 Eric. All rights reserved.
//

#import <Foundation/Foundation.h>

//定义block类型
typedef void(^AFNetWorkBlock)(NSData *responseData);

@interface MyAFNetWorkHttpRequest : NSObject

- (id)initWithRequest:(NSString *)urlString block:(AFNetWorkBlock)tempBlock;

@property (nonatomic,copy) AFNetWorkBlock actionBlock;

@end
