//
//  SLPAidInfo.h
//  SLPCommon
//
//  Created by Michael on 2020/6/6.
//  Copyright © 2020 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLPAidInfo : NSObject
// 错误码
@property (nonatomic,assign) UInt16 ErrorCode;

@property (nonatomic,assign) UInt8 musicFlag;//音乐开关
@property (nonatomic,assign) UInt16 musicID;//音乐ID
@property (nonatomic,assign) UInt8 volume;//音量 音量(0-16) 0:静音
@property (nonatomic,assign) UInt8 musicMode;//循环模式 0列表播放 1单曲循环
@property (nonatomic,assign) UInt8 lightFlag;//灯光开关
@property (nonatomic,assign) UInt8 brightness;//灯光亮度 (0-100)
@property (nonatomic, assign) UInt8 r;//灯光颜色r分量 0-255
@property (nonatomic, assign) UInt8 g;//灯光颜色g分量 0-255
@property (nonatomic, assign) UInt8 b;//灯光颜色b分量 0-255
@property (nonatomic, assign) UInt8 w;//灯光颜色W分量 0-255  (目前W分量为0)
@property (nonatomic, assign) UInt8 smartStopFlag;//是否开启智能助眠
@property (nonatomic, assign) UInt16 aidStopDuration;//辅助停止时长 单位：分钟

@end

NS_ASSUME_NONNULL_END
