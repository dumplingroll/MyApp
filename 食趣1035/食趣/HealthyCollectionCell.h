//
//  HealthyCollectionCell.h
//  食趣
//
//  Created by 汤汤 on 15/10/22.
//  Copyright © 2015年 汤汤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HealthyListModel.h"
@interface HealthyCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;

@property (nonatomic,strong)HealthyListModel *model;
@end
