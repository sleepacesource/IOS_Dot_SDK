//
//  SLPSleepaceMusicInfo.h
//  SDK
//
//  Created by Martin on 2018/3/1.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLPSleepaceMusicInfo : NSObject
@property (nonatomic, assign) UInt16 musicID;//音乐ID
@property (nonatomic, assign) UInt8 playMode;//播放模式 0：顺序播放 1: 随机播放 2: 单曲播放
@end
