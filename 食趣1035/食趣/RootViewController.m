//
//  RootViewController.m
//  食趣
//
//  Created by 汤汤 on 15/10/18.
//  Copyright © 2015年 汤汤. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
}


- (void)addTitleView:(NSString *)title
{
    //每个页面的标题
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    titleLabel.text=title;
    titleLabel.textColor=[UIColor grayColor];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.font=[UIFont systemFontOfSize:20];
    self.navigationItem.titleView=titleLabel;
}

- (void)addButtonWithText:(NSString *)text andImage:(NSString *)imageName andSelector:(SEL)selector andLocation:(BOOL)isLeft
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame=CGRectMake(0, 0, 35, 35);
    [btn setTitle:text forState:UIControlStateNormal];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    UIBarButtonItem *button=[[UIBarButtonItem alloc]initWithCustomView:btn];
    if (isLeft)
    {
        self.navigationItem.leftBarButtonItem=button;
    }else
    {
        self.navigationItem.rightBarButtonItem=button;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
