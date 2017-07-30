//
//  TabBarViewController.m
//  食趣
//
//  Created by 汤汤 on 15/10/18.
//  Copyright © 2015年 汤汤. All rights reserved.
//

#import "TabBarViewController.h"
#import "RootViewController.h"
@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTabBarView];
     self.view.backgroundColor=[UIColor whiteColor];
}


- (void)createTabBarView
{
    
    NSArray *classes=@[@"MenuViewController",@"HealthyViewController",@"SexualViewController",@"SettingViewController"];
    NSArray *names=@[@"食为天",@"健康",@"他和她",@"我的"];
    NSArray *images=@[@"tabBar_part1@2x",@"tabBar_part2@2x",@"tabBar_part3@2x",@"tabBar_part4@2x"];
    NSArray *selectImages=@[@"tabBar_part1S@2x",@"tabBar_part2S@2x",@"tabBar_part3S@2x",@"tabBar_part4S@2x"];
    NSMutableArray *viewControllers=[[NSMutableArray alloc]init];
    
    for (NSInteger i=0; i<names.count; i++)
    {
        Class class=NSClassFromString(classes[i]);
        RootViewController *root=[[class alloc]init];
        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:root];
        UIImage *imageSelect=[UIImage imageNamed:selectImages[i]];
        imageSelect=[imageSelect imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UITabBarItem *item=[[UITabBarItem alloc]initWithTitle:names[i] image:[[UIImage imageNamed:images[i]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:imageSelect];
        [self.tabBar setTintColor:[UIColor colorWithRed:242.0/255.0 green:147/255.0 blue:153.0/255.0 alpha:1]];
//        [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                      [UIColor orangeColor], UITextAttributeTextColor, nil]
//                            forState:UIControlStateNormal];
        nav.tabBarItem=item;
        [viewControllers addObject:nav];
    }
//    UIView *bgView = [[UIView alloc] initWithFrame:self.tabBar.bounds];
//    bgView.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:152.0/255.0 blue:156.0/255.0 alpha:1];
//    [self.tabBar insertSubview:bgView atIndex:0];
//    self.tabBar.opaque = YES;
    self.viewControllers=viewControllers;
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
