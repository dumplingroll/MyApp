//
//  AddsTimer.m
//  食趣
//
//  Created by 汤汤 on 15/10/23.
//  Copyright (c) 2015年 汤汤. All rights reserved.
//

#import "AddsTimer.h"
#define addsAnimationTimer 5.0 //首页顶部广告自动跳转时间间隔
@implementation AddsTimer
+(id)timerManager
{
    static AddsTimer *_t = nil;
    if (!_t) {
        _t = [[AddsTimer alloc]init];
        
    }
    
    return _t;
}

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:addsAnimationTimer target:self selector:@selector(addsAnmation) userInfo:nil repeats:YES];
    }
    return self;
}

-(void)addsAnmation
{
    self.block();
}

-(void)addAnimation:(void (^)())animation
{
    self.block = animation;
}

@end
