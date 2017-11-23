//
//  PlaySingleton.m
//  MyMusic
//
//  Created by wangchonggang on 2017/9/26.
//  Copyright © 2017年 wcg. All rights reserved.
//

#import "PlaySingleton.h"
static PlaySingleton *Registe = nil;
@implementation PlaySingleton

+ (PlaySingleton *)RegistePlayer {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!Registe) {
            Registe = [[PlaySingleton alloc] init];
        }
    });
    
    return Registe;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

@end
