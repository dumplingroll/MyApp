//
//  SexualFBoyViewCell.m
//  食趣
//
//  Created by 汤汤 on 15/10/21.
//  Copyright © 2015年 汤汤. All rights reserved.
//

#import "SexualFBoyViewCell.h"
#import "UIKit+AFNetworking.h"
@implementation SexualFBoyViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(HealthyListModel *)model
{
    _model=model;
    [_iconImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://tnfs.tngou.net/image%@",model.img]] placeholderImage:nil];
    _desLabel.text=model.myDescription;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
