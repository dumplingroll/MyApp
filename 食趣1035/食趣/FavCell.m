//
//  FavCell.m
//  食趣
//
//  Created by 汤汤 on 15/10/26.
//  Copyright © 2015年 汤汤. All rights reserved.
//

#import "FavCell.h"
#import "UIKit+AFNetworking.h"
@implementation FavCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)setModel:(HealthyDetailModel *)model
{
    _model=model;
    [_imgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://tnfs.tngou.net/image%@",model.img]] placeholderImage:nil];
    _nameLabel.text=model.name;
    _keyLabel.text=model.keywords;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
