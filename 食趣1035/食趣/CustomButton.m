//
//  CustomButton.m
//  食趣
//
//  Created by 汤汤 on 15/10/22.
//  Copyright © 2015年 汤汤. All rights reserved.
//

#import "CustomButton.h"
#import "NetInterface.h"
@implementation CustomButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    }
    return self;
}
-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
//    return CGRectMake((contentRect.size.width-55)/15, 5, 150, 100);
    return CGRectMake(0, 0, (WIDTH-30)/2, 160);
   
}
-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(contentRect.origin.x-50, 140, contentRect.size.width, 10);
}

@end
