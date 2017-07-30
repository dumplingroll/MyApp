//
//  SettingViewController.m
//  食趣
//
//  Created by 汤汤 on 15/10/23.
//  Copyright © 2015年 汤汤. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingCell.h"
#import "NetInterface.h"
#import "FavouriteViewController.h"
#import "UIImageView+WebCache.h"
@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_titleArray;
    NSArray *_bgArray;
    UIScrollView *_scrollView;
}
@property (nonatomic,copy)NSString *cacheSizeStr;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"设置"];
    [self buildUI];
}

- (void)buildUI
{
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    [self.view addSubview:_scrollView];
    _scrollView.showsVerticalScrollIndicator=NO;
    UIImageView *headImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 280)];
    headImageView.image=[UIImage imageNamed:@"set1.jpg"];
    [_scrollView addSubview:headImageView];
    
    NSMutableArray *animalArray=[NSMutableArray array];
    for (NSInteger i=2; i<=5; i++)
    {
        UIImage *image=[UIImage imageNamed:[NSString stringWithFormat:@"set%ld.jpg",i]];
        [animalArray addObject:image];
    }
    headImageView.animationImages=animalArray;
    headImageView.animationDuration=15;
    [headImageView startAnimating];
    UIButton *roundBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    roundBtn.bounds=CGRectMake(0, 0, 100, 100);
    roundBtn.center=CGPointMake(WIDTH/2, 280/2);
    [roundBtn setTitle:@"食溜" forState:UIControlStateNormal];
    roundBtn.backgroundColor=[UIColor brownColor];
    roundBtn.layer.cornerRadius=50;
    roundBtn.alpha=0.5;
    roundBtn.titleLabel.font=[UIFont fontWithName:@"AmericanTypewriter-Bold" size:30];
    roundBtn.tintColor=[UIColor whiteColor];
    
    [headImageView addSubview:roundBtn];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 280, WIDTH, HEIGHT-280) style:UITableViewStyleGrouped];
    [_scrollView addSubview:_tableView];
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor colorWithRed:231.0/255.0 green:225.0/255.0 blue:217.0/255 alpha:0.8];
    _titleArray = @[@[@"夜间模式"],@[@"我的收藏",@"清除缓存"],@[@"关于食溜",@"帮助与反馈",@"五星好评"]];
    _bgArray = @[@[@"setMessage"],@[@"setCollect",@"setClean"],@[@"setAboutApp",@"setHelp",@"setCommand"]];
    
    _scrollView.contentSize=CGSizeMake(WIDTH, _tableView.frame.size.height+280);
    
}


#pragma mark --UITableView的协议方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _titleArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_titleArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingCell *cell=[tableView dequeueReusableCellWithIdentifier:@"setCell"];
    if (!cell)
    {
        cell=[[NSBundle mainBundle]loadNibNamed:@"SettingCell" owner:nil options:nil][0];
    }
    
    if (indexPath.section==0)
    {
        cell.accessoryType=UITableViewCellAccessoryNone;
        if (indexPath.row==0)
        {
            UISwitch *sw=[[UISwitch alloc]initWithFrame:CGRectMake(WIDTH/5*4, 5, 0, 0)];
            sw.onTintColor=[UIColor colorWithRed:244.0/255.0 green:152.0/255.0 blue:156.0/255.0 alpha:1];
            [sw addTarget:self action:@selector(offLight:) forControlEvents:UIControlEventValueChanged];
            [sw setOn:NO animated:YES];
            [cell.contentView addSubview:sw];
        }
    }
    cell.iconImageView.image = [UIImage imageNamed:_bgArray[indexPath.section][indexPath.row]];
    cell.nameLabel.text = _titleArray[indexPath.section][indexPath.row];
    cell.nameLabel.font=[UIFont systemFontOfSize:14];
    cell.alpha=0.5;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1)
    {
        if (indexPath.row==0)
        {
            FavouriteViewController *faVC=[[FavouriteViewController alloc]init];
            [self.navigationController pushViewController:faVC animated:YES];
        }
        if (indexPath.row==1)
        {
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"确定清除%@缓存?",[self getImageCache]] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];

            [[SDImageCache sharedImageCache]clearDiskOnCompletion:^
            {
                _cacheSizeStr=@"0";
            }];
            [self.view addSubview:alertView];
            
        }
    }
    
    if (indexPath.section==2)
    {
        if (indexPath.row==0)
        {
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"关于食溜" message:@"食溜是一款有利于人们认识到不同食物对人体作用的软件,它的存在就是为了你我他的身体健康,健康生活,天天向上!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [self.view addSubview:alertView];
            [alertView show];
        }
        if (indexPath.row==1)
        {
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"帮助与反馈" message:@"如有不足之处,请发email到993968835@qq.com,以便我们改进😊" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [self.view addSubview:alertView];
            [alertView show];
        }
        
        if (indexPath.row==2)
        {
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"五星好评" message:@"喜欢我,就去APP STORE给五星好评吧❤️" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [self.view addSubview:alertView];
            [alertView show];
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

- (void)offLight:(UISwitch *)sw
{
    if (sw.on)
    {
        self.view.window.alpha=0.6;
    }else
    {
        self.view.window.alpha=1;
    }
   
}

- (NSString *)getImageCache
{
    NSUInteger cacheSize=[[SDImageCache sharedImageCache]getSize];
    if (cacheSize<1024)
    {
        _cacheSizeStr=[NSString stringWithFormat:@"%lu B",cacheSize];
        
    }else if (cacheSize>=1024&&cacheSize<1024*1024)
    {
        _cacheSizeStr=[NSString stringWithFormat:@"%lu KB",cacheSize/1024];
    }else
    {
        _cacheSizeStr=[NSString stringWithFormat:@"%lu MB",cacheSize/1024/1024];
    }
    NSLog(@"nice to meet you");
    return _cacheSizeStr;
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
