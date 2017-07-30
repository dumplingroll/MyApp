//
//  FavouriteViewController.m
//  食趣
//
//  Created by 汤汤 on 15/10/26.
//  Copyright © 2015年 汤汤. All rights reserved.
//

#import "FavouriteViewController.h"
#import "DBManager.h"
#import "FavCell.h"
#import "SexualDetailController.h"

@interface FavouriteViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataList;
}
@end

@implementation FavouriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataList=[NSMutableArray array];
    [self addTitleView:@"我的收藏"];
    [self addButtonWithText:nil andImage:@"back" andSelector:@selector(backClick) andLocation:YES];
    [self createDataSource];
    [self createTableView];
    // Do any additional setup after loading the view.
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createDataSource
{
    _dataList=[[[DBManager shareManager]getRecordsWithType:RecordTypeCollection]mutableCopy];

}

- (void)createTableView
{
   // self.navigationItem.rightBarButtonItem=self.editButtonItem;
    _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"FavCell" bundle:nil] forCellReuseIdentifier:@"faCell"];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    
}

#pragma mark ---UITableViewDataSource,UITableViewDelegate---
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
    FavCell *cell=[tableView dequeueReusableCellWithIdentifier:@"faCell" forIndexPath:indexPath];
    cell.model=_dataList[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

//删除

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete)
    {
        HealthyDetailModel *model=_dataList[indexPath.row];
        [_dataList removeObject:model];
        [[DBManager shareManager]deleteRecordWithAppId:model.myId recordType:RecordTypeCollection];
        [_tableView reloadData];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SexualDetailController *sdc=[[SexualDetailController alloc]init];
    sdc.myId=((HealthyDetailModel *)(_dataList[indexPath.row])).myId;
    [self.navigationController pushViewController:sdc animated:YES];
}
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [_tableView setEditing:editing animated:animated];
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
