//
//  HealthyListViewController.m
//  食趣
//
//  Created by 汤汤 on 15/10/22.
//  Copyright © 2015年 汤汤. All rights reserved.
//

#import "HealthyListViewController.h"
#import "HealthyCollectionCell.h"
#import "NetInterface.h"
#import "MyAFNetWorkHttpRequest.h"
#import "SimpleHealthModel.h"
#import "AFNetworking.h"
#import "SexualDetailController.h"
#import "MJRefresh.h"
#import "DGActivityIndicatorView.h"
@interface HealthyListViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,MJRefreshBaseViewDelegate>
{
    //MyAFNetWorkHttpRequest *_request;
    UICollectionView *_collectionView;
    NSMutableArray *_dataList;
    NSInteger _pageIndex;
    BOOL _isLoading;
}

@property (nonatomic,strong)MJRefreshHeaderView *headerView;
@property (nonatomic,strong)MJRefreshFooterView *footerView;
@end

@implementation HealthyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitleView:@"列表"];
    [self addButtonWithText:nil andImage:@"back" andSelector:@selector(btnClicked) andLocation:YES];
    [self createCollectionView];
    _pageIndex=1;
    [self createDataSource:[NSString stringWithFormat:_urlString,_pageIndex]];
}

- (void)btnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)dealloc
{
    [_headerView free];
    [_footerView free];
}
- (void)createCollectionView
{
    _dataList=[NSMutableArray array];
    UICollectionViewFlowLayout *flow=[[UICollectionViewFlowLayout alloc]init];
    flow.minimumInteritemSpacing=10;
    flow.minimumLineSpacing=10;
    flow.scrollDirection=UICollectionViewScrollDirectionVertical;
    
    _collectionView=[[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flow];
    _collectionView.dataSource=self;
    _collectionView.delegate=self;
//    _collectionView.backgroundColor=[UIColor colorWithRed:231.0/255.0 green:225.0/255.0 blue:217.0/255 alpha:0.8];
    _collectionView.backgroundColor=[UIColor whiteColor];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"HealthyCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"hcc"];
    
    _headerView=[MJRefreshHeaderView header];
    _headerView.scrollView=_collectionView;
    _headerView.delegate=self;
    _footerView=[MJRefreshFooterView footer];
    _footerView.scrollView=_collectionView;
    _footerView.delegate=self;
    
    [self.view addSubview:_collectionView];
    
    
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
    [self createDataSource:[NSString stringWithFormat:_urlString,_pageIndex]];
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
        [_dataList addObjectsFromArray:[HealthyListModel arrayOfModelsFromDictionaries:array error:nil]];
        
        _isLoading=NO;
        [_headerView endRefreshing];
        [_footerView endRefreshing];
        [activityIndicatorView stopAnimating];
        [_collectionView reloadData];
        //NSLog(@"_dataList.count%ld",_dataList.count);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [_headerView endRefreshing];
        [_footerView endRefreshing];
        NSLog(@"healthyListError:%@",error.localizedDescription);
    }];
    
//    _request=[[MyAFNetWorkHttpRequest alloc]initWithRequest:urlString block:^(NSData *responseData)
//               {
//                   SimpleHealthModel *model = [[SimpleHealthModel alloc] initWithData:responseData error:nil];
//                   [_dataList addObjectsFromArray:model.tngou];
//               }];
    
}

#pragma mark ---UICollectionDataSource---
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HealthyCollectionCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"hcc" forIndexPath:indexPath];
    cell.model=_dataList[indexPath.item];
    //NSLog(@"datalist.count%ld",_dataList.count);
    
    
    return cell;
}

#pragma mark ---UICollectionViewDelegateFlowLayout---
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((WIDTH-20-50)/2, 230);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 20, 10, 20);
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"hrr");
    SexualDetailController *detailVC=[[SexualDetailController alloc]init];
    detailVC.myId=((HealthyListModel *)_dataList[indexPath.row]).myId;
    [self.navigationController pushViewController:detailVC animated:YES];
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
