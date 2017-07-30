//
//  HealthySearchViewController.m
//  食趣
//
//  Created by 汤汤 on 15/10/25.
//  Copyright © 2015年 汤汤. All rights reserved.
//

#import "HealthySearchViewController.h"
#import "NSString+URL.h"

#import "UIImageView+WebCache.h"
#import "HealthyDetailModel.h"
#import "NetInterface.h"
#import "MyAFNetWorkHttpRequest.h"
#import "UIImageView+AFNetworking.h"
#import "DGActivityIndicatorView.h"

@interface HealthySearchViewController ()<UIWebViewDelegate>
{
    MyAFNetWorkHttpRequest *_request;
    UIScrollView *_scrollView;
    UILabel *_nameLabel;
    UIImageView *_imgView;
    UILabel *_desLabel;
    UIWebView *_messageView;
    UILabel *_foodLabel;
    HealthyDetailModel *_currentModel;
    
}
@end

@implementation HealthySearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitleView:@"他和她的详细资料"];
    [self addButtonWithText:nil andImage:@"back" andSelector:@selector(btnClicked) andLocation:YES];
    [self addButtonWithText:nil andImage:@"collection" andSelector:nil andLocation:NO];
    [self createUI];
    [self downloadData];
    
}

- (void)btnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createUI
{
    self.view.backgroundColor=[UIColor whiteColor];
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 50, WIDTH, HEIGHT-50)];
    [self.view addSubview:_scrollView];
    
}


- (void)downloadData
{
    
    NSString *nameStr = [_name URLEncodeString];
    NSString *url=[NSString stringWithFormat:SEARCH_URL,nameStr];
    _request=[[MyAFNetWorkHttpRequest alloc]initWithRequest:url block:^(NSData *responseData)
              {
                  HealthyDetailModel *detailModel=[[HealthyDetailModel alloc]initWithData:responseData error:nil];
//                  NSLog(@"%@",detailModel.name);
                  _currentModel=detailModel;
                  if (_currentModel.name.length ==0) {
                      [self createAler];
                  }
                  [self createDetailUI];
              }];
    
}
- (void)createAler
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您输入的名字没有搜索到 请重新搜索" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertView show];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createDetailUI
{
    CGFloat nameY=[self createName:0];
    CGFloat foodY=[self createFood:nameY+10];
    CGFloat imgY=[self createImage:foodY+5];
    CGFloat descY=[self createDesc:imgY+5];
    CGFloat messageY=[self createMessage:descY];
    _scrollView.contentSize=CGSizeMake(WIDTH, messageY);
}

- (CGFloat)createName:(CGFloat)startY
{
    _nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, startY, WIDTH, 20)];
    _nameLabel.font=[UIFont systemFontOfSize:18];
    _nameLabel.text=_currentModel.name;
    _nameLabel.textAlignment=NSTextAlignmentCenter;
    [_scrollView addSubview:_nameLabel];
    return startY+20;
}

- (CGFloat)createFood:(CGFloat)startY
{
    if (_currentModel.food.length)
    {
        _foodLabel=[[UILabel alloc]init];
        _foodLabel.numberOfLines=0;
        _foodLabel.font=[UIFont boldSystemFontOfSize:14];
        _foodLabel.text=[NSString stringWithFormat:@"相关食物:%@",_currentModel.food];
        CGSize size=[self heightOfLable:_currentModel.food sizeOfWidth:WIDTH-20 font:14];
        _foodLabel.frame=CGRectMake(10, startY, WIDTH-20, size.height);
        [_scrollView addSubview:_foodLabel];
        return size.height+startY;
    }else
    {
        return startY;
    }
}

- (CGFloat)createImage:(CGFloat)startY
{
    NSString *imgUrl=[NSString stringWithFormat:@"http://tnfs.tngou.net/image%@",_currentModel.img];
    NSLog(@"img%@",imgUrl);
    //UIImage *cacheImage=[[SDImageCache sharedImageCache]imageFromDiskCacheForKey:imgUrl];
    //_imgView=[[UIImageView alloc]initWithImage:cacheImage];
    [_imgView setImageWithURL:[NSURL URLWithString:imgUrl]];
    _imgView.frame = CGRectMake(10, startY, 100,150);
    [_scrollView addSubview:_imgView];
    return startY+150;
}

-(CGFloat)createDesc:(CGFloat)startY
{
    if(_currentModel.description.length)
    {
        _desLabel = [[UILabel alloc]init];
        _desLabel.numberOfLines = 0;
        _desLabel.font = [UIFont systemFontOfSize:14];
        _desLabel.text = _currentModel.myDescription;
        CGSize size = [self heightOfLable:_currentModel.myDescription sizeOfWidth:WIDTH-20 font:14];
        _desLabel.frame = CGRectMake(10, startY, WIDTH-20, size.height);
        [_scrollView addSubview:_desLabel];
        return size.height+startY;
    }
    else
    {
        return startY;
    }
    
}

- (CGFloat)createMessage:(CGFloat)startY
{
    _messageView=[[UIWebView alloc]initWithFrame:CGRectMake(5, startY, WIDTH-10, 500)];
    
    NSURL *url=[NSURL fileURLWithPath:[[NSBundle mainBundle]bundlePath]];
    _messageView.delegate=self;
    //此方法可去除网页上的各种符号
    [_messageView loadHTMLString:_currentModel.message baseURL:url];
    [_scrollView addSubview:_messageView];
    return startY;
    
}
/**
 *  自定义高度
 *
 *  @param text     传入的text
 *  @param width    宽度
 *  @param fontSize 文字的大小尺寸
 *
 *  @return 返回的尺寸
 */
-(CGSize)heightOfLable:(NSString *)text sizeOfWidth:(CGFloat)width font:(int)fontSize
{
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    NSDictionary *dict = @{NSFontAttributeName:font};
    CGSize size = [text boundingRectWithSize:CGSizeMake(width, 9000) options:(NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin) attributes:dict context:nil].size;
    return size;
}

#pragma mark ---UIWebViewDelegate---
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGFloat height=[[webView stringByEvaluatingJavaScriptFromString:@"document.height"] floatValue];
    webView.frame=CGRectMake(webView.frame.origin.x, webView.frame.origin.y, webView.frame.size.width, height);
    _scrollView.contentSize=CGSizeMake(WIDTH, _scrollView.contentSize.height+height);
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
