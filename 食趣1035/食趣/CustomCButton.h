//
//  CustomCButton.h
//  食趣
//
//  Created by 汤汤 on 15/10/26.
//  Copyright © 2015年 汤汤. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomCButton;

typedef void(^ButtonBlock)(CustomCButton *btn);

@interface CustomCButton : UIButton

@property (nonatomic,copy)ButtonBlock actionBlock;

+ (CustomCButton *)buttonWithFrame:(CGRect)frame type:(UIButtonType)type action:(ButtonBlock)block;

+ (CustomCButton *)buttonWithFrame:(CGRect)frame type:(UIButtonType)type image:(NSString *)image action:(ButtonBlock)block;

+ (CustomCButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title type:(UIButtonType)type image:(NSString *)image action:(ButtonBlock)block;

@end
