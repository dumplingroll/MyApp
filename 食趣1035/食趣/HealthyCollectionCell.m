//
//  HealthyCollectionCell.m
//  食趣
//
//  Created by 汤汤 on 15/10/22.
//  Copyright © 2015年 汤汤. All rights reserved.
//

#import "HealthyCollectionCell.h"
#import "UIKit+AFNetworking.h"
@implementation HealthyCollectionCell

- (void)awakeFromNib {
    // Initialization code
    
}


- (void)setModel:(HealthyListModel *)model
{
    _model=model;
    [_headImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://tnfs.tngou.net/image%@",model.img]] placeholderImage:nil];
    
    _desLabel.text=model.myDescription;
}
@end
