//
//  PlayerControl.m
//  MyMusic
//
//  Created by wangchonggang on 2017/9/29.
//  Copyright © 2017年 wcg. All rights reserved.
//

#import "PlayerControl.h"

@implementation PlayerControl

- (void)dealloc
{
//    [_PlayerItem removeObserver:self forKeyPath:@"status"];
//    [self removeObserver:self forKeyPath:@"delegate"];
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_Player.currentItem];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _MuDic = [NSDictionary dictionary];
        [self addObserver:self forKeyPath:@"MuDic" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)CreatPlayer {
    //    [self.delegate ChangeHeader:[MuDic objectForKey:@"name"]];

    if ([[_MuDic objectForKey:@"url"] hasPrefix:@"http:"] || [[_MuDic objectForKey:@"url"] hasPrefix:@"https:"]) {
        _PlayerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:[_MuDic objectForKey:@"url"]]];
    }
    else {
        _PlayerItem = [[AVPlayerItem alloc] initWithURL:[NSURL fileURLWithPath:[_MuDic objectForKey:@"url"]]];
    }
    
    
    _Player = [AVPlayer playerWithPlayerItem:_PlayerItem];
    [_PlayerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    _Player.automaticallyWaitsToMinimizeStalling = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PlayEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:_Player.currentItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PlayTimeUpdate) name:AVPlayerItemTimeJumpedNotification object:_Player.currentItem];
    
}

#pragma mark ---- Action ----
- (void)PlayEnd {
    [_PlayerItem removeObserver:self forKeyPath:@"status"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_Player.currentItem];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemTimeJumpedNotification object:_Player.currentItem];

    [_timer invalidate];
    [self.delegate PlayEnd];
}

- (void)PlayTimeUpdate {
    [self.delegate PlayTimeUpdate];
}

- (NSUInteger)GetSecond:(NSString *)videoUrl{
    if ([videoUrl hasPrefix:@"http:"] || [videoUrl hasPrefix:@"https:"]) {
        NSURL *url =  [NSURL URLWithString:videoUrl];
        NSDictionary *opts = [NSDictionary dictionaryWithObject:@(NO) forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
        
        AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts]; // 初始化视频媒体文件
        NSUInteger second = 0;
        second = urlAsset.duration.value / urlAsset.duration.timescale; // 获取视频总时长,单位秒
        return second;
        
    }
    else {
        NSURL *url =  [NSURL fileURLWithPath:videoUrl];
        NSDictionary *opts = [NSDictionary dictionaryWithObject:@(NO) forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
        
        AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts]; // 初始化视频媒体文件
        NSUInteger second = 0;
        second = urlAsset.duration.value / urlAsset.duration.timescale; // 获取视频总时长,单位秒
        return second;
    }
    
    //    AVURLAsset * audioAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    //    CMTime audioDuration = audioAsset.duration;
    //    float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
    //    return audioDurationSeconds;
}


#pragma mark ---- Observe ----
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"MuDic"]) {
        [self CreatPlayer];
    }

    if ([keyPath isEqualToString:@"status"]) {
        switch (_PlayerItem.status) {
            case 0:
                
                break;
            case 1: {
                {
                    NSLog(@"keyi");
                    if ([self GetSecond:[_MuDic objectForKey:@"url"]] > 0) {
                        _timer = [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(PlayTimeUpdate) userInfo:nil repeats:YES];
                        //                        [_timer fire];
                        [self.delegate AddTarget];
                    }
                    else {
                        [self PlayEnd];
                    }
                }
            }
            case 2: {
                //                NSLog(@"播放错误");
                //                NSError *error = [_PlayerItem error];
                //                NSLog(@"11111111%@", error);
                //                if (muindex < [muArr count] - 1) {
                //                    muindex ++;
                //                    MuUrl = [[muArr objectAtIndex:muindex] objectForKey:@"url"];
                //                }
                //                [self PlayEnd];
            }
            default:
                break;
        }
    }
}

@end
