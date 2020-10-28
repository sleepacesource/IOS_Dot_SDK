//
//  SLPAlarmInfo.h
//  SLPCommon
//
//  Created by Michael on 2020/6/6.
//  Copyright © 2020 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLPAlarmInfo : NSObject

@property (nonatomic, assign) UInt8 alarmID;//闹钟编号 0：表示本地闹钟 1：表示APP增加的闹钟，依次增加
@property (nonatomic, assign) BOOL isOpen;//闹钟开关
@property (nonatomic, assign) BOOL smartFlag;//是否智能开启 0:否， 1:是
@property (nonatomic, assign) UInt8 smartOffset;//智能开启偏移 单位:分钟  智能开启时有效
@property (nonatomic, assign) UInt8 hour;//时
@property (nonatomic, assign) UInt8 minute;//分
/*重复
 周1-7 开关(0-6位) 0:关， 1:开
 全0表示单次闹钟,设置时间戳作为过期标准
 */
@property (nonatomic, assign) UInt8 flag;
@property (nonatomic, assign) UInt8 snoozeTime;//贪睡次数
@property (nonatomic, assign) UInt8 snoozeLength;//贪睡时长
@property (nonatomic, assign) UInt8 volume;//音量大小 0-16
@property (nonatomic, assign) UInt8 brightness;//亮度 0-100
@property (nonatomic, assign) UInt16 musicID;//音乐ID
@property (nonatomic, assign) UInt32 timestamp;//时间戳 设置/修改闹钟时的标准时间戳（用于单次闹钟）
@property (nonatomic, assign) UInt8 enable;//是否有效 0表示该闹钟已经删除 1该闹钟有效 ，删除闹钟使用该接口，将该字段设置为0

@end

NS_ASSUME_NONNULL_END
