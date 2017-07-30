//
//  MenuPicScrollCell.h
//  食趣
//
//  Created by 汤汤 on 15/10/20.
//  Copyright © 2015年 汤汤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuListModel.h"
@interface MenuPicScrollCell : UITableViewCell<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    UIView *_bgView;
    UILabel *_nameLabel;
    UIImageView *_imageView;
    
}

@property (nonatomic,strong)NSArray *picArray;
//- (void)setMenuPicScrollCell:(NSArray *)array;

@property (nonatomic,strong)void (^transBlock)(MenuListModel *model);

@end
