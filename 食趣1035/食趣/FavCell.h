//
//  FavCell.h
//  食趣
//
//  Created by 汤汤 on 15/10/26.
//  Copyright © 2015年 汤汤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HealthyDetailModel.h"
@interface FavCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *keyLabel;

@property (nonatomic,strong)HealthyDetailModel *model;
@end
