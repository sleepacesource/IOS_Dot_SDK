//
//  SLPClockDormancyBean.h
//  SLPCommon
//
//  Created by Michael on 2020/6/6.
//  Copyright © 2020 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLPClockDormancyBean : NSObject

@property (nonatomic, assign) UInt8 flag;//闹钟休眠开关 0：关 1：开
@property (nonatomic, assign) UInt8 startHour;//闹钟休眠开始时间：小时
@property (nonatomic, assign) UInt8 startMin;//闹钟休眠开始时间：分钟
@property (nonatomic, assign) UInt8 endHour;//闹钟休眠结束时间：小时
@property (nonatomic, assign) UInt8 endMin;//闹钟休眠结束时间：分钟

@end

NS_ASSUME_NONNULL_END
