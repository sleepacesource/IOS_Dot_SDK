//
//  SLPSceneObject.h
//  Sleepace
//
//  Created by Martin on 8/18/16.
//  Copyright © 2016 com.medica. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SLPCommon/SLPCommon.h>

typedef NS_ENUM(NSInteger,SLPSceneConfigType) {
    SLPSceneConfigType_Sleep = 0,//睡觉场景类型
    SLPSceneConfigType_Light,//照明场景类型(特殊设备场景，单独出来)
    SLPSceneConfigType_Common,//普通设备场景类型
};

typedef NS_ENUM(int64_t,SLPSceneUniqueID) {
    SLPAlarmUniqueID = 98,//闹钟
    SLPDiscoverSceneUniqueID = 99,//发现
    SLPSleepSceneUniqueID = 100,//睡觉场景
    SLPLightSceneUniqueID = 101,//照明场景
    SLPReadingSceneUniqueID = 102,//阅读场景
    SLPAtmosphereSceneUniqueID = 103,//氛围场景
    SLPCustomSceneUniqueID,//自定义场景
};

@interface SLPSceneObject : NSObject
@property (nonatomic,assign) SLPSceneUniqueID sceneID;//8个字节
@property (nonatomic,assign) SLPSceneConfigType sceneType;//1个字节
- (id)initWithData:(NSData *)data;
+ (NSInteger)length;
@end
