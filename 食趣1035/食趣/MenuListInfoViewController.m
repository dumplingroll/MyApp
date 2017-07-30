//
//  MenuListInfoViewController.m
//  食趣
//
//  Created by 汤汤 on 15/10/20.
//  Copyright © 2015年 汤汤. All rights reserved.
//

#import "MenuListInfoViewController.h"
#import "UIKit+AFNetworking.h"
#import "NetInterface.h"

@interface MenuListInfoViewController ()
{
    UIScrollView *_scrollView;
}
@end

@implementation MenuListInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"详情"];
    [self addButtonWithText:nil andImage:@"back" andSelector:@selector(btnClicked) andLocation:YES];
    [self addButtonWithText:nil andImage:@"collection" andSelector:nil andLocation:NO];
    [self createDetailView];
}


- (void)btnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createDetailView
{
    
    self.view.backgroundColor=[UIColor whiteColor];
    _scrollView=[[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    CGFloat nameY=[self createNameLabel:20];
    CGFloat imageY=[self createImageView:nameY+10];
    CGFloat foodY=[self createFoodLabel:imageY+10];
    CGFloat desY=[self createDesLabel:foodY+15];
    CGFloat keywordY=[self createKeywordLabel:desY+15];
    _scrollView.contentSize=CGSizeMake(WIDTH, keywordY);
    
}
- (CGFloat)createNameLabel:(CGFloat)startY
{
    CGSize size=[self heightOfLable:_model.name sizeOfWidth:WIDTH-20 font:18];
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, startY, WIDTH-20, size.height)];
    nameLabel.text=_model.name;
    [_scrollView addSubview:nameLabel];
    return startY+size.height;
}

- (CGFloat)createImageView:(CGFloat)startY
{
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, startY, WIDTH-20, 200)];
    [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://tnfs.tngou.net/image%@",_model.img]] placeholderImage:nil];
    [_scrollView addSubview:imageView];
    return startY+200;
}

- (CGFloat)createFoodLabel:(CGFloat)startY
{
    UILabel *foodLabel=[[UILabel alloc]init];
    foodLabel.numberOfLines=0;
    foodLabel.font=[UIFont systemFontOfSize:14];
    foodLabel.text=[NSString stringWithFormat:@"主要原料:%@",_model.food];
    CGSize size=[self heightOfLable:_model.food sizeOfWidth:WIDTH-20 font:14];
    foodLabel.frame=CGRectMake(10, startY, WIDTH-20, size.height);
    [_scrollView addSubview:foodLabel];
    return startY+size.height;

}

- (CGFloat)createDesLabel:(CGFloat)startY
{
    
    UILabel *desLabel=[[UILabel alloc]init];
    desLabel.numberOfLines=0;
    desLabel.font=[UIFont boldSystemFontOfSize:14];
    desLabel.text=[NSString stringWithFormat:@"制作方法:%@",_model.myDescription];
    CGSize size=[self heightOfLable:_model.myDescription sizeOfWidth:WIDTH-20 font:14];
    desLabel.frame=CGRectMake(10, startY, WIDTH-20, size.height);
    [_scrollView addSubview:desLabel];
    return startY+size.height;
}


- (CGFloat)createKeywordLabel:(CGFloat)startY
{
    UILabel *keyWordLabel=[[UILabel alloc]init];
    keyWordLabel.numberOfLines=0;
    keyWordLabel.font=[UIFont systemFontOfSize:14];
    keyWordLabel.text=[NSString stringWithFormat:@"关键字:%@",_model.keywords];
    CGSize size=[self heightOfLable:_model.keywords sizeOfWidth:WIDTH-20 font:14];
    keyWordLabel.frame=CGRectMake(10, startY, WIDTH-20, size.height);
    [_scrollView addSubview:keyWordLabel];
    return startY+size.height;
}

-(CGSize)heightOfLable:(NSString *)text sizeOfWidth:(CGFloat)width font:(int)fontSize
{
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    NSDictionary *dict = @{NSFontAttributeName:font};
    CGSize size = [text boundingRectWithSize:CGSizeMake(width, 9000) options:(NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin) attributes:dict context:nil].size;
    return size;
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
