//
//  HealthyListModel.m
//  食趣
//
//  Created by 汤汤 on 15/10/21.
//  Copyright © 2015年 汤汤. All rights reserved.
//

#import "HealthyListModel.h"

@implementation HealthyListModel
+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"description":@"myDescription",@"id":@"myId"}];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
