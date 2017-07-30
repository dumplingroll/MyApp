//
//  MenuViewController.m
//  食趣
//
//  Created by 汤汤 on 15/10/18.
//  Copyright © 2015年 汤汤. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuModel.h"
#import "AFNetworking.h"
#import "NetInterface.h"
#import "MenuTableViewCell.h"
#import "MenuListModel.h"
#import "MenuPicScrollCell.h"
#import "MenuCateCellTableViewCell.h"
#import "MenuListInfoViewController.h"
#import "MenuListViewController.h"
#import "MJRefresh.h"
#import "DGActivityIndicatorView.h"

@interface MenuViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataList;//菜谱分类
    NSMutableArray *_menuList;//菜谱列表
    NSInteger _pageIndex;
    BOOL _isLoading;
    BOOL _isHidden;
}
@property (nonatomic,strong)MJRefreshHeaderView *headerView;
@property (nonatomic,strong)MJRefreshFooterView *footerView;
@end

@implementation MenuViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addTitleView:@"食为天"];
     [self createTableView];
    _menuList=[NSMutableArray array];
    [self downloadCategoryData];
    _pageIndex=1;
    [self downloadMenuListData:[NSString stringWithFormat:MENU_LIST_ALL_URL,(long)_pageIndex]];
    
   
    
}



- ( void )dealloc
{
    [_headerView free];
    [_footerView free];
}


- (void)createTableView
{
        
    _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    //NSLog(@"%f",_tableView.frame.size.width);
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [_tableView registerNib:[UINib nibWithNibName:@"MenuTableViewCell" bundle:nil] forCellReuseIdentifier:@"lCell"];
    
    _headerView = [MJRefreshHeaderView header];
    //下拉加载更多添加到表视图上
    _headerView.scrollView = _tableView;
    _headerView.delegate = self;
    
    _footerView = [MJRefreshFooterView footer];
    _footerView.scrollView = _tableView;
    _footerView.delegate = self;
    [self.view addSubview:_tableView];
    
}

////  一旦在下拉刷新和上拉加载的时候都会执行
//-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
//{
//    //说明是下拉刷新
//    if(refreshView == _headerView)
//    {
//        //表示要刷新数据了
//        return;
////        _pageIndex = 1;
////        [self downloadMenuListData:[NSString stringWithFormat:MENU_LIST_ALL_URL,_pageIndex]];
//    }
//    _isLoading=YES;
//    //说明是上拉加载更多
//    if(refreshView == _footerView)
//    {
//        _pageIndex++;
//        [self downloadMenuListData:[NSString stringWithFormat:MENU_LIST_ALL_URL,_pageIndex]];
//    }
//}

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
//    if (refreshView==_headerView) {
//        _pageIndex++;
//    }
    [self downloadMenuListData:[NSString stringWithFormat:MENU_LIST_ALL_URL,_pageIndex]];
}

- (void)downloadCategoryData
{
    DGActivityIndicatorView *activityIndicatorView=[[DGActivityIndicatorView alloc]initWithType:DGActivityIndicatorAnimationTypeTriplePulse tintColor:[UIColor colorWithRed:244.0/255.0 green:152.0/255.0 blue:156.0/255.0 alpha:1] size:[@(35.0f) floatValue]];
    CGFloat width=(WIDTH-200)/2.0f;
    CGFloat height=(HEIGHT-200)/2.0f;
    activityIndicatorView.frame=CGRectMake(width, height, 200, 200);
    [self.view addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    _dataList=[NSMutableArray array];
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager GET:MENU_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        id json=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray *listArray=json[@"tngou"];
        [_dataList addObjectsFromArray:[MenuModel arrayOfModelsFromDictionaries:listArray error:nil]];
        [activityIndicatorView stopAnimating];
        [activityIndicatorView removeFromSuperview];
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"menuError:%@",error.localizedDescription);
    }];
    
    
}

- (void)downloadMenuListData:(NSString *)urlString
{
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        
        id json=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray *listArray=json[@"tngou"];
        [_menuList addObjectsFromArray:[MenuListModel arrayOfModelsFromDictionaries:listArray error:nil]];
        //NSLog(@"count%ld",_menuList.count);
        _isLoading=NO;
        [_headerView endRefreshing];
        [_footerView endRefreshing];
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        [_headerView endRefreshing];
        [_footerView endRefreshing];
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请求超时,请检查您的网络连接" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [self.view addSubview:alertView];
        [alertView show];
        NSLog(@"menu_list_all_error:%@",error.localizedDescription);
    }];
    
}

#pragma mark ---UITableViewDataSource,UITableViewDelegate---
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_menuList.count<=3) {
        return 0;
    }

    return _menuList.count+2-5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1.图片轮转的scrollView
    if (indexPath.row==0)
    {
        MenuPicScrollCell *picCell=[tableView dequeueReusableCellWithIdentifier:@"pCell"];
        if (!picCell)
        {
            picCell=[[MenuPicScrollCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pCell"];
        }
        picCell.picArray=_menuList;
//        [picCell setMenuPicScrollCell:_menuList];
        picCell.transBlock=^(MenuListModel *model)
        {
            MenuListInfoViewController *infoVC=[[MenuListInfoViewController alloc]init];
            infoVC.model=model;
            [self.navigationController pushViewController:infoVC animated:YES];
        };
        
        return picCell;
    }
    //2.分类轮转的scrollView
    else if (indexPath.row==1)
    {
        MenuCateCellTableViewCell *cateCell=[tableView dequeueReusableCellWithIdentifier:@"cCell"];
        if (!cateCell)
        {
            cateCell=[[MenuCateCellTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cCell"];
        }
       
        [cateCell setMenuCateArray:_dataList];
        cateCell.cateBlock=^(NSString *myId,NSString *name)
        {
            MenuListViewController *listVC=[[MenuListViewController alloc]init];
            listVC.myId=myId;
            listVC.name=name;
            [self.navigationController pushViewController:listVC animated:YES];
        };
        return cateCell;
    }
    
    //3.其他
    else
    {
        MenuTableViewCell *listCell=[tableView dequeueReusableCellWithIdentifier:@"lCell" forIndexPath:indexPath];
        listCell.model=_menuList[indexPath.row-2+5];
        return listCell;
    }

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        return 230;
    }else if (indexPath.row==1)
    {
        return 210;
    }else
    {
        return 90;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row>1)
    {
        MenuListInfoViewController *listInfoView=[[MenuListInfoViewController alloc]init];
        listInfoView.model=_menuList[indexPath.row-2+5];
        [self.navigationController pushViewController:listInfoView animated:YES];
    }
}

//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    _isHidden = NO;
//}

//-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
//{
//    if(velocity.y > 0&&_isHidden==NO)
//    {
//        _isHidden = YES;
//        [UIView animateWithDuration:0.5 animations:^{
//            CGRect rect = self.tabBarController.tabBar.frame;
//            rect.origin.y += 49;
//            self.tabBarController.tabBar.frame = rect;
//        }];
//    }
//    else if (velocity.y < 0 && _isHidden == YES)
//    {
//        _isHidden = NO;
//        [UIView animateWithDuration:0.5 animations:^{
//            CGRect rect = self.tabBarController.tabBar.frame;
//            rect.origin.y -= 49;
//            self.tabBarController.tabBar.frame = rect;
//        }];
//        
//    }
//}

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
