//
//  DBManager.m
//  食趣
//
//  Created by 汤汤 on 15/10/26.
//  Copyright © 2015年 汤汤. All rights reserved.
//

#import "DBManager.h"
#import "FMDatabase.h"
#import "HealthyDetailModel.h"

static DBManager *manager=nil;
@implementation DBManager
{
    FMDatabase *_database;
    NSLock *_lock;//加锁
}

+ (DBManager *)shareManager
{
    @synchronized(self)
    {
        if (!manager) {
            manager = [[DBManager alloc] init];
        }
    }
    return  manager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    if (manager == nil) {
        manager = [super allocWithZone:zone];
    }
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        //创建线程锁
        _lock = [[NSLock alloc] init];
        //创建数据库
        NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/applist.db"];
        NSLog(@"%@",path);
        _database = [[FMDatabase alloc] initWithPath:path];
        if([_database open])
        {
            NSString *createSql = @"create table if not exists heallist ("
            " id integer primary key autoincrement not null, "
            " myId varchar(128) not null, "
            " name varchar(128), "
            " img varchar(1024), "
            " keywords varchar(1024), "
            " type varchar(32) "
            ");";
            BOOL ret = [_database executeUpdate:createSql];
            if (!ret) {
                NSLog(@"create error = %@",_database.lastErrorMessage);
            }
        }
    }
    return self;
}


- (BOOL)addRecordWithAppModel:(HealthyDetailModel *)model recordType:(RecordType)type
{
    [_lock lock];
    NSString *insertSql = @"insert into heallist(myId,name,img,keywords,type) values(?,?,?,?,?)";
    
    BOOL ret = [_database executeUpdate:insertSql,model.myId,model.name,model.img,model.keywords,[NSString stringWithFormat:@"%i",type]];
    if (!ret) {
        NSLog(@"insert error = %@", _database.lastErrorMessage);
    }
    [_lock unlock];
    return ret;
}


- (BOOL)deleteRecordWithAppId:(NSString *)appId recordType:(RecordType)type
{
    [_lock lock];
    NSString *deleteSql = @"delete from heallist where myId=? and type=?";
    BOOL ret = [_database executeUpdate:deleteSql,appId,[NSString stringWithFormat:@"%i",type]];
    if (!ret) {
        NSLog(@"delegte error = %@", _database.lastErrorMessage);
    }
    [_lock unlock];
    return ret;
}


//判断id对象是否存在
- (BOOL)selectRecordWithAppId:(NSString *)appId recordType:(RecordType)type
{
    [_lock lock];
    NSString *selectSql = @"select count(*) from heallist where myId=? and type=?";
    FMResultSet *set = [_database executeQuery:selectSql,appId,[NSString stringWithFormat:@"%i",type]];
    NSInteger count = 0;
    if ([set next]) {
        count = [set intForColumnIndex:0];
    }
    [_lock unlock];
    return count;
}


//获取全部数据
- (NSArray *)getRecordsWithType:(RecordType)type
{
    [_lock lock];
    NSString *fetchSql = @"select * from heallist where type=?";
    NSMutableArray *mulArray = [NSMutableArray array];
    FMResultSet *set = [_database executeQuery:fetchSql,[NSString stringWithFormat:@"%i",type]];
    while ([set next]) {
        HealthyDetailModel *model = [[HealthyDetailModel alloc]init];
        model.myId = [set stringForColumn:@"myId"];
        model.name = [set stringForColumn:@"name"];
        model.img = [set stringForColumn:@"img"];
        model.keywords=[set stringForColumn:@"keywords"];
        [mulArray addObject:model];
    }
    [_lock unlock];
    return mulArray;
}

@end
