//
//  HealthItemView.m
//  食趣
//
//  Created by 汤汤 on 15/10/23.
//  Copyright © 2015年 汤汤. All rights reserved.
//

#import "HealthItemView.h"
#import "NetInterface.h"
#import "CustomButton.h"

@interface HealthItemView ()
@property (nonatomic,weak)UILabel *decoLabel;

@property (nonatomic,weak)UILabel *titleLabel;

@property (nonatomic,weak)UIButton *moreButton;



@end

@implementation HealthItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        self.backgroundColor=[UIColor yellowColor];
        
        UILabel *decoLabel=[[UILabel alloc]init];
        decoLabel.backgroundColor=[UIColor orangeColor];
        [self addSubview:decoLabel];
        
        UILabel *titleLabel=[[UILabel alloc]init];

        [self addSubview:titleLabel];
        
        UIButton *moreButton=[UIButton buttonWithType:UIButtonTypeSystem];
        
        [self addSubview:moreButton];
        

        for (NSInteger i=0; i<2; i++)
        {
            for (NSInteger j=0; j<2; j++)
            {
                CustomButton *btn = [[CustomButton alloc]init];
                
                btn.tag = 100 + i*2+j;
                btn.backgroundColor=[UIColor whiteColor];

                [self addSubview:btn];
                
            }
        }
    }
    return self;
}

- (void)setListModel:(HealthyListModel *)listModel
{
    _listModel = listModel;
    self.titleLabel.text = listModel.title;
    for (NSInteger i=0; i<2; i++)
    {
        for (NSInteger j=0; j<2; j++)
        {
            
            CustomButton *btn = (CustomButton *)[self viewWithTag:100 + 2*i + j];
            
            [btn setTitle:listModel.btnTitles[i*2 +j] forState:UIControlStateNormal];
        }
    }
}

- (void)layoutSubviews
{
    self.decoLabel.frame =CGRectMake(10, 5, 3, 20);
    self.titleLabel.frame =CGRectMake(15, 5, (WIDTH-20)/3*2, 20);
    
    self.moreButton.frame =CGRectMake(10+(WIDTH-20)/3*2+25, 5, (WIDTH-20)/3, 20);
    
    CGFloat btnWidth=(WIDTH-30)/2;
    for (NSInteger i=0; i<2; i++)
    {
        for (NSInteger j=0; j<2; j++)
        {

            CustomButton *btn = (CustomButton *)[self viewWithTag:100 + 2*i + j];
            
            btn.frame =CGRectMake(10+(btnWidth+10)*j,30+165*i,btnWidth,160);
        }
    }
}

- (CGFloat)createKeepFitView:(CGFloat)startY
{
    UIView *fitView=[[UIView alloc]initWithFrame:CGRectMake(0, startY, WIDTH, 240+120)];
    [_scrollView addSubview:fitView];
    fitView.backgroundColor=[UIColor yellowColor];
    UILabel *decoLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 3, 20)];
    decoLabel.backgroundColor=[UIColor orangeColor];
    [fitView addSubview:decoLabel];
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 5, (WIDTH-20)/3*2, 20)];
    titleLabel.text=@"养生保健";
    [fitView addSubview:titleLabel];
    UIButton *moreButton=[UIButton buttonWithType:UIButtonTypeSystem];
    moreButton.frame=CGRectMake(10+(WIDTH-20)/3*2+25, 5, (WIDTH-20)/3, 20);
    [moreButton setTitle:@"MORE>>>" forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(fitClicked:) forControlEvents:UIControlEventTouchUpInside];
    moreButton.tag=100;
    [fitView addSubview:moreButton];
    
    CGFloat btnWidth=(WIDTH-30)/2;
    for (NSInteger i=0; i<2; i++)
    {
        for (NSInteger j=0; j<2; j++)
        {
            CustomButton *btn = [[CustomButton alloc]initWithFrame:CGRectMake(10+(btnWidth+10)*j,30+165*i,btnWidth,160)];
            btn.backgroundColor=[UIColor whiteColor];
            
            if (_fitDataList.count) {
                [btn setTitle:((HealthyListModel *)_fitDataList[2*j+i]).name forState:(UIControlStateNormal)];
                [btn setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://tnfs.tngou.net/image%@",((HealthyListModel *)_fitDataList[2*j+i]).img]] placeholderImage:nil];
                [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
                btn.tag=100+2*j+i;
                
            }
            
            [fitView addSubview:btn];
            
        }
    }
    return startY+360;
}


@end
