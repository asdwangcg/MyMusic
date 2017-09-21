//
//  MuModel.m
//  MyMusic
//
//  Created by wangchonggang on 2017/9/7.
//  Copyright © 2017年 wcg. All rights reserved.
//

#import "MuModel.h"

@implementation MuModel
- (instancetype)init
{
    self = [super init];
    if (self) {
//        NSArray *arr = [self MusicList];
//        _block(arr);
    }
    return self;
}

+ (NSMutableDictionary *)MusicList {
/*    NSArray *MuArr = [NSArray arrayWithObjects:
                      @{@"name":@"Aliez", @"author":@"泽野弘之", @"url":@"http://sc1.111ttt.com/2014/1/09/18/2182112003.mp3"},
                      @{@"name":@"繁花", @"author":@"董贞", @"url":@"http://sc1.111ttt.com/2017/1/04/26/297262113196.mp3"},
                      @{@"name":@"风月", @"author":@"黄玲", @"url":@"http://sc1.111ttt.com/2014/1/12/08/5081243257.mp3"}
                      
                      
                      ,nil];//网络歌曲
*/
    
    NSArray *mp3Array = [NSBundle pathsForResourcesOfType:@"mp3" inDirectory:[[NSBundle mainBundle] resourcePath]];//本地歌曲
    MuModel *model = [[MuModel alloc] init];
    return [model Read:mp3Array];
}

- (NSMutableDictionary *)Read:(NSArray *)MuArr {
    NSMutableArray *ResultArr = [NSMutableArray array];
    NSMutableDictionary *ResultDic = [NSMutableDictionary dictionary];
    for (int i = 0; i < [MuArr count]; i ++) {
        NSString *filePath = [MuArr objectAtIndex:i];//随便取一个，说明
        //文件管理，取得文件属性
        //    NSFileManager *fm = [NSFileManager defaultManager];
        //    NSDictionary *dictAtt = [fm attributesOfItemAtPath:filePath error:nil];
        
        //取得音频数据
        NSURL *fileURL=[NSURL fileURLWithPath:filePath];
        AVURLAsset *mp3Asset=[AVURLAsset URLAssetWithURL:fileURL options:nil];
        
        
        NSString *singer;//歌手
        NSString *song;//歌曲名
        UIImage *image;//图片
        NSString *albumName;//专辑名
        //    NSString *fileSize;//文件大小
        //    NSString *voiceStyle;//音质类型
        //    NSString *fileStyle;//文件类型
        //    NSString *creatDate;//创建日期
        //    NSString *savePath; //存储路径
        
        if ([[mp3Asset availableMetadataFormats] count] > 0) {
            for (NSString *format in [mp3Asset availableMetadataFormats]) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setObject:filePath forKey:@"url"];
                
                for (AVMetadataItem *metadataItem in [mp3Asset metadataForFormat:format]) {
                    if([metadataItem.commonKey isEqualToString:@"title"]){
                        song = (NSString *)metadataItem.value;//歌曲名
                        [dic setValue:song forKey:@"name"];
                    }else if ([metadataItem.commonKey isEqualToString:@"artist"]){
                        singer = (NSString *)metadataItem.value;//歌手
                        [dic setValue:singer forKey:@"author"];
                    }
                    //            专辑名称
                    else if ([metadataItem.commonKey isEqualToString:@"albumName"])
                    {
                        albumName = (NSString *)metadataItem.value;
                        [dic setValue:albumName forKey:@"albumName"];
                    }else if ([metadataItem.commonKey isEqualToString:@"artwork"]) {
                        NSDictionary *dict=(NSDictionary *)metadataItem.value;
                        NSData *data=[dict objectForKey:@"data"];
                        image=[UIImage imageWithData:data];//图片
                        [dic setValue:image forKey:@"image"];
                    }
                }
                
                if (![[dic allKeys] containsObject:@"name"]) {
                    [dic setValue:[[filePath lastPathComponent] stringByReplacingOccurrencesOfString:@".mp3" withString:@""] forKey:@"name"];
                }
                else if (![[dic allKeys] containsObject:@"albumName"]){
                    [dic setValue:@"未知" forKey:@"albumName"];
                }
                else if (![[dic allKeys] containsObject:@"author"]){
                    [dic setValue:@"未知" forKey:@"author"];
                }
                else if (![[dic allKeys] containsObject:@"image"]){
                    [dic setValue:[UIImage imageNamed:@"a"] forKey:@"image"];
                }
                [ResultArr addObject:dic];
            }
        }
        else {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setValue:[UIImage imageNamed:@"a"] forKey:@"image"];
            [dic setValue:@"未知" forKey:@"albumName"];
            [dic setValue:@"未知" forKey:@"author"];
            [dic setValue:[[filePath lastPathComponent] stringByReplacingOccurrencesOfString:@".mp3" withString:@""] forKey:@"name"];
            [dic setValue:filePath forKey:@"url"];
            [ResultArr addObject:dic];
        }
    }
    [ResultDic setValue:ResultArr forKey:@"Song"];
    [ResultDic setValue:[self ReadLrc] forKey:@"Lrc"];
    return ResultDic;
}

- (NSMutableArray *)ReadLrc {
    NSArray *LrcArray = [NSBundle pathsForResourcesOfType:@"lrc" inDirectory:[[NSBundle mainBundle] resourcePath]];//本地歌曲
    NSMutableArray *ResultLrcArr = [NSMutableArray array];
    for (int i = 0; i < [LrcArray count]; i ++) {
        NSString *path = [LrcArray objectAtIndex:i];
        
        //if lyric file exits
        if ([path length]) {
            
            //get the lyric string
            
            NSStringEncoding enc =CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
            
            NSString *lyc = [NSString stringWithContentsOfFile:path encoding:enc error:nil];
            
            //init
            NSMutableArray *musictime = [[NSMutableArray alloc] init];
            NSMutableArray *lyrics = [[NSMutableArray alloc] init];
            NSMutableArray *t = [[NSMutableArray alloc] init];
            
            NSArray *arr = [lyc componentsSeparatedByString:@"\n"];
            
            for (NSString *item in arr) {
                
                //if item is not empty
                if ([item length]) {
                    
                    NSRange startrange = [item rangeOfString:@"["];
//                    NSLog(@"%d%d",startrange.length,startrange.location);
                    NSRange stoprange = [item rangeOfString:@"]"];
                    
                    NSString *content = [item substringWithRange:NSMakeRange(startrange.location+1, stoprange.location-startrange.location-1)];
                    
//                    NSLog(@"%d",[item length]);
                    
                    //the music time format is mm.ss.xx such as 00:03.84
                    if ([content length] == 8) {
                        NSString *minute = [content substringWithRange:NSMakeRange(0, 2)];
                        NSString *second = [content substringWithRange:NSMakeRange(3, 2)];
                        NSString *mm = [content substringWithRange:NSMakeRange(6, 2)];
                        
                        NSString *time = [NSString stringWithFormat:@"%@:%@.%@",minute,second,mm];
                        NSNumber *total =[NSNumber numberWithInteger:[minute integerValue] * 60 + [second integerValue]];
                        [t addObject:total];
                        
                        NSString *lyric = [item substringFromIndex:10];
                        
                        [musictime addObject:time];
                        [lyrics addObject:lyric];
                    }
                }
            }
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setValue:musictime forKey:@"time"];
            [dic setValue:lyrics forKey:@"lrc"];
            
#warning FileName
            NSArray *filename = [path componentsSeparatedByString:@"/"];
            
            [dic setValue:[[filename lastObject] stringByReplacingOccurrencesOfString:@".lrc" withString:@""] forKey:@"lrcname"];
            [ResultLrcArr addObject:dic];

        }
//        else {
//            lyrics = nil;
//        }
    }
    return ResultLrcArr;
}

@end
