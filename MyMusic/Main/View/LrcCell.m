//
//  LrcCell.m
//  MyMusic
//
//  Created by wangchonggang on 2017/9/18.
//  Copyright © 2017年 wcg. All rights reserved.
//

#import "LrcCell.h"

@implementation LrcCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.LrcString = [[UILabel alloc] initWithFrame:CGRectZero];
        [self setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_LrcString];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_LrcString setBackgroundColor:[UIColor clearColor]];
    [_LrcString setTextAlignment:NSTextAlignmentCenter];
    [_LrcString mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(@0);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(self.mas_height);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
