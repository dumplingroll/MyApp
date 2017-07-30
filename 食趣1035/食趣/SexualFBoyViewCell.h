//
//  SexualFBoyViewCell.h
//  食趣
//
//  Created by 汤汤 on 15/10/21.
//  Copyright © 2015年 汤汤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HealthyListModel.h"
@interface SexualFBoyViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;

@property (nonatomic,strong)HealthyListModel *model;
@end
