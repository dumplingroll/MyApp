//
//  CustomCButton.m
//  食趣
//
//  Created by 汤汤 on 15/10/26.
//  Copyright © 2015年 汤汤. All rights reserved.
//

#import "CustomCButton.h"

@implementation CustomCButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)btnClicked:(CustomCButton *)btn
{
    NSLog(@"============");
    self.actionBlock(btn);
}

+ (CustomCButton *)buttonWithFrame:(CGRect)frame type:(UIButtonType)type action:(ButtonBlock)block
{
    CustomCButton *btn = [CustomCButton buttonWithType:type];
    btn.frame = frame;
    btn.actionBlock = block;
    [btn setBackgroundImage:[UIImage imageNamed:@"buttonbar_action@2x"] forState:UIControlStateNormal];
    return btn;
}

+ (CustomCButton *)buttonWithFrame:(CGRect)frame type:(UIButtonType)type image:(NSString *)image action:(ButtonBlock)block
{
    CustomCButton *btn = [CustomCButton buttonWithType:type];
    btn.frame = frame;
    btn.actionBlock = block;
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    return btn;
}

+ (CustomCButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title type:(UIButtonType)type image:(NSString *)image action:(ButtonBlock)block
{
    CustomCButton *btn = [CustomCButton buttonWithType:type];
    btn.frame = frame;
    btn.actionBlock = block;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    return btn;
}


@end
