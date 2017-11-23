//
//  PlayerControl.h
//  MyMusic
//
//  Created by wangchonggang on 2017/9/29.
//  Copyright © 2017年 wcg. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol PlayerControlDelegate <NSObject>

@optional
- (void)PlayEnd;
- (void)PlayTimeUpdate;
- (void)AddTarget;
@end

@interface PlayerControl : NSObject
@property (nonatomic, assign)id<PlayerControlDelegate>delegate;
@property (nonatomic, strong)AVPlayer *Player;
@property (nonatomic, strong)AVPlayerItem *PlayerItem;
@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic, strong)NSDictionary *MuDic;//歌曲信息
- (NSUInteger)GetSecond:(NSString *)videoUrl;
@end
