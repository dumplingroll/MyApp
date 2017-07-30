//
//  SexualViewController.m
//  食趣
//
//  Created by 汤汤 on 15/10/21.
//  Copyright © 2015年 汤汤. All rights reserved.
//

#import "SexualViewController.h"
#import "AFNetworking.h"
#import "HealthyListModel.h"
#import "NetInterface.h"
#import "SexualGirlViewCell.h"
#import "SexualFBoyViewCell.h"
#import "SexualSBoyViewCell.h"
#import "SexualDetailController.h"
#import "MJRefresh.h"
#import "DGActivityIndicatorView.h"
@interface SexualViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    NSInteger _index;
    NSMutableArray *_dataList;
    UITableView *_tableView;
    NSMutableArray *_aDataList;
    UITableView *_aTableView;
    BOOL _isBigCell;
    BOOL _isGirlLoading;
    BOOL _isBoyLoading;
    NSInteger _girlPageIndex;
    NSInteger _boyPageIndex;
}
@property (nonatomic,strong)MJRefreshHeaderView *girlHeaderView;
@property (nonatomic,strong)MJRefreshFooterView *girlFooterView;

@property (nonatomic,strong)MJRefreshHeaderView *boyHeaderView;
@property (nonatomic,strong)MJRefreshFooterView *boyFooterView;


@end

@implementation SexualViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self createUI];
    
}

- (void)dealloc
{
    [_girlHeaderView free];
    [_girlFooterView free];
    [_boyHeaderView free];
    [_boyHeaderView free];
}
- (void)createUI
{
    _dataList=[NSMutableArray array];
    _aDataList=[NSMutableArray array];
    _isBigCell=YES;
    _index=0;
    _girlPageIndex=1;
    _boyPageIndex=1;
    NSArray *titleArray=@[@"男生有益",@"女生有益"];
    UISegmentedControl *seg = [[UISegmentedControl alloc]initWithItems:titleArray];
    seg.frame = CGRectMake(0, 0, 150, 30);
    seg.selectedSegmentIndex = 0;
    seg.tintColor=[UIColor colorWithRed:231.0/255.0 green:225.0/255.0 blue:217.0/255 alpha:1];
    [seg addTarget:self action:@selector(changeSegment:) forControlEvents:(UIControlEventValueChanged)];
    self.navigationItem.titleView = seg;
    [self createBoyView];
    [self downloadData:_index andUrl:[NSString stringWithFormat:BOY_LIST_URL,(long)1]];

}

-(void)changeSegment:(UISegmentedControl *)sender
{
    _index = sender.selectedSegmentIndex;
    if(_index==0)
    {
        [self createBoyView];
        [self downloadData:_index andUrl:[NSString stringWithFormat:BOY_LIST_URL,(long)1]];
    }
    else if(_index == 1)
    {
        [self createGirlView];
        [self downloadData:_index andUrl:[NSString stringWithFormat:GIRL_LIST_URL,(long)1]];
    }
    
    
}

/**
 *  根据不同的选择创建不同的视图
 */
- (void)createBoyView
{
    self.automaticallyAdjustsScrollViewInsets=NO;
    _aTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-49-64) style:UITableViewStylePlain];
    
    _boyHeaderView = [MJRefreshHeaderView header];
    _boyHeaderView.scrollView = _aTableView;
    _boyHeaderView.delegate = self;
    
    _boyFooterView = [MJRefreshFooterView footer];
    _boyFooterView.scrollView = _aTableView;
    _boyFooterView.delegate = self;
    [self.view addSubview:_aTableView];
    [_aTableView registerNib:[UINib nibWithNibName:@"SexualSBoyViewCell" bundle:nil] forCellReuseIdentifier:@"sCell"];
    [_aTableView registerNib:[UINib nibWithNibName:@"SexualFBoyViewCell" bundle:nil] forCellReuseIdentifier:@"fCell"];
    _aTableView.delegate=self;
    _aTableView.dataSource=self;
    
}

- (void)createGirlView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64-49) style:UITableViewStylePlain];
    [_tableView registerNib:[UINib nibWithNibName:@"SexualGirlViewCell" bundle:nil] forCellReuseIdentifier:@"gCell"];
    _girlHeaderView=[MJRefreshHeaderView header];
    _girlHeaderView.scrollView=_tableView;
    _girlHeaderView.delegate=self;
    
    _girlFooterView=[MJRefreshFooterView footer];
    _girlFooterView.scrollView=_tableView;
    _girlFooterView.delegate=self;
    [self.view addSubview:_tableView];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    
}

-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (_index==0)
    {
        //男孩刷新
        if(_isBoyLoading)
        {
            return;
        }
        _isBoyLoading = YES;
        if(refreshView == _boyFooterView)
        {
            _boyPageIndex++;
        }
        if (refreshView==_boyHeaderView) {
            _boyPageIndex++;
        }
        [self downloadData:_index andUrl:[NSString stringWithFormat:BOY_LIST_URL,(long)_boyPageIndex]];

    }else if (_index==1)
    {
        //女孩刷新
        if(_isGirlLoading)
        {
            return;
        }
        _isGirlLoading = YES;
        if(refreshView == _girlFooterView)
        {
            _girlPageIndex++;
        }
        if (refreshView==_girlHeaderView) {
            _girlPageIndex++;
        }
        [self downloadData:_index andUrl:[NSString stringWithFormat:GIRL_LIST_URL,(long)_girlPageIndex]];

    }
}

- (void)downloadData:(NSInteger)index andUrl:(NSString *)urlString
{
    if (index==0)
    {
//        DGActivityIndicatorView *activityIndicatorView=[[DGActivityIndicatorView alloc]initWithType:DGActivityIndicatorAnimationTypeTriplePulse tintColor:[UIColor colorWithRed:244.0/255.0 green:152.0/255.0 blue:156.0/255.0 alpha:1] size:[@(35.0f) floatValue]];
//        CGFloat width=(WIDTH-200)/2.0f;
//        CGFloat height=(HEIGHT-200)/2.0f;
//        activityIndicatorView.frame=CGRectMake(width, height, 200, 200);
//        [self.view addSubview:activityIndicatorView];
//        [activityIndicatorView startAnimating];

        AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
        manager.responseSerializer=[AFHTTPResponseSerializer serializer];
        [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
        {
            id json=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSArray *array=json[@"tngou"];
            [_aDataList addObjectsFromArray:[HealthyListModel arrayOfModelsFromDictionaries:array error:nil]];
            //NSLog(@"_bdataList%ld",(unsigned long)_aDataList.count);
            _isBoyLoading=NO;
            [_boyHeaderView endRefreshing];
            [_boyFooterView endRefreshing];
            //[activityIndicatorView stopAnimating];
            [_aTableView reloadData];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error)
        {
            [_boyHeaderView endRefreshing];
            [_boyFooterView endRefreshing];
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请求超时,请检查您的网络连接" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [self.view addSubview:alertView];
            [alertView show];


            NSLog(@"boyError:%@",error.localizedDescription);
        }];
    }else if (index==1)
    {
        DGActivityIndicatorView *activityIndicatorView=[[DGActivityIndicatorView alloc]initWithType:DGActivityIndicatorAnimationTypeTriplePulse tintColor:[UIColor colorWithRed:244.0/255.0 green:152.0/255.0 blue:156.0/255.0 alpha:1] size:[@(35.0f) floatValue]];
        CGFloat width=(WIDTH-200)/2.0f;
        CGFloat height=(HEIGHT-200)/2.0f;
        activityIndicatorView.frame=CGRectMake(width, height, 200, 200);
        [self.view addSubview:activityIndicatorView];
        [activityIndicatorView startAnimating];

        AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
        manager.responseSerializer=[AFHTTPResponseSerializer serializer];
        [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             id json=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
             NSArray *array=json[@"tngou"];
             [_dataList addObjectsFromArray:[HealthyListModel arrayOfModelsFromDictionaries:array error:nil]];
             _isGirlLoading=NO;
             [_girlHeaderView endRefreshing];
             [_girlFooterView endRefreshing];
             [activityIndicatorView stopAnimating];
             activityIndicatorView.hidden=YES;
             [_tableView reloadData];
             //NSLog(@"_gdataList%ld",(unsigned long)_dataList.count);
         } failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             [_girlHeaderView endRefreshing];
             [_girlFooterView endRefreshing];
             UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请求超时,请检查您的网络连接" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
             [self.view addSubview:alertView];
             [alertView show];

             NSLog(@"girlError:%@",error.localizedDescription);
         }];

    }
}


#pragma mark  ---UITableViewDataSource,UITableViewDelegate---
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==_tableView)
    {
        return _dataList.count;
    }else
    {
        return _aDataList.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if(tableView ==_aTableView)
    {
        SexualSBoyViewCell *sboyCell=[tableView dequeueReusableCellWithIdentifier:@"sCell"];
        SexualFBoyViewCell *fboyCell=[tableView dequeueReusableCellWithIdentifier:@"fCell"];

        if(indexPath.row%4)
        {
            fboyCell.model = _aDataList[indexPath.row];
            _isBigCell=YES;
            return fboyCell;
        }
        else
        {
            sboyCell.model = _aDataList[indexPath.row];
            _isBigCell=NO;
            return sboyCell;
        }
    }
    else if(tableView==_tableView)
    {
        SexualGirlViewCell *girlCell=[tableView dequeueReusableCellWithIdentifier:@"gCell" forIndexPath:indexPath];
        girlCell.model=_dataList[indexPath.row];
        return girlCell;
        
    }

    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _aTableView)
    {
        if(_isBigCell)
        {
            return 90;
        }
        else
        {
            return 250;
        }
        
    }
    else if (tableView == _tableView)
    {
        return 90;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView==_aTableView)
    {
        NSLog(@"boy");
        SexualDetailController *detail=[[SexualDetailController alloc]init];
        detail.myId=((HealthyListModel *)_aDataList[indexPath.row]).myId;
        [self.navigationController pushViewController:detail animated:YES];
    }else if (tableView==_tableView)
    {
        NSLog(@"girl");
        SexualDetailController *detail=[[SexualDetailController alloc]init];
        detail.myId=((HealthyListModel *)_dataList[indexPath.row]).myId;
        [self.navigationController pushViewController:detail animated:YES];
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
