//
//  MenuCateCellTableViewCell.h
//  食趣
//
//  Created by 汤汤 on 15/10/20.
//  Copyright © 2015年 汤汤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuModel.h"
@interface MenuCateCellTableViewCell : UITableViewCell<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
   
    
}

- (void)setMenuCateArray:(NSArray *)array;

@property (nonatomic,copy) void (^cateBlock)(NSString *myId,NSString *name);
@end
