//
//  DBManager.h
//  食趣
//
//  Created by 汤汤 on 15/10/26.
//  Copyright © 2015年 汤汤. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    RecordTypeCollection=1,//收藏
    RecordTypeDownload,//下载
    RecordTypeShared//分享
}RecordType;

@class HealthyDetailModel;

@interface DBManager : NSObject
+ (DBManager *)shareManager;

//增加一个记录
- (BOOL)addRecordWithAppModel:(HealthyDetailModel *)model recordType:(RecordType)type;

//删除一个记录
- (BOOL)deleteRecordWithAppId:(NSString *)appId recordType:(RecordType)type;

//查找记录
- (BOOL)selectRecordWithAppId:(NSString *)appId recordType:(RecordType)type;

//获取记录
- (NSArray *)getRecordsWithType:(RecordType)type;

@end
