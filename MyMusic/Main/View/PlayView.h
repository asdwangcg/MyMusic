//
//  PlayView.h
//  MyMusic
//
//  Created by wangchonggang on 2017/9/7.
//  Copyright © 2017年 wcg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PlayView;
typedef void(^MuBlock)(PlayView *);
@protocol ChangeHeader <NSObject>

- (void)ChangeHeader:(NSString *)Header;

@end
@interface PlayView : UIView<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign)id <ChangeHeader>delegate;
+ (void)LoadPlayerWithFrame:(CGRect)frame delegate:(id)delegate View:(MuBlock)block;
@end
