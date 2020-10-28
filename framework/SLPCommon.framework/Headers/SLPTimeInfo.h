//
//  SLPTimeInfo.h
//  SDK
//
//  Created by Martin on 2018/3/1.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLPTimeInfo : NSObject
@property (nonatomic, assign) UInt32 timestamp;//时间戳
@property (nonatomic, assign) int32_t timezone;//时区偏移信息，单位：秒
@property (nonatomic, assign) UInt8 season;//特殊时令 0:无,1:夏令时,2:冬令时
@property (nonatomic, assign) int32_t offset;//特殊时令偏移 偏移信息，单位：秒
@property (nonatomic, assign) UInt8 timeMode;//12：12小时制 24：24小时制

@end
