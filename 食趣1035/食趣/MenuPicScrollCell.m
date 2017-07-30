//
//  MenuPicScrollCell.m
//  食趣
//
//  Created by 汤汤 on 15/10/20.
//  Copyright © 2015年 汤汤. All rights reserved.
//

#import "MenuPicScrollCell.h"
#import "UIImageView+AFNetworking.h"
#import "MenuListInfoViewController.h"
@implementation MenuPicScrollCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        
        _scrollView=[[UIScrollView alloc]init];
        //_scrollView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_scrollView];
        //NSLog(@"1-%f",self.contentView.frame.size.width);
        for (NSInteger i=0; i<5; i++)
        {
            UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*i, 0, [UIScreen mainScreen].bounds.size.width, 230)];
            
            imageView.tag=100+i;
            [_scrollView addSubview:imageView];
        }
        _bgView=[[UIView alloc]init];
        [self.contentView addSubview:_bgView];
        
        _nameLabel=[[UILabel alloc]init];
        [_bgView addSubview:_nameLabel];
        
        _pageControl=[[UIPageControl alloc]init];
        [_bgView addSubview:_pageControl];

    }
    return self;
}

- (void)setPicArray:(NSArray *)picArray{
    _picArray = picArray;
    // NSLog(@"acarray%ld",_picArray.count);
    _scrollView.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 230);
    // NSLog(@"2-%f",self.contentView.frame.size.width);
    
    if (picArray.count)
    {
        //        NSArray *viewArray = [_scrollView subviews];
        //        for (UIView *view in viewArray) {
        //            [view removeFromSuperview];
        //        }
        for (NSInteger i=0; i<5; i++)
        {
            UIImageView * imageView = (UIImageView *)[_scrollView viewWithTag:100+i];
            //MenuListModel *model=[picArray objectAtIndex:i];
            //[imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://tnfs.tngou.net/image%@",model.img]]];
            imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"main%ld.jpg",(long)i+1]];
            imageView.userInteractionEnabled=YES;
            imageView.tag=i;
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
            [imageView addGestureRecognizer:tap];
            
        }
        
    }
    _scrollView.contentSize=CGSizeMake([UIScreen mainScreen].bounds.size.width*5, 0);
    _scrollView.pagingEnabled=YES;
    _scrollView.delegate=self;
    
    _bgView.frame=CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, 30);
    _bgView.backgroundColor=[UIColor whiteColor];
    _bgView.alpha=0.8;
    
    _nameLabel.frame=CGRectMake(10, 0, 150, 30);
    _nameLabel.textColor=[UIColor brownColor];
    if (_picArray.count) {
        _nameLabel.text=((MenuListModel *)[_picArray objectAtIndex:0]).name;
    }
    
    _pageControl.frame=CGRectMake(170, 0, 225, 30);
    _pageControl.currentPage=0;
    //_pageControl.numberOfPages=5;
    _pageControl.pageIndicatorTintColor=[UIColor lightGrayColor];
    _pageControl.currentPageIndicatorTintColor=[UIColor colorWithRed:62.0/255.0 green:176.0/255.0 blue:193.0/255.0 alpha:1];
}

- (void)setMenuPicScrollCell:(NSArray *)array
{
    self.picArray = array;
   // NSLog(@"acarray%ld",_picArray.count);
    _scrollView.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200);
   // NSLog(@"2-%f",self.contentView.frame.size.width);
    if (array.count)
    {
//        NSArray *viewArray = [_scrollView subviews];
//        for (UIView *view in viewArray) {
//            [view removeFromSuperview];
//        }
        for (NSInteger i=0; i<5; i++)
        {
            UIImageView * imageView = (UIImageView *)[_scrollView viewWithTag:100+i];
            MenuListModel *model=[array objectAtIndex:i];
            [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://tnfs.tngou.net/image%@",model.img]]];
            imageView.userInteractionEnabled=YES;
            imageView.tag=i;
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
            [imageView addGestureRecognizer:tap];
            
        }

    }
    _scrollView.contentSize=CGSizeMake([UIScreen mainScreen].bounds.size.width*5, 0);
    _scrollView.pagingEnabled=YES;
    _scrollView.delegate=self;
    
    _bgView.frame=CGRectMake(0, 170, [UIScreen mainScreen].bounds.size.width, 30);
    _bgView.backgroundColor=[UIColor whiteColor];
    _bgView.alpha=0.8;

    _nameLabel.frame=CGRectMake(0, 0, 170, 30);
    if (_picArray.count) {
        _nameLabel.text=((MenuListModel *)[_picArray objectAtIndex:0]).name;
    }
    
    _pageControl.frame=CGRectMake(170, 0, 225, 30);
    _pageControl.currentPage=0;
    _pageControl.numberOfPages=5;
    _pageControl.pageIndicatorTintColor=[UIColor lightGrayColor];
    _pageControl.currentPageIndicatorTintColor=[UIColor orangeColor];
    
}

#pragma mark ----UIScrollViewDelegate----
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger index=_scrollView.contentOffset.x/self.frame.size.width;
    _nameLabel.text=((MenuListModel *)self.picArray[index]).name;
    _pageControl.currentPage=index;
}

- (void)tapGesture:(UITapGestureRecognizer *)tap
{

    MenuListModel *model=_picArray[tap.view.tag];
    self.transBlock(model);

    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
