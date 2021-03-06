//
//  DefineHeader.h
//  MyMusic
//
//  Created by wangchonggang on 2017/9/14.
//  Copyright © 2017年 wcg. All rights reserved.
//

#ifndef DefineHeader_h
#define DefineHeader_h


#define LocalCity @"city"
#define QZImage30 @"figureurl"
#define QZImage50 @"figureurl_1"
#define QZImage100 @"figureurl_2"
#define QQImage40 @"figureurl_qq_1"
#define QQImage100 @"figureurl_qq_2"
#define Gender @"gender"
#define Nickname @"nickname"
#define Province @"province"
#define Token @"accessToken"
#define OpenId @"openId"

#define CustomButton [UIButton buttonWithType:UIButtonTypeCustom]
#define tpi UIControlEventTouchUpInside
#define PlayerColor [UIColor colorWithRed:93 / 255.0 green:197 / 255.0 blue:134 / 255.0 alpha:1]
#define BackGroundColor [UIColor colorWithRed:247 / 255.0 green:247 / 255.0 blue:247 / 255.0 alpha:1]
#define ViewCount self.view.frame.size.width / 375
#define CellCount self.frame.size.width / 375
//#define Count if ([self.superview isKindOfClass:[UIView class]]) {return self.frame.size.width / 375;}else {return self.view.frame.size.width / 375;}

#endif /* DefineHeader_h */
