//
//  MenuListModel.m
//  食趣
//
//  Created by 汤汤 on 15/10/19.
//  Copyright © 2015年 汤汤. All rights reserved.
//

#import "MenuListModel.h"

@implementation MenuListModel
+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"description":@"myDescription",@"id":@"myId"}];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
