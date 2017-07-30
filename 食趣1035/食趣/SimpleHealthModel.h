//
//  SimpleHealthModel.h
//  食趣
//
//  Created by 汤汤 on 15/10/22.
//  Copyright © 2015年 汤汤. All rights reserved.
//


#import "HealthyListModel.h"
#import "JSONModel.h"

@interface SimpleHealthModel : JSONModel

@property (nonatomic,copy)NSString *total;
@property (nonatomic,retain)NSArray <HealthyListModel> *tngou;

@end
