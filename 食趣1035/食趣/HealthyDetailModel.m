//
//  HealthyDetailModel.m
//  食趣
//
//  Created by 汤汤 on 15/10/22.
//  Copyright © 2015年 汤汤. All rights reserved.
//

#import "HealthyDetailModel.h"

@implementation HealthyDetailModel
+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"description":@"myDescription",@"id":@"myId"}];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
