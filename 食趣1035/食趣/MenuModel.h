//
//  MenuModel.h
//  食趣
//
//  Created by 汤汤 on 15/10/18.
//  Copyright © 2015年 汤汤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
@interface MenuModel : JSONModel

@property (nonatomic,copy)NSString *cookclass;
@property (nonatomic,copy)NSString *myDescription;
@property (nonatomic,copy)NSString *myId;
@property (nonatomic,copy)NSString *keywords;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *seq;
@property (nonatomic,copy)NSString *title;
@end
