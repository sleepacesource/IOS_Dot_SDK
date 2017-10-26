//
//  UserObj.h
//  MAIDIJIA
//
//  Created by Yajie Deng on 14-9-1.
//  Copyright (c) 2014年 chenchangrong. All rights reserved.
//  jhh_报告相关_日报告模型

#import <Foundation/Foundation.h>
typedef enum
{
    lessD = 1,//温度
    equalD = 2,//湿度
    moreD = 3,//噪音
}dayCompare;

typedef NS_ENUM(NSInteger,SLPSleepScoreGrades) {
    SLPSleepScoreGrades_Bad = 0,//坏
    SLPSleepScoreGrades_General,//一般
    SLPSleepScoreGrades_Good,//好
    SLPSleepScoreGrades_VeryGood,//非常好
};

typedef NS_ENUM(NSInteger,SLPSleepBodyMovementGrades) {
    SLPSleepBodyMovementGrades_Poor,
    SLPSleepBodyMovementGrades_Insufficient,
    SLPSleepBodyMovementGrades_Regular,
    SLPSleepBodyMovementGrades_Irregular,
    SLPSleepBodyMovementGrades_Restless,
};

@interface UserObj : NSObject
/**
 * 长、短报告标识，1长报告  2短报告
 */
@property (nonatomic,strong)NSNumber *reportFlag;
@property (nonatomic,strong)NSNumber *InvalidFlag;///数据是否有效
@property(nonatomic,strong)NSNumber  *farmlyID;
@property(nonatomic,strong)NSNumber  *memID;
@property(nonatomic,strong)NSString  *date;
@property(nonatomic,strong)NSNumber  *timezone;  //时区(秒)
@property(nonatomic,strong)NSNumber  *duration;  //睡眠总时长
@property(nonatomic,strong)NSNumber  *startTime;//上床时间

@property(nonatomic,strong)NSNumber  *score;   //睡眠评分

//************
//李明算法中出的是百分比,原数据库中的是原始数据.故二者同时保留
@property(nonatomic,strong)NSNumber  *light;  //轻睡眠
@property(nonatomic,strong)NSNumber  *rem;   //中睡眠
@property(nonatomic,strong)NSNumber  *deep;  //深睡眠
@property(nonatomic,strong)NSNumber  *wake;  //清醒

//李明新增:
@property(nonatomic,strong)NSNumber *MdDeepSleepPerc;//深睡眠百分比
@property(nonatomic,strong)NSNumber *MdRemSleepPerc;//中睡百分比
@property(nonatomic,strong)NSNumber *MdLightSleepPerc;//浅睡百分比
@property(nonatomic,strong)NSNumber *MdWakeSleepPerc;//清醒百分比
@property (nonatomic,strong)NSNumber *MdWakeUpTime;//起床前的那段清醒时间
//@property (nonatomic,strong)NSNumber *mdSleepAllTime;//实际睡觉总时长，除掉入睡时间和清醒时间。
//*************

@property(nonatomic,strong)NSNumber  *wake_times;  //清醒次数
@property(nonatomic,strong)NSNumber  *hxztcs;  //呼吸暂停总次数
@property(nonatomic,strong)NSNumber  *hxztsc; //呼吸暂停时长
@property(nonatomic,strong)NSNumber  *xtztcs; //心跳暂停总次数
@property(nonatomic,strong)NSNumber  *xtztsc; //心跳暂停时长
@property(nonatomic,strong)NSNumber  *lccs;   //离床次数

@property(nonatomic,strong)NSNumber  *lcsc; //离床时间长
@property(nonatomic,strong)NSNumber  *tdcs; // 体动次数
@property(nonatomic,strong)NSNumber  *fscs; //翻身次数
@property(nonatomic,strong)NSNumber  *pjxl;  //平均心率
@property(nonatomic,strong)NSNumber  *pjhxl; //平均呼吸率

@property(nonatomic,strong)NSNumber  *zgxl;   //最高心率
@property(nonatomic,strong)NSNumber  *zghxl;   //最高呼吸率
@property(nonatomic,strong)NSNumber  *zdxl;    //最低心率
@property(nonatomic,strong)NSNumber  *zdhxl;    //最低呼吸率
@property(nonatomic,strong)NSNumber  *xtgssc;    //心跳过速时长

@property(nonatomic,strong)NSNumber  *xtghsc;  //心跳过缓时长
@property(nonatomic,strong)NSNumber  *hxgssc;  //呼吸过速时长
@property(nonatomic,strong)NSNumber  *hxghsc;  //呼吸过缓时长

@property(nonatomic,strong)NSNumber  *timeStep;     //时间步
@property(nonatomic,strong)NSNumber  *recordCount;  //总记录数
@property(nonatomic,strong)NSNumber  *stopMode;     //结束方式
@property(nonatomic,strong)NSNumber  *isupload;////1 已经上传云端，2 未上传云端

@property(nonatomic,strong)NSString  *breathRateString;//呼吸数据,用于创建每分钟呼吸曲线图
@property(nonatomic,strong)NSString  *heartRateString;
@property(nonatomic,strong)NSString  *statusString;
@property(nonatomic,strong)NSString  *statusValueString;//各个状态持续时间,(秒)
@property(nonatomic,strong)NSString  *sleepStateStr;//睡眠状态分期
@property(nonatomic,strong)NSString  *motionIntensityArrString;//体动强度(枕扣/手机监测才有)

@property(nonatomic,strong)NSNumber  *asleepTime;//入睡所花时间

@property(nonatomic,strong)NSString *weekday;
@property(nonatomic,strong)NSString *week;
@property(nonatomic,strong)NSString *month;
@property(nonatomic,strong)NSString *year;
@property (nonatomic,strong)NSArray *deductionName;//扣分项名称
@property (nonatomic,strong)NSArray *deductionValue;//扣分值
@property (nonatomic,strong)NSString *devId;//这份数据对应的设备ID号

//睡眠效率(仅当手机监测时才有)
@property (nonatomic,strong)NSNumber *SleepEfficient;

//体动等级(仅当手机监测时才有)(-2:极少:监测失败；-1:过少:信息丢失；+0:正常；+1:过多:躁动不安；+2:极多:严重躁动不安)
@property (nonatomic,strong)NSNumber *bodyMoveLevel;

//luna灯的环境数据
@property(nonatomic,strong)NSMutableArray *eHumidityArray;
@property(nonatomic,strong)NSMutableArray *eLightArray;
@property(nonatomic,strong)NSMutableArray *eNoiseArray;
@property(nonatomic,strong)NSMutableArray *eTempArray;
@property(nonatomic,strong)NSMutableArray *co2Array;
@property(nonatomic,strong)NSMutableArray *mHumidityArray;
@property(nonatomic,strong)NSMutableArray *mTempArray;



//上床时间,格式为(HH:MM")
@property(nonatomic,strong)NSString *bedTimeStr;

//清醒时间,格式为(HH:MM")
@property(nonatomic,strong)NSString *wakeUpTimeStr;

//起床时间,格式为(HH:MM")
@property (nonatomic,strong)NSString *getUpTimeStr;

//算法版本号
@property(nonatomic,strong)NSString *arithmeticVer;

//数据来源 (-1:app 1:Reston 2:Nox环境参数,3:枕头 )
@property (nonatomic,strong)NSNumber *source;

//睡眠状态曲线(0 - 3)(NSArray 转JSON str)
@property (nonatomic,strong)NSString *SleepCurveStr;

//睡眠曲线中的各类状态(离床&心率呼吸异常等标记)用于配合SleepCurveStr在日报告中画睡眠曲线图
@property (nonatomic,strong)NSString *sleepCurveStatusStr;

//数据异常标记(数据有效性标识，0-有效；1-体动极弱；2-体动极少；4|8-睡觉途中90分钟以上无体动导致截取错误。)
@property (nonatomic,strong)NSNumber *flaginvalid;

//仅枕扣报告有效,标记枕扣报告未被算法截取前的原始Startime,上传给算法组备用
@property (nonatomic,strong)NSNumber *originStartTime;

@property (nonatomic,readonly)SLPSleepScoreGrades sleepScoreGrades;
@property (nonatomic,readonly)SLPSleepBodyMovementGrades bodymovementGrades;

-(id )init;

/**
 *  非RestOn类型设备监测出的数据(如手机/枕扣监测),此类数据没心率呼吸离床
 *
 *  @return --
 */
- (BOOL)isNotRestOnSource;

//销毁
- (void)releaseMe;

@end
