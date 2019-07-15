//
//  SLPBaseMusicModel.h
//  Sleepace
//
//  Created by Shawley on 30/12/2016.
//  Copyright © 2016 com.medica. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(UInt8,SLPDeviceMusicType) {
    SLPDeviceMusicType_Local = 0,//本地音乐
    SLPDeviceMusicType_External,//外部音乐
    SLPDeviceMusicType_XMLY_Album,//喜马拉雅专辑
    SLPDeviceMusicType_XMLY_Track,//喜马拉雅单曲
    SLPDeviceMusicType_SLP_Album,//Sleepace专辑(混合)
    SLPDeviceMusicType_SLP_Track,//Sleepace单曲
    SLPDeviceMusicType_XMLY_List,//喜马拉雅列表
    SLPDeviceMusicType_SLP_List,//Sleepace列表
    
    SLPDeviceMusicType_None,
};

typedef NS_ENUM(UInt8, MusicCirclePlay) {
    MusicCirclePlay_ON = 0x00,
    MusicCirclePlay_OFF,
};

//专辑音乐播放模式
typedef NS_ENUM(UInt8, SLPAlbumMusicPlayMode) {
    SLPAlbumMusicPlayMode_Sequence = 0, //顺序
    SLPAlbumMusicPlayMode_Random, //随机
    SLPAlbumMusicPlayMode_Single, //单曲
};

//单曲音乐类型
typedef NS_ENUM(UInt8, SLPSingleMusicType) {
    SLPSingleMusicType_Local = 0,
    SLPSingleMusicType_XMLY, //XMLY
    SLPSingleMusicType_Sleepace,//Sleepace
};

@interface SLPBaseMusicModel : NSObject
//单曲编号
@property (nonatomic,assign) NSInteger musicID;
@property (nonatomic,assign) SLPDeviceMusicType musicType;
@property (nonatomic,assign) MusicCirclePlay circle;

- (SLPAlbumMusicPlayMode)playMode ;
+ (NSInteger)lenth;
//音乐结构长度
+ (NSInteger)lenthWithType:(SLPDeviceMusicType)type;

+ (id)musicModelWithMusicType:(SLPDeviceMusicType)musicType data:(NSData *)data;

- (void)fillWithData:(NSData *)data;

@end

//喜马拉雅单曲
@interface SLPXMLYSingleMusicModel : SLPBaseMusicModel

@end

//Sleepace单曲
@interface SLPSleepaceSingleMusicModel : SLPBaseMusicModel

@property (nonatomic,assign) SLPSingleMusicType type;

@end

//喜马拉雅／Sleepace专辑
@interface SLPAlbumMusicModel : SLPBaseMusicModel
//专辑编号
@property (nonatomic,assign) UInt32 albumID;
//开始序号
@property (nonatomic,assign) UInt16 startNum;
//播放模式
@property (nonatomic,assign) SLPAlbumMusicPlayMode playMode;

@end
