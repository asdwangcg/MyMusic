//
//  MainViewController.m
//  MyMusic
//
//  Created by wangchonggang on 2017/7/25.
//  Copyright © 2017年 wcg. All rights reserved.
//

#import "MainViewController.h"
#import "PlayView.h"

@interface MainViewController ()<ChangeHeader>

@end

@implementation MainViewController 


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:BackGroundColor];
    
    [PlayView LoadPlayerWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) delegate:self View:^(PlayView *view) {
        [self.view addSubview:view];
        view.delegate = self;
        
    }];
}

- (void)ChangeHeader:(NSString *)Header {
    self.title = Header;
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
