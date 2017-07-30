//
//  MenuListInfoViewController.h
//  食趣
//
//  Created by 汤汤 on 15/10/20.
//  Copyright © 2015年 汤汤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuListModel.h"
#import "RootViewController.h"
@interface MenuListInfoViewController : RootViewController
@property (nonatomic,strong)MenuListModel *model;
@property (nonatomic,copy)NSString *myId;
@property (nonatomic,copy)NSString *name;

@end
