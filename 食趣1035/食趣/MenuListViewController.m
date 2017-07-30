//
//  MenuListViewController.m
//  食趣
//
//  Created by 汤汤 on 15/10/22.
//  Copyright © 2015年 汤汤. All rights reserved.
//

#import "MenuListViewController.h"
#import "NetInterface.h"
#import "AFNetworking.h"
#import "MenuListModel.h"
#import "MenuTableViewCell.h"
#import "MenuListInfoViewController.h"
#import "MJRefresh.h"
#import "DGActivityIndicatorView.h"

@interface MenuListViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    NSMutableArray *_dataList;
    UITableView *_tableView;
    NSInteger _pageIndex;
    BOOL _isLoading;
    
}
@property (nonatomic,strong)MJRefreshHeaderView *headerView;
@property (nonatomic,strong)MJRefreshFooterView *footerView;
@end

@implementation MenuListViewController
//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    [_footerView free];
//    [_headerView free];
//}
- ( void )dealloc
{
    [_headerView free];
    [_footerView free];
}
- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList=[NSMutableArray array];
    }
    return _dataList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitleView:[NSString stringWithFormat:@"%@*列表",_name]];
    [self addButtonWithText:nil andImage:@"back" andSelector:@selector(btnClicked) andLocation:YES];
    [self createTableView];
    _pageIndex=1;
    [self createDataSource:[NSString stringWithFormat:MENU_LIST_URL,_myId,_pageIndex]];
    //[self createDataSource];
}

- (void)btnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createTableView
{
    
    [self createDataSource:[NSString stringWithFormat:MENU_LIST_URL,_myId,_pageIndex]];

    self.view.backgroundColor=[UIColor whiteColor];
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64-49) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [_tableView registerNib:[UINib nibWithNibName:@"MenuTableViewCell" bundle:nil] forCellReuseIdentifier:@"mCell"];
    _headerView = [MJRefreshHeaderView header];
    //下拉加载更多添加到表视图上
    _headerView.scrollView = _tableView;
    _headerView.delegate = self;
    
    _footerView = [MJRefreshFooterView footer];
    _footerView.scrollView = _tableView;
    _footerView.delegate = self;
    [self.view addSubview:_tableView];
   
}

-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if(_isLoading)
    {
        return;
    }
    _isLoading = YES;
    if(refreshView == _footerView)
    {
        _pageIndex++;
    }
    if (refreshView==_headerView) {
        _pageIndex++;
    }
    [self createDataSource:[NSString stringWithFormat:MENU_LIST_URL,_myId,_pageIndex]];
}



- (void)createDataSource:(NSString *)urlString
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
         [self.dataList addObjectsFromArray:[MenuListModel arrayOfModelsFromDictionaries:array error:nil]];
        // NSLog(@"_datalist.count:%ld",_dataList.count);
         _isLoading=NO;
         [activityIndicatorView stopAnimating];
         [activityIndicatorView removeFromSuperview];
         [_headerView endRefreshing];
         [_footerView endRefreshing];
         [_tableView reloadData];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [_headerView endRefreshing];
         [_footerView endRefreshing];
         NSLog(@"menuListError:%@",error.localizedDescription);
     }];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuTableViewCell *menuCell=[tableView dequeueReusableCellWithIdentifier:@"mCell" forIndexPath:indexPath];
    menuCell.model=_dataList[indexPath.row];
    return menuCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuListInfoViewController *infoVC=[[MenuListInfoViewController alloc]init];
    infoVC.model=_dataList[indexPath.row];
    [self.navigationController pushViewController:infoVC animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
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
