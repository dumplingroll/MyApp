//
//  MenuCateCellTableViewCell.m
//  食趣
//
//  Created by 汤汤 on 15/10/20.
//  Copyright © 2015年 汤汤. All rights reserved.
//

#import "MenuCateCellTableViewCell.h"
#import "UIKit+AFNetworking.h"
#import "NetInterface.h"
#import "MenuModel.h"
@implementation MenuCateCellTableViewCell
{
    NSArray *_tempArray;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _scrollView=[[UIScrollView alloc]init];
        [self.contentView addSubview:_scrollView];
        _pageControl=[[UIPageControl alloc]init];
        [self.contentView addSubview:_pageControl];
        _pageControl.currentPage = 0;
    }
    return self;
}


- (void)setMenuCateArray:(NSArray *)array
{
//    if (_scrollView.subviews) {
//        for (UIView *view in _scrollView.subviews) {
//            [view removeFromSuperview];
//        }
//    }
    static int i = 0;
    if (i==1) {
        return;
    }
    _scrollView.frame=CGRectMake(0, 0, WIDTH, 210);
    
    for (NSInteger i=0; i<3; i++)
    {
        
        
        UIView * bgView=[[UIView alloc]init];
        bgView.frame=CGRectMake(WIDTH*i, 0, WIDTH, _scrollView.frame.size.height);
        bgView.backgroundColor=[UIColor whiteColor];
        bgView.alpha=0.8;
        //zxm5169@126.com Zhangios1515
        CGFloat aWidth = (WIDTH-10*5)/5;
        CGFloat aHidth =(_scrollView.frame.size.height-20)/2;
        NSArray *nameArray=@[@"美容",@"减肥",@"保健养生",@"人群",@"时节",@"餐时",@"器官",@"调养",@"肠胃消化",@"孕产哺乳",@"其他",@"经期",@"女性疾病",@"呼吸道",@"血管",@"心脏",@"肝胆脾胰",@"神经系统",@"口腔",@"肌肉骨骼",@"皮肤",@"男性",@"癌症"];
        for (NSInteger j=10*i;j<array.count;j++)
        {
            
            UIView *btnView=[[UIView alloc]initWithFrame:CGRectMake(10+(aWidth+8)*(j%5),8+(aHidth+8)*(j/5-2*i), aWidth, aHidth)];
           // btnView.backgroundColor=[UIColor redColor];
            btnView.userInteractionEnabled=YES;
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
            [btnView addGestureRecognizer:tap];
            btnView.tag=j;
            [bgView addSubview:btnView];
            
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(2, 2, btnView.frame.size.width-4, btnView.frame.size.height/3*2)];
            //imageView.backgroundColor=[UIColor yellowColor];
            imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"cate%ld",(long)(j+1)]];
            [btnView addSubview:imageView];
            
            UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(2, btnView.frame.size.height/3*2+3, btnView.frame.size.width-4, btnView.frame.size.height/3-4)];
            //nameLabel.backgroundColor=[UIColor grayColor];
            nameLabel.textAlignment = NSTextAlignmentCenter;
           // nameLabel.text=((MenuModel *)array[j]).name;
            nameLabel.text=nameArray[j];
            nameLabel.font = [UIFont systemFontOfSize:12];
            [btnView addSubview:nameLabel];
            
        }
        
        
        [_scrollView addSubview:bgView];
        _tempArray=array;
    }

    
    _scrollView.contentSize=CGSizeMake(375*3, 0);
    _scrollView.pagingEnabled=YES;
    _scrollView.delegate=self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    
    _pageControl.frame=CGRectMake(50, 196, self.frame.size.width-100, 10);
    _pageControl.currentPage=0;
    _pageControl.numberOfPages=3;
    _pageControl.pageIndicatorTintColor=[UIColor lightGrayColor];
    _pageControl.currentPageIndicatorTintColor=[UIColor colorWithRed:244.0/255.0 green:152.0/255.0 blue:156.0/255.0 alpha:1];
    
    i=1;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x/self.frame.size.width;
    _pageControl.currentPage =index;
    
}

- (void)tapGesture:(UITapGestureRecognizer *)tap
{
    MenuModel *model=_tempArray[tap.view.tag];
    self.cateBlock(model.myId,model.name);
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
