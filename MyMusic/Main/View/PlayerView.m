//
//  PlayerView.m
//  MyMusic
//
//  Created by wangchonggang on 2017/9/29.
//  Copyright © 2017年 wcg. All rights reserved.
//

#import "PlayerView.h"
#import "MuModel.h"
#import "LrcCell.h"
typedef enum : NSUInteger {
    PlayDanqu,//单曲
    PlayRandom,//随机
    PlayTurn,//循环
} PlayStatusEnum;
@implementation PlayerView{
    UILabel *Nolabel;//当前时间
    UILabel *Llabel;//总长度
    UISlider *MuSlider;//滑动
    //    NSString *MuUrl;
    NSDictionary *MuDic;//歌曲信息
    NSDictionary *LrcDic;//歌词信息
    NSInteger PlayStatus;//循环状态
    UIButton *TurnButton;//循环控制状态
    UIButton *PlayButton;//播放，暂停
    UIButton *NextButton;//下一首切换
    UIButton *LastButton;//上一首切换
    
    NSInteger CurrentLrcIndex;//当前歌词
    NSMutableArray *muArr;
    NSMutableArray *lrcArr;
    NSInteger muindex;
    
    UIView *HeaderBar;//标题及控制
    UIButton *BackButton;//返回
    
    UITableView *MuTable;//歌词显示
    
    PlayerControl *Control;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"delegate"];
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_Player.currentItem];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        muArr = [[MuModel MusicList] objectForKey:@"Song"];
        lrcArr = [[MuModel MusicList] objectForKey:@"Lrc"];
        
        MuDic = [muArr firstObject];
        LrcDic = [NSMutableDictionary dictionary];
        
        muindex = 0;
        

        [self creatPlayUI];
        [self CreatPlayer];
        [self TurnCreat];
        [self CreatPlayButton];
        
    }
    return self;
}

- (void)Back {
    [self.delegate Back];
}

- (void)creatPlayUI {
    
    [self CreatHeaderBar];
    
    MuTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    MuTable.delegate = self;
    MuTable.dataSource = self;
    MuTable.tableFooterView = [[UIView alloc] init];
    [MuTable setBackgroundColor:BackGroundColor];
    [MuTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self addSubview:MuTable];
    
    [MuTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(HeaderBar.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.width.equalTo(self.mas_width);
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width, self.frame.size.height - 120 * CellCount - HeaderBar.frame.size.height));
    }];
    
    Nolabel = [[UILabel alloc] init];
    [Nolabel setTextColor:[UIColor blackColor]];
    [self addSubview:Nolabel];
    [Nolabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(MuTable.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.width.height.equalTo(@(60 * CellCount));
        //        make.bottom.mas_equalTo(self.mas_bottom).with.offset(-120 * CellCount);
    }];
    
    MuSlider = [[UISlider alloc] init];
    [MuSlider setValue:0];
    [MuSlider addTarget:self action:@selector(ChangeSecond) forControlEvents:UIControlEventValueChanged];
    [MuSlider setThumbTintColor:PlayerColor];
    [MuSlider setThumbImage:[UIImage imageNamed:@"SliderPoint"] forState:UIControlStateNormal];
    [MuSlider setThumbImage:[UIImage imageNamed:@"SliderPoint"] forState:UIControlStateHighlighted];
    
    [MuSlider setMinimumTrackTintColor:PlayerColor];
    
    [self addSubview:MuSlider];
    [MuSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(Nolabel.mas_right);
        make.centerY.equalTo(Nolabel.mas_centerY);
        make.width.mas_equalTo(self.frame.size.width - 120 * CellCount);
    }];
    
    
    Llabel = [[UILabel alloc] init];
    //    [Llabel setBackgroundColor:[UIColor blackColor]];
    [Llabel setTextColor:[UIColor blackColor]];
    [self addSubview:Llabel];
    [Llabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(MuSlider.mas_right);
        make.width.equalTo(Nolabel.mas_width);
        make.height.equalTo(Nolabel.mas_height);
        make.centerY.equalTo(Nolabel.mas_centerY);
    }];
}

- (void)CreatPlayer {
    [_HeaderTitle setText:[MuDic objectForKey:@"name"]];
    
    for (NSMutableDictionary *dic in lrcArr) {
        if ([[dic objectForKey:@"lrcname"] containsString:[MuDic objectForKey:@"name"]]) {
            LrcDic = dic;
            break;
        }
        else {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            NSMutableArray *TimeArrTemp = [NSMutableArray array];
            NSMutableArray *LrcArrTemp = [NSMutableArray arrayWithObject:@"暂无歌词信息"];
            [dict setValue:TimeArrTemp forKey:@"time"];
            [dict setValue:LrcArrTemp forKey:@"lrc"];
            LrcDic = dict;
        }
    }
    
    [MuTable reloadData];
    
    [Nolabel setText:@"00:00"];
    //    [PlayButton setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
    [Control.Player pause];
    Control = nil;
    
    Control = [[PlayerControl alloc] init];
    Control.delegate = self;
    Control.MuDic = MuDic;
    
    _LSec = [Control GetSecond:[MuDic objectForKey:@"url"]];
    [Llabel setText:[NSString stringWithFormat:@"%.2ld:%.2ld", _LSec / 60, _LSec % 60]];
}

- (void)TurnCreat {
    TurnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [TurnButton setImage:[UIImage imageNamed:@"单曲"] forState:UIControlStateNormal];
    PlayStatus = PlayDanqu;
    [TurnButton addTarget:self action:@selector(ChangeAStay) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:TurnButton];
    
    [TurnButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(Nolabel.mas_left);
        make.width.height.equalTo(@(50 * CellCount));
        make.top.equalTo(MuSlider.mas_bottom).with.offset(10 * CellCount);
    }];
}

- (void)CreatPlayButton {
    
    LastButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [LastButton setImage:[UIImage imageNamed:@"上一首"] forState:UIControlStateNormal];
    [LastButton.layer setCornerRadius:25.0f];
    [self addSubview:LastButton];
    
    [LastButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@50);
        make.top.equalTo(MuSlider.mas_bottom).with.offset(10 * CellCount);
        make.left.equalTo(TurnButton.mas_right).with.offset(10 * CellCount);
    }];
    
    
    PlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [PlayButton setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
    [PlayButton.layer setCornerRadius:25.0f];
    //    [button addTarget:self action:@selector(Ba:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:PlayButton];
    
    [PlayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(60 * CellCount));
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(LastButton.mas_centerY);
    }];
    
    NextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [NextButton setImage:[UIImage imageNamed:@"下一首"] forState:UIControlStateNormal];
    [NextButton.layer setCornerRadius:25.0f];
    [self addSubview:NextButton];
    
    [NextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(50 * CellCount));
        make.top.equalTo(MuSlider.mas_bottom).with.offset(10 * CellCount);
        make.right.equalTo(self.mas_right).with.offset(-60 * CellCount);
    }];
    
}

- (void)CreatHeaderBar {
    HeaderBar = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.frame.size.width, 44 * CellCount)];
    
    BackButton =CustomButton;
    [BackButton setFrame:CGRectMake(20 * CellCount, (HeaderBar.frame.size.height - 20) / 2, 35 * CellCount, 20 * CellCount)];
    [BackButton setImage:[UIImage imageNamed:@"Down"] forState:UIControlStateNormal];
    [BackButton addTarget:self action:@selector(Back) forControlEvents:tpi];
    [HeaderBar addSubview:BackButton];
    
    _HeaderTitle = [[UILabel alloc] initWithFrame:CGRectMake(BackButton.frame.origin.x + BackButton.frame.size.width, 0, HeaderBar.frame.size.width - (BackButton.frame.origin.x + BackButton.frame.size.width) * 2, HeaderBar.frame.size.height)];
    [_HeaderTitle setTextAlignment:NSTextAlignmentCenter];
    [HeaderBar addSubview:_HeaderTitle];
    
    [self addSubview:HeaderBar];
}
#pragma makr ---- Delegate ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[LrcDic objectForKey:@"lrc"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LrcCell *cell = nil;
    static NSString *idf = @"MyMusic";
    if (cell == nil) {
        cell = [[LrcCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idf];
    }
    else {
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    [cell.LrcString setText:[[LrcDic objectForKey:@"lrc"] objectAtIndex:indexPath.row]];
    if (CurrentLrcIndex == indexPath.row && [[LrcDic objectForKey:@"lrc"] count] > 1) {
        [cell.LrcString setTextColor:[UIColor orangeColor]];
    } else {
        [cell.LrcString setTextColor:[UIColor blackColor]];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}


#pragma mark ---- Action ----
- (void)AddTarget {
    if ([PlayButton.currentImage isEqual:[UIImage imageNamed:@"暂停"]]) {
        [Control.Player play];
    }
    [PlayButton addTarget:self action:@selector(PlayAction) forControlEvents:UIControlEventTouchUpInside];
    [LastButton addTarget:self action:@selector(LastAction) forControlEvents:UIControlEventTouchUpInside];
    [NextButton addTarget:self action:@selector(NextAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)PlayAction {
    if ([PlayButton.currentImage isEqual:[UIImage imageNamed:@"暂停"]]) {
        [PlayButton setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
        [Control.Player pause];
        [Control.timer setFireDate:[NSDate distantFuture]];
        
    }
    else {
        [PlayButton setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
        [Control.Player play];
        [Control.timer setFireDate:[NSDate date]];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"change" object:nil];
}

- (void)LastAction {
    if (muindex > 0) {
        [self PlayRemove];
        CurrentLrcIndex = 0;
        muindex --;
        MuDic = [muArr objectAtIndex:muindex];
        [self CreatPlayer];
    }
    [self configNowPlayingCenter];
}

- (void)NextAction {
    if (muindex < [muArr count] - 1) {
        CurrentLrcIndex = 0;
        [self PlayRemove];
        muindex ++;
        MuDic = [muArr objectAtIndex:muindex];
        [self CreatPlayer];
    }
    [self configNowPlayingCenter];
}

- (void)PlayRemove {
    _NowSec = 0;
}

- (void)ChangeSecond {
    if ((MuSlider.value * _LSec) != _NowSec) {
        [Control.Player seekToTime:CMTimeMake(MuSlider.value * _LSec, 1)];
        _NowSec = (MuSlider.value * _LSec);
        [MuTable reloadData];
        [self PlayTimeUpdate];
    }
}

- (void)PlayTimeUpdate {
    _NowSec = Control.PlayerItem.currentTime.value / (float)Control.PlayerItem.currentTime.timescale;
    
    NSInteger objind = 0;
    for (NSString *time in [LrcDic objectForKey:@"time"]) {
        CGFloat nowtime = 0;
        if ([[time componentsSeparatedByString:@":"] count] < 3) {
            nowtime = [[[time componentsSeparatedByString:@":"] firstObject] doubleValue] * 60.00f + [[[time componentsSeparatedByString:@":"] lastObject] doubleValue];
        }
        else {
            
        }
        
        NSIndexPath *CurrentIndex = [NSIndexPath indexPathForRow:objind inSection:0];
        LrcCell *CurrentCell = [MuTable cellForRowAtIndexPath:CurrentIndex];
        
        if ([[NSString stringWithFormat:@"%.2f", _NowSec] isEqualToString:[NSString stringWithFormat:@"%.2f", nowtime]]) {
            //        if (_NowSec < nowtime) {
            //            NSIndexPath *CurrentIndex = [NSIndexPath indexPathForRow:objind - 1 inSection:0];
            //            LrcCell *CurrentCell = [MuTable cellForRowAtIndexPath:CurrentIndex];
            
            [CurrentCell.LrcString setTextColor:[UIColor orangeColor]];
            CurrentLrcIndex = [[LrcDic objectForKey:@"time"] indexOfObject:time];
            for (int i = 0; i < objind; i ++) {
                NSIndexPath *ind = [NSIndexPath indexPathForRow:i inSection:0];
                LrcCell *Cell = [MuTable cellForRowAtIndexPath:ind];
                [Cell.LrcString setTextColor:[UIColor blackColor]];
            }
            //            NSLog(@"%ld", CurrentIndex.row);
            [MuTable scrollToRowAtIndexPath:CurrentIndex atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            break;
        }
        else {
            
        }
        objind ++;
    }
    
    if (_NowSec < 60) {
        [Nolabel setText:[NSString stringWithFormat:@"00:%.2ld", (long)_NowSec]];
    }
    else {
        [Nolabel setText:[NSString stringWithFormat:@"%.2ld:%.2ld", (NSInteger)_NowSec / 60, (NSInteger)_NowSec % 60]];
    }
    
    
    //    NSLog(@"_NowSec=%ld", (long)_NowSec);
    //    NSLog(@"_LSec=%ld", (long)_LSec);
    float a = _NowSec;
    float b = _LSec;
    [MuSlider setValue:a / b animated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"playtime" object:nil];
}

- (void)ChangeAStay {
    switch (PlayStatus) {
        case PlayDanqu:
            PlayStatus = PlayTurn;
            [TurnButton setImage:[UIImage imageNamed:@"循环"] forState:UIControlStateNormal];
            break;
        case PlayTurn:
            PlayStatus = PlayRandom;
            [TurnButton setImage:[UIImage imageNamed:@"随机"] forState:UIControlStateNormal];
            break;
        case PlayRandom:
            PlayStatus = PlayDanqu;
            [TurnButton setImage:[UIImage imageNamed:@"单曲"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

- (void)PlayEnd {
    [self PlayRemove];
    switch (PlayStatus) {
        case PlayDanqu:
            [self CreatPlayer];
            break;
        case PlayRandom:
        {
            NSInteger ins = arc4random() % [muArr count];
            while (ins == muindex) {
                ins = arc4random() % [muArr count];
            }
            MuDic = [muArr objectAtIndex:ins];
            muindex = ins;
            [self CreatPlayer];
        }
            break;
        case PlayTurn:
        {
            if (muindex < [muArr count] - 1) {
                muindex ++;
                MuDic = [muArr objectAtIndex:muindex];
                [self CreatPlayer];
            } else {
                muindex = 0;
                MuDic = [muArr objectAtIndex:muindex];
                [self CreatPlayer];
            }
        }
            break;
        default:
            
            break;
    }    
    [self configNowPlayingCenter];
}

//Now Playing Center可以在锁屏界面展示音乐的信息，也达到增强用户体验的作用。
////传递信息到锁屏状态下 此方法在播放歌曲与切换歌曲时调用即可
- (void)configNowPlayingCenter {
    NSLog(@"锁屏设置");
    // BASE_INFO_FUN(@"配置NowPlayingCenter");
    NSMutableDictionary * info = [NSMutableDictionary dictionary];
    //音乐的标题
    //    [info setObject:self.nameLabel.text forKey:MPMediaItemPropertyTitle];
    //音乐的艺术家
    //    NSString *author= [[self.playlistArr[self.currentNum] valueForKey:@"songinfo"] valueForKey:@"author"];
    //    [info setObject:author forKey:MPMediaItemPropertyArtist];
    //音乐的播放时间
    [info setObject:@(_NowSec) forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    //音乐的播放速度
    [info setObject:@(1) forKey:MPNowPlayingInfoPropertyPlaybackRate];
    //音乐的总时间
    [info setObject:@(_LSec) forKey:MPMediaItemPropertyPlaybackDuration];
    //音乐的封面
    //    MPMediaItemArtwork * artwork = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"0.jpg"]];
    //    [info setObject:artwork forKey:MPMediaItemPropertyArtwork];
    //完成设置
    [[MPNowPlayingInfoCenter defaultCenter]setNowPlayingInfo:info];
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent {
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        switch (receivedEvent.subtype) {
            case UIEventSubtypeRemoteControlPlay:
                [PlayButton setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
                [Control.Player pause];
                [Control.timer setFireDate:[NSDate distantFuture]];
                break;
            case UIEventSubtypeRemoteControlPause:
                [PlayButton setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
                [Control.Player play];
                [Control.timer setFireDate:[NSDate date]];
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                [self PlayEnd];
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                [self PlayEnd];
                break;
            default:
                break;
        }
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
