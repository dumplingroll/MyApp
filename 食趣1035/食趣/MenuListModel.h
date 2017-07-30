//
//  MenuListModel.h
//  食趣
//
//  Created by 汤汤 on 15/10/19.
//  Copyright © 2015年 汤汤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
@interface MenuListModel : JSONModel

@property (nonatomic,copy)NSString *count;
@property (nonatomic,copy)NSString *myDescription;
@property (nonatomic,copy)NSString *fcount;
@property (nonatomic,copy)NSString *food;
@property (nonatomic,copy)NSString *myId;
@property (nonatomic,copy)NSString *images;
@property (nonatomic,copy)NSString *img;
@property (nonatomic,copy)NSString *keywords;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *rcount;
@end
