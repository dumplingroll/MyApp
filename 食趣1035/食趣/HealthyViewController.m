//
//  HealthyViewController.m
//  食趣
//
//  Created by 汤汤 on 15/10/21.
//  Copyright © 2015年 汤汤. All rights reserved.
//

#import "HealthyViewController.h"
#import "NetInterface.h"
#import "CustomButton.h"
#import "UIKit+AFNetworking.h"
#import "MyAFNetWorkHttpRequest.h"
#import "SimpleHealthModel.h"
#import "HealthyListViewController.h"
#import "SexualDetailController.h"
#import "AddsTimer.h"
#import "HealthItemView.h"
#import "HealthySearchViewController.h"
#import "DGActivityIndicatorView.h"
#import "WebViewController.h"
#import "UIImageView+WebCache.h"

@interface HealthyViewController ()<UISearchBarDelegate,UIScrollViewDelegate>
{
    MyAFNetWorkHttpRequest *_request1;
    MyAFNetWorkHttpRequest *_request2;
    MyAFNetWorkHttpRequest *_request3;
    MyAFNetWorkHttpRequest *_request4;
    DGActivityIndicatorView *_activityView;
    UISearchBar *_searchBar;
    UIScrollView *_scrollView;
    NSMutableArray *_dataList;
    UIPageControl *_pageControl;
    NSInteger _currentIndex;
    NSMutableArray *_fitDataList;
    NSMutableArray *_breathDataList;
    NSMutableArray *_beautyDataList;
    NSMutableArray *_organDataList;
    NSString *_urlString;
    UIScrollView *_addsView;
    BOOL _isRight;//自动滑动是否向右
}


@property (nonatomic,retain) SimpleHealthModel *model;

@end

@implementation HealthyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self downloadData:[NSString stringWithFormat:FIT_LIST_URL,(long)1] withType:1];
    [self downloadData:[NSString stringWithFormat:BREATH_LIST_URL,(long)1] withType:2];
    [self downloadData:[NSString stringWithFormat:BEAUTY_LIST_URL,(long)1] withType:3];
    [self downloadData:[NSString stringWithFormat:ORGAN_LIST_URL,(long)1] withType:4];
    [self showAdds];
    
    
}


- (void)createUI
{
    //搜索框
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, WIDTH-20, 44)];
    _searchBar.delegate = self;
    _searchBar.showsCancelButton = YES;
    _searchBar.placeholder=@"请输入食物的名字";
    self.navigationItem.titleView = _searchBar;
    _searchBar.keyboardType=UIKeyboardTypeDefault;
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64-49)];
    [self.view addSubview:_scrollView];

    //0.图片轮转模块
    CGFloat picY=[self createPicScrollView:220];
    //1.养生保健模块
    CGFloat fitY=[self createKeepFitView:picY];
    //2.呼吸道模块
    CGFloat breathY=[self createBreathBiew:fitY];
    //3.美容减肥
    CGFloat beautyY=[self createBeautyView:breathY];
    //4.肝胆相照
    CGFloat organY=[self createOrganView:beautyY];
    _scrollView.contentSize = CGSizeMake(WIDTH, organY);
    [_activityView stopAnimating];
    _activityView.hidden=YES;
}

- (CGFloat)createPicScrollView:(CGFloat)startY
{
    //美食图片轮转
   
    _addsView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, startY)];
    [_scrollView addSubview:_addsView];
    for (NSInteger i=0; i<5; i++)
    {
         NSString *path=[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"img%ld",i+1] ofType:@"jpg"];
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(WIDTH*i, 0, WIDTH, startY)];
        imageView.image=[UIImage imageWithContentsOfFile:path];
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScrollGesture:)];
        imageView.userInteractionEnabled=YES;
        [imageView addGestureRecognizer:tap];
        [_addsView addSubview:imageView];
    }
    _addsView.contentSize=CGSizeMake(WIDTH*5, 200)
    ;
    _addsView.pagingEnabled=YES;
    _addsView.showsHorizontalScrollIndicator=NO;
    _addsView.delegate=self;
    
//    _pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0, 190, WIDTH, 10)];
//    _pageControl.backgroundColor=[UIColor blackColor];
//    _pageControl.numberOfPages=5;
//    [_scrollView addSubview:_pageControl];
//    _currentIndex=0;
//    _pageControl.currentPage=_currentIndex;
    return startY;

}

-(void)showAdds
{
    _isRight = YES;
    
    [[AddsTimer timerManager]addAnimation:^{
        [UIView animateWithDuration:0.5 animations:^{
            if (_addsView.contentOffset.x == WIDTH*0) {
                _addsView.contentOffset = CGPointMake(WIDTH, 0);
            }
            else if (_addsView.contentOffset.x == WIDTH)
            {
                if (_isRight == YES) {
                    _addsView.contentOffset = CGPointMake(WIDTH*2, 0);
                    _isRight = NO;
                }
                else
                {
                    _addsView.contentOffset = CGPointMake(WIDTH*0, 0);
                    _isRight = YES;
                }
            }
            else if (_addsView.contentOffset.x == WIDTH*2)
            {
                _isRight = NO;
                _addsView.contentOffset = CGPointMake(WIDTH*1, 0);
            }
        }];
    }];
    
}


- (CGFloat)createKeepFitView:(CGFloat)startY
{
   // HealthItemView *fitV = [HealthItemView itemView];
    
    
    
    UIView *fitView=[[UIView alloc]initWithFrame:CGRectMake(0, startY, WIDTH, 240+120)];
    [_scrollView addSubview:fitView];
    fitView.backgroundColor=[UIColor colorWithRed:231.0/255.0 green:225.0/255.0 blue:217.0/255 alpha:0.8];
    UILabel *decoLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 3, 20)];
    decoLabel.backgroundColor=[UIColor colorWithRed:244.0/255.0 green:152.0/255.0 blue:156.0/255.0 alpha:1];
    [fitView addSubview:decoLabel];
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 5, (WIDTH-20)/3*2, 20)];
    titleLabel.text=@"养生保健";
    titleLabel.textColor=[UIColor brownColor];
    [fitView addSubview:titleLabel];
    UIButton *moreButton=[UIButton buttonWithType:UIButtonTypeSystem];
    moreButton.frame=CGRectMake(10+(WIDTH-20)/3*2+20, 5, (WIDTH-20)/3, 20);
    [moreButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [moreButton setTitle:@"MORE>>>" forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(fitClicked:) forControlEvents:UIControlEventTouchUpInside];
    moreButton.tag=100;
    [fitView addSubview:moreButton];
    
    CGFloat btnWidth=(WIDTH-30)/2;
    for (NSInteger i=0; i<2; i++)
    {
        for (NSInteger j=0; j<2; j++)
        {
            CustomButton *btn = [[CustomButton alloc]initWithFrame:CGRectMake(10+(btnWidth+10)*j,30+170*i,btnWidth,160)];
            btn.backgroundColor=[UIColor whiteColor];
            
            if (_fitDataList.count) {
                [btn setTitle:((HealthyListModel *)_fitDataList[2*j+i]).name forState:(UIControlStateNormal)];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                btn.titleLabel.font=[UIFont boldSystemFontOfSize:16];
//                [btn setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://tnfs.tngou.net/image%@",((HealthyListModel *)_fitDataList[2*j+i]).img]] placeholderImage:nil];
                [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"sec1.%ld.jpg",(long)(2*j+i+1)]] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
                btn.tag=100+2*j+i;
                
            }
            
            [fitView addSubview:btn];

        }
    }
    return startY+360;
}

- (CGFloat)createBreathBiew:(CGFloat)startY
{
    UIView *fitView=[[UIView alloc]initWithFrame:CGRectMake(0, startY, WIDTH, 240+120)];
    [_scrollView addSubview:fitView];
    fitView.backgroundColor=[UIColor colorWithRed:231.0/255.0 green:225.0/255.0 blue:217.0/255 alpha:0.8];
    UILabel *decoLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 3, 20)];
    decoLabel.backgroundColor=[UIColor colorWithRed:244.0/255.0 green:152.0/255.0 blue:156.0/255.0 alpha:1];
    [fitView addSubview:decoLabel];
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 5, (WIDTH-20)/3*2, 20)];
    titleLabel.text=@"爱呼吸";
    titleLabel.textColor=[UIColor brownColor];
    [fitView addSubview:titleLabel];
    UIButton *moreButton=[UIButton buttonWithType:UIButtonTypeSystem];
    moreButton.frame=CGRectMake(10+(WIDTH-20)/3*2+20, 5, (WIDTH-20)/3, 20);
    [moreButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [moreButton setTitle:@"MORE>>>" forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(fitClicked:) forControlEvents:UIControlEventTouchUpInside];
    moreButton.tag=200;
    [fitView addSubview:moreButton];
    
    CGFloat btnWidth=(WIDTH-30)/2;
    for (NSInteger i=0; i<2; i++)
    {
        for (NSInteger j=0; j<2; j++)
        {
            CustomButton *btn = [[CustomButton alloc]initWithFrame:CGRectMake(10+(btnWidth+10)*j,30+170*i,btnWidth,160)];
            btn.backgroundColor=[UIColor whiteColor];
            
            if (_breathDataList.count) {
                [btn setTitle:((HealthyListModel *)_breathDataList[2*j+i]).name forState:(UIControlStateNormal)];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                btn.titleLabel.font=[UIFont boldSystemFontOfSize:16];
                [btn setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://tnfs.tngou.net/image%@",((HealthyListModel *)_breathDataList[2*j+i]).img]] placeholderImage:[UIImage imageNamed:@"temp"]];
                [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
                btn.tag=200+2*j+i;

                
            }
            [fitView addSubview:btn];
        }
    }
    return startY+360;


}


- (CGFloat)createBeautyView:(CGFloat)startY
{
    UIView *fitView=[[UIView alloc]initWithFrame:CGRectMake(0, startY, WIDTH, 240+120)];
    [_scrollView addSubview:fitView];
    fitView.backgroundColor=[UIColor colorWithRed:231.0/255.0 green:225.0/255.0 blue:217.0/255 alpha:0.8];
    UILabel *decoLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 3, 20)];
    decoLabel.backgroundColor=[UIColor colorWithRed:244.0/255.0 green:152.0/255.0 blue:156.0/255.0 alpha:1];
    [fitView addSubview:decoLabel];
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 5, (WIDTH-20)/3*2, 20)];
    titleLabel.text=@"美容瘦身";
    titleLabel.textColor=[UIColor brownColor];
    [fitView addSubview:titleLabel];
    UIButton *moreButton=[UIButton buttonWithType:UIButtonTypeSystem];
    moreButton.frame=CGRectMake(10+(WIDTH-20)/3*2+20, 5, (WIDTH-20)/3, 20);
    [moreButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [moreButton setTitle:@"MORE>>>" forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(fitClicked:) forControlEvents:UIControlEventTouchUpInside];
    moreButton.tag=300;
    [fitView addSubview:moreButton];
    
    CGFloat btnWidth=(WIDTH-30)/2;
    for (NSInteger i=0; i<2; i++)
    {
        for (NSInteger j=0; j<2; j++)
        {
            CustomButton *btn = [[CustomButton alloc]initWithFrame:CGRectMake(10+(btnWidth+10)*j,30+170*i,btnWidth,160)];
            btn.backgroundColor=[UIColor whiteColor];
            if (_beautyDataList.count) {
                [btn setTitle:((HealthyListModel *)_beautyDataList[2*j+i]).name forState:(UIControlStateNormal)];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                btn.titleLabel.font=[UIFont boldSystemFontOfSize:16];
                [btn setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://tnfs.tngou.net/image%@",((HealthyListModel *)_beautyDataList[2*j+i]).img]] placeholderImage:nil];
                [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
                btn.tag=300+2*j+i;

                
            }
            [fitView addSubview:btn];
            
        }
    }
    return startY+360;

}

- (CGFloat)createOrganView:(CGFloat)startY
{
    UIView *fitView=[[UIView alloc]initWithFrame:CGRectMake(0, startY, WIDTH, 240+120)];
    [_scrollView addSubview:fitView];
    fitView.backgroundColor=[UIColor colorWithRed:231.0/255.0 green:225.0/255.0 blue:217.0/255 alpha:0.8];
    UILabel *decoLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 3, 20)];
    decoLabel.backgroundColor=[UIColor colorWithRed:244.0/255.0 green:152.0/255.0 blue:156.0/255.0 alpha:1];
    [fitView addSubview:decoLabel];
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 5, (WIDTH-20)/3*2, 20)];
    titleLabel.text=@"肝胆相照";
    titleLabel.textColor=[UIColor brownColor];
    [fitView addSubview:titleLabel];
    UIButton *moreButton=[UIButton buttonWithType:UIButtonTypeSystem];
    moreButton.frame=CGRectMake(10+(WIDTH-20)/3*2+20, 5, (WIDTH-20)/3, 20);
    [moreButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [moreButton setTitle:@"MORE>>>" forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(fitClicked:) forControlEvents:UIControlEventTouchUpInside];
    moreButton.tag=400;
    [fitView addSubview:moreButton];
    
    CGFloat btnWidth=(WIDTH-30)/2;
    for (NSInteger i=0; i<2; i++)
    {
        for (NSInteger j=0; j<2; j++)
        {
            CustomButton *btn = [[CustomButton alloc]initWithFrame:CGRectMake(10+(btnWidth+10)*j,30+170*i,btnWidth,160)];
            btn.backgroundColor=[UIColor whiteColor];
            if (_organDataList.count) {
                [btn setTitle:((HealthyListModel *)_organDataList[2*j+i]).name forState:(UIControlStateNormal)];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                btn.titleLabel.font=[UIFont boldSystemFontOfSize:16];
                [btn setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://tnfs.tngou.net/image%@",((HealthyListModel *)_organDataList[2*j+i]).img]] placeholderImage:nil];
                [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
                btn.tag=400+2*j+i;

            }
            [fitView addSubview:btn];
            
        }
    }
    return startY+360;

}

- (void)downloadData:(NSString *)urlString withType:(NSInteger)type
{
    _activityView=[[DGActivityIndicatorView alloc]initWithType:DGActivityIndicatorAnimationTypeTriplePulse tintColor:[UIColor colorWithRed:244.0/255.0 green:152.0/255.0 blue:156.0/255.0 alpha:1] size:[@(35.0f) floatValue]];
    CGFloat width=(WIDTH-200)/2.0f;
    CGFloat height=(HEIGHT-200)/2.0f;
    _activityView.frame=CGRectMake(width, height, 200, 200);
    [self.view addSubview:_activityView];
    [_activityView startAnimating];
    
    if (type==1)
    {
         _fitDataList=[NSMutableArray array];
        _request1=[[MyAFNetWorkHttpRequest alloc]initWithRequest:urlString block:^(NSData *responseData)
                  {
                      SimpleHealthModel *model1 = [[SimpleHealthModel alloc] initWithData:responseData error:nil];
                      [_fitDataList addObjectsFromArray:model1.tngou];
                      
                      
                  }];

    }else if (type==2)
    {
        _breathDataList=[NSMutableArray array];
        _request2=[[MyAFNetWorkHttpRequest alloc]initWithRequest:urlString block:^(NSData *responseData)
                  {
                      SimpleHealthModel *model2 = [[SimpleHealthModel alloc] initWithData:responseData error:nil];
                      [_breathDataList addObjectsFromArray:model2.tngou];
                      
                      
                  }];

    }else if (type==3)
    {
        _beautyDataList=[NSMutableArray array];
        _request3=[[MyAFNetWorkHttpRequest alloc]initWithRequest:urlString block:^(NSData *responseData)
                  {
                      SimpleHealthModel *model3 = [[SimpleHealthModel alloc] initWithData:responseData error:nil];
                      [_beautyDataList addObjectsFromArray:model3.tngou];
                      
                      
                  }];

    }else if (type==4)
    {
        _organDataList=[NSMutableArray array];
        _request4=[[MyAFNetWorkHttpRequest alloc]initWithRequest:urlString block:^(NSData *responseData)
                  {
                      SimpleHealthModel *model4 = [[SimpleHealthModel alloc] initWithData:responseData error:nil];
                      [_organDataList addObjectsFromArray:model4.tngou];
                      
                      [self createUI];
                      
                  }];
    }
    
   
}

- (void)btnClicked:(UIButton *)btn
{
    if (btn.tag>=100&&btn.tag<=104)
    {
        SexualDetailController *sdc=[[SexualDetailController alloc]init];
        sdc.myId=((HealthyListModel *)_fitDataList[btn.tag-100]).myId;
        [self.navigationController pushViewController:sdc animated:YES];
    }else if (btn.tag>=200&&btn.tag<=204)
    {
        SexualDetailController *sdc=[[SexualDetailController alloc]init];
        sdc.myId=((HealthyListModel *)_breathDataList[btn.tag-200]).myId;
        [self.navigationController pushViewController:sdc animated:YES];
    }else if (btn.tag>=300&&btn.tag<=304)
    {
        SexualDetailController *sdc=[[SexualDetailController alloc]init];
        sdc.myId=((HealthyListModel *)_beautyDataList[btn.tag-300]).myId;
        [self.navigationController pushViewController:sdc animated:YES];
    }else if (btn.tag>=400&&btn.tag<=404)
    {
        SexualDetailController *sdc=[[SexualDetailController alloc]init];
        sdc.myId=((HealthyListModel *)_organDataList[btn.tag-400]).myId;
        [self.navigationController pushViewController:sdc animated:YES];
    }
}
- (void)fitClicked:(UIButton *)btn
{
    if (btn.tag==100)
    {
        _urlString=FIT_LIST_URL;
        NSLog(@"%ld",btn.tag);
    }else if (btn.tag==200)
    {
        _urlString=BREATH_LIST_URL;
        NSLog(@"%ld",btn.tag);
    }else if (btn.tag==300)
    {
        _urlString=BEAUTY_LIST_URL;
    }else if (btn.tag==400)
    {
        _urlString=ORGAN_LIST_URL;
    }
    HealthyListViewController *hlvc=[[HealthyListViewController alloc]init];
    hlvc.urlString=_urlString;
    [self.navigationController pushViewController:hlvc animated:YES];
}
#pragma mark ---UIScrollViewDelegate---
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _currentIndex=scrollView.contentOffset.x/WIDTH;
    _pageControl.currentPage=_currentIndex;
}


#pragma ----Timer----
-(void)viewDidAppear:(BOOL)animated
{
    [[[AddsTimer timerManager] timer] setFireDate:[NSDate distantPast]];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [[[AddsTimer timerManager] timer] setFireDate:[NSDate distantFuture]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---searchBarDelegate---
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.text.length == 0) {
        return;
    }
    [searchBar resignFirstResponder];
    HealthySearchViewController *hvc = [[HealthySearchViewController alloc]init];
    hvc.name = searchBar.text;
    [self.navigationController pushViewController:hvc animated:YES];

}

- (void)tapScrollGesture:(UITapGestureRecognizer *)tap
{
    WebViewController *wvc=[[WebViewController alloc]init];
    [self.navigationController pushViewController:wvc animated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
