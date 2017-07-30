//
//  AddsTimer.h
//  食趣
//
//  Created by 汤汤 on 15/10/23.
//  Copyright (c) 2015年 汤汤. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddsTimer : NSObject
@property (nonatomic,copy) void(^block)();
@property (nonatomic,retain) NSTimer *timer;
+(id)timerManager;
-(void)addAnimation:(void (^)())animation;
@end
