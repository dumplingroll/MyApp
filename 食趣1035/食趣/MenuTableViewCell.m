//
//  MenuTableViewCell.m
//  食趣
//
//  Created by 汤汤 on 15/10/18.
//  Copyright © 2015年 汤汤. All rights reserved.
//

#import "MenuTableViewCell.h"
#import "UIKit+AFNetworking.h"
@implementation MenuTableViewCell


- (void)awakeFromNib {
    // Initialization code
}


- (void)setModel:(MenuListModel *)model
{
    [_iconImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://tnfs.tngou.net/image%@",model.img]] placeholderImage:nil];
    _nameLabel.text=model.name;
    _desLabel.text=model.myDescription;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
