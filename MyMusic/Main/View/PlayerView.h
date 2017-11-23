//
//  PlayerView.h
//  MyMusic
//
//  Created by wangchonggang on 2017/9/29.
//  Copyright © 2017年 wcg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerControl.h"
@protocol PlayerViewDelegate <NSObject>
- (void)Back;

@end

@interface PlayerView : UIView<UITableViewDelegate, UITableViewDataSource, PlayerControlDelegate>
@property (nonatomic, assign)id <PlayerViewDelegate>delegate;
@property (nonatomic, assign)CGFloat NowSec;//当前second
@property (nonatomic, assign)NSInteger LSec;//总长second
@property (nonatomic, strong)UILabel *HeaderTitle;//标题

- (void)PlayAction;

@end
