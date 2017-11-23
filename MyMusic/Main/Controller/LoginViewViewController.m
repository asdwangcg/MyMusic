//
//  LoginViewViewController.m
//  MyMusic
//
//  Created by wangchonggang on 2017/10/4.
//  Copyright © 2017年 wcg. All rights reserved.
//

#import "LoginViewViewController.h"

@interface LoginViewViewController () {
    TencentOAuth *tencentOAuth;
    NSArray *permissions;
    UIButton *Login;
    UILabel *UserNameLabel;
}

@end

@implementation LoginViewViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"101431684" andDelegate:self];

        permissions = [NSArray arrayWithObjects:kOPEN_PERMISSION_GET_INFO, kOPEN_PERMISSION_GET_SIMPLE_USER_INFO, nil];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:BackGroundColor];
    
    Login = CustomButton;
    [Login setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:Login];
    
    [Login mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.width.height.equalTo(@(40 * ViewCount));
        make.top.equalTo(@20);
    }];

    UserNameLabel = [[UILabel alloc] init];
    [UserNameLabel setTextColor:[UIColor blackColor]];
    [self.view addSubview:UserNameLabel];
    
    [UserNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(Login.mas_right).with.offset(20);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(Login.mas_height);
        make.top.equalTo(Login.mas_top);
    }];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:Token] != 0 && [[NSUserDefaults standardUserDefaults] objectForKey:Token]) {
        [Login sd_setBackgroundImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:QQImage40]] forState:UIControlStateNormal];
        [UserNameLabel setText:[[NSUserDefaults standardUserDefaults] objectForKey:Nickname]];
    }
    else {
        [UserNameLabel setText:@"未登录"];
        [Login addTarget:self action:@selector(LoginAction) forControlEvents:tpi];
    }
}

- (void)LoginAction {
//    NSLog(@"%d", [TencentOAuth iphoneQQInstalled]);
        [tencentOAuth authorize:permissions inSafari:NO];
}

- (void)tencentDidLogin
{
//    _labelTitle.text = @"登录完成";
//    NSLog(@"登录完成");
    if (tencentOAuth.accessToken && 0 != [tencentOAuth.accessToken length])
    {
        // 记录登录用户的OpenID、Token以及过期时间
        
        [[NSUserDefaults standardUserDefaults] setObject:[tencentOAuth accessToken] forKey:Token];
        [[NSUserDefaults standardUserDefaults] setObject:[tencentOAuth openId] forKey:OpenId];

        [tencentOAuth getUserInfo];
        
//        _labelAccessToken.text = tencentOAuth.accessToken;
    }
    else
    {
        NSLog(@"登录不成功 没有获取accesstoken");
//        _labelAccessToken.text = @"登录不成功 没有获取accesstoken";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getUserInfoResponse:(APIResponse*) response{
    NSLog(@"%@--",response.jsonResponse);
    if([[response.jsonResponse objectForKey:@"msg"] length] > 0) {

    }
    else {
//        [[NSUserDefaults standardUserDefaults] setValuesForKeysWithDictionary:response.jsonResponse];
        for (NSString *key in response.jsonResponse) {
            [[NSUserDefaults standardUserDefaults] setObject:[response.jsonResponse objectForKey:key] forKey:key];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [UserNameLabel setText:[[NSUserDefaults standardUserDefaults] objectForKey:Nickname]];
        
        [Login sd_setBackgroundImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:QQImage40]] forState:UIControlStateNormal];
    }
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
