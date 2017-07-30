//
//  SexualDetailController.m
//  食趣
//
//  Created by 汤汤 on 15/10/22.
//  Copyright © 2015年 汤汤. All rights reserved.
//

#import "SexualDetailController.h"
#import "UIImageView+WebCache.h"
#import "HealthyDetailModel.h"
#import "NetInterface.h"
#import "MyAFNetWorkHttpRequest.h"
#import "UIImageView+AFNetworking.h"
#import "DBManager.h"
#import "CustomCButton.h"
#import "DGActivityIndicatorView.h"
@interface SexualDetailController ()<UIWebViewDelegate>
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
@property (nonatomic,strong)HealthyDetailModel *detailModel;
@end

@implementation SexualDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitleView:@"他和她的详细资料"];
    [self buildCollectBtn];
    [self addButtonWithText:nil andImage:@"back" andSelector:@selector(btnClicked) andLocation:YES];
   // [self addButtonWithText:nil andImage:@"collection" andSelector:nil andLocation:NO];
    
    [self createUI];
    [self downloadData];
    
}

- (void)buildCollectBtn
{
    DBManager *manager=[DBManager shareManager];
    __block BOOL isExit=[manager selectRecordWithAppId:_myId recordType:RecordTypeCollection];
    CustomCButton *btn=[CustomCButton buttonWithFrame:CGRectMake(0, 0, 35, 35) title:nil type:UIButtonTypeCustom image:@"collectionS" action:^(CustomCButton *btn)
    {
        if (isExit)
        {
            [manager deleteRecordWithAppId:_myId recordType:RecordTypeCollection];
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"取消收藏成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [self.view addSubview:alertView];
            [alertView show];
            NSLog(@"取消收藏");
        }else
        {
            [manager addRecordWithAppModel:_currentModel recordType:RecordTypeCollection];
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"收藏成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [self.view addSubview:alertView];
            [alertView show];
            NSLog(@"添加收藏");
        }
        isExit=!isExit;
    }];
    UIBarButtonItem *btnItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem=btnItem;
}
- (void)btnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createUI
{
    self.view.backgroundColor=[UIColor whiteColor];
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 20, WIDTH, HEIGHT-20)];
    _scrollView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_scrollView];
    
}

- (void)downloadData
{
    DGActivityIndicatorView *activityIndicatorView=[[DGActivityIndicatorView alloc]initWithType:DGActivityIndicatorAnimationTypeTriplePulse tintColor:[UIColor colorWithRed:244.0/255.0 green:152.0/255.0 blue:156.0/255.0 alpha:1] size:[@(35.0f) floatValue]];
    CGFloat width=(WIDTH-200)/2.0f;
    CGFloat height=(HEIGHT-200)/2.0f;
    activityIndicatorView.frame=CGRectMake(width, height, 200, 200);
    [self.view addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];

    NSString *url=[NSString stringWithFormat:FOOD_DETAIL_URL,_myId];
    _request=[[MyAFNetWorkHttpRequest alloc]initWithRequest:url block:^(NSData *responseData)
    {
        HealthyDetailModel *detailModel=[[HealthyDetailModel alloc]initWithData:responseData error:nil];
        _currentModel=detailModel;
        [self createDetailUI];
        [activityIndicatorView stopAnimating];
    }];
    
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
    _nameLabel.font=[UIFont fontWithName:@"AmericanTypewriter-Bold" size:25];
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
//    NSString *imgUrl=[NSString stringWithFormat:@"http://tnfs.tngou.net/image%@",_currentModel.img];
//    NSLog(@"%@",imgUrl);
    //UIImage *cacheImage=[[SDImageCache sharedImageCache]imageFromDiskCacheForKey:imgUrl];
    //_imgView=[[UIImageView alloc]initWithImage:cacheImage];
   // _imgView.frame = CGRectMake((WIDTH-cacheImage.size.width)/2, startY, cacheImage.size.width, cacheImage.size.height);
    _imgView=[[UIImageView alloc]init];
    [_imgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://tnfs.tngou.net/image%@",_currentModel.img]]];

    NSLog(@"%@",_currentModel.img);
    _imgView.frame=CGRectMake(10, startY, WIDTH-20, 200);
    [_scrollView addSubview:_imgView];
    return startY+200;
}

-(CGFloat)createDesc:(CGFloat)startY
{
    if(_currentModel.myDescription.length)
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
