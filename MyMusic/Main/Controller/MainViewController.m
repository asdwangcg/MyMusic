//
//  MainViewController.m
//  MyMusic
//
//  Created by wangchonggang on 2017/7/25.
//  Copyright © 2017年 wcg. All rights reserved.
//

#import "MainViewController.h"
#import "MusicViewController.h"
#import "PlayerView.h"
@interface MainViewController () {
    MusicViewController *mu;
    
}

@end

@implementation MainViewController {
    EAMiniAudioPlayerView *PlayerSmallView;
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"change" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"playtime" object:nil];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        mu = [[MusicViewController alloc] init];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:BackGroundColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeProgress) name:@"playtime" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangePlayIcon) name:@"change" object:nil];
    EAMiniAudioPlayerStyleConfig *config = [EAMiniAudioPlayerStyleConfig defaultConfig];
    config.playerStyle = EAMiniPlayerHideSoundIcon;

    PlayerSmallView = [[EAMiniAudioPlayerView alloc] initWithPlayerStyleConfig:config];
    [PlayerSmallView.playButton addTarget:self action:@selector(PlayControl) forControlEvents:tpi];
    UITapGestureRecognizer *TapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(PresentMusicView)];
    
    [PlayerSmallView addGestureRecognizer:TapGes];
    [self.view addSubview:PlayerSmallView];
    [PlayerSmallView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.height.equalTo(@60);
        make.width.equalTo(self.view.mas_width);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    UISearchBar *SearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50 * ViewCount)];
    [SearchBar setSearchBarStyle:UISearchBarStyleMinimal];
    [SearchBar setPlaceholder:@"搜索"];
    [SearchBar setBarTintColor:BackGroundColor];
//    [SearchBar setBackgroundColor:BackGroundColor];
    [self.view addSubview:SearchBar];
    [self setUpForDismissKeyboard];
}

- (void)setUpForDismissKeyboard {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAnywhereToDismissKeyboard:)];
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view addGestureRecognizer:singleTapGR];
                }];
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view removeGestureRecognizer:singleTapGR];
                }];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    //此method会将self.view里所有的subview的first responder都resign掉
    [self.view endEditing:YES];
}

- (void)PlayControl {
    [mu.PView PlayAction];
}

- (void)ChangePlayIcon {
    if ([PlayerSmallView.playButton.currentBackgroundImage isEqual:[UIImage imageNamed:@"btn_stop"]]) {
        [PlayerSmallView.playButton setBackgroundImage:[UIImage imageNamed:@"btn_play"] forState:UIControlStateNormal];
    }
    else {
        [PlayerSmallView.playButton setBackgroundImage:[UIImage imageNamed:@"btn_stop"] forState:UIControlStateNormal];
    }
}

- (void)ChangeProgress {
//    NSMutableDictionary *dic = [noti userInfo];
    PlayerSmallView.playProgress = mu.PView.NowSec / mu.PView.LSec;
    if (PlayerSmallView.textLabel.text != mu.PView.HeaderTitle.text) {
        PlayerSmallView.textLabel.text = mu.PView.HeaderTitle.text;
    }
}

- (void)PresentMusicView {
    [self presentViewController:mu animated:YES completion:nil];
}

- (void)ChangeMusic{
//    switch (swipe.direction) {
//        case 0:
//            [mu.PView NextAction];
//            break;
//        case 1:
//            [mu.PView LastAction];
//            break;
//        default:
//            break;
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
