//
//  WebViewController.m
//  食趣
//
//  Created by 汤汤 on 15/10/27.
//  Copyright © 2015年 汤汤. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"友情链接"];
    [self addButtonWithText:nil andImage:@"back" andSelector:@selector(backClick) andLocation:YES];
    NSURL *url=[NSURL URLWithString:@"http://www.douguo.com"];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    UIWebView *webView=[[UIWebView alloc]initWithFrame:self.view.bounds];
    [webView loadRequest:request];
    [self.view addSubview:webView];
}


- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
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
