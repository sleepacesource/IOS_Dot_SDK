//
//  SLPHTTPManager.h
//  SDK
//
//  Created by Michael on 2020/5/28.
//  Copyright © 2020 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SLPAidInfo.h"
#import "SLPClockDormancyBean.h"
#import "SLPDataTransferDef.h"
#import "SLPAlarmInfo.h"
NS_ASSUME_NONNULL_BEGIN

#define SLPSharedHTTPManager [SLPHTTPManager sharedInstance]

@interface SLPHTTPManager : NSObject

@property (nonatomic,readonly) NSString *sid;
@property (nonatomic,readonly) NSString *urlString;
@property (nonatomic,readonly) NSString *channelID;

+(SLPHTTPManager*)sharedInstance;

/*
 *
 *初始化HTTP信息
 * @parameters 参数
 * {
 * url : @"HTTP地址,类型：String",
 * channelID : @"channelID值，类型：String"
 * }
 */
- (void)initHttpServiceInfo:(NSDictionary *)parameters;

/*
*授权
*@param token  token值
*@param timeoutInterval 超时时间（秒s）
*@param completion 授权回调，包含tcp连接信息
*/
- (void)authorize:(NSString *)token
          timeout:(CGFloat)timeoutInterval
       completion:(void (^)(BOOL result,id responseObject, NSString *error))completion;


/**
 *获取当前设备信息
 *@param timeoutInterval 超时时间（秒s）
 *@param completion 回调
 */
- (void)getBindedDeviceInformationWithTimeout:(CGFloat)timeoutInterval
                                   completion:(void (^)(NSInteger status,id responseObject, NSString *error))completion;

/**
 *绑定设备
 *@param deviceId 设备id
 *@param timeoutInterval 超时时间（秒s）
 *@param completion 回调
 */
- (void)bindDeviceWithDeviceId:(NSString *)deviceId
                                timeOut:(CGFloat)timeoutInterval
                             completion:(void (^)(BOOL result, NSDictionary *dict,NSString *error))completion;

/**
 *解绑设备
 *@param deviceId 设备id
 *@param timeoutInterval 超时时间（秒s）
 *@param completion 回调
 */
- (void)unBindDeviceWithDeviceId:(NSString *)deviceId
                               timeOut:(CGFloat)timeoutInterval
                            completion:(void (^)(BOOL result, NSString *error))completion;

/**
 *获取设备版本信息
 *@param parameters 传入参数字典，具体包含key见文档
 *@param timeoutInterval 超时时间（秒s）
 *@param completion 回调
 */
- (void)getDeviceVersionWithParameters:(NSDictionary *)parameters
                               timeout:(CGFloat)timeoutInterval
                            completion:(void (^)(BOOL result,id responseObject, NSString *error))completion;

/**
 *闹钟配置
 *@param parameters 传入参数字典，具体包含key见文档
 *@param deviceName 设备名
 *@param deviceType 设备类型
 *@param timeout 超时时间（秒s）
 *@param completion 回调
 */
- (void)alarmConfigWithParameters:(NSDictionary *)parameters
                       deviceInfo:(NSString *)deviceName
                       deviceType:(SLPDeviceTypes)deviceType
                          timeOut:(CGFloat)timeout
                       completion:(void (^)(BOOL result,id responseObject, NSString *error))completion;

/**
 *时钟休眠配置
 *@param parameters 传入参数字典，具体包含key见文档
 *@param deviceName 设备名
 *@param timeout 超时时间（秒s）
 *@param completion 回调
 */
- (void)configClockDormancyWithParameters:(NSDictionary *)parameters deviceInfo:(NSString *)deviceName timeOut:(CGFloat)timeout completion:(void (^)(BOOL result,id responseObject, NSString *error))completion;

/**
 *助眠配置
 *@param parameters 传入参数字典，具体包含key见文档
 *@param deviceName 设备名
 *@param deviceType 设备类型
 *@param timeout 超时时间（秒s）
 *@param completion 回调
 */
- (void)configAidInfoWithParameters:(NSDictionary *)parameters deviceInfo:(NSString *)deviceName deviceType:(SLPDeviceTypes)deviceType  timeout:(CGFloat)timeout completion:(void (^)(BOOL result,id responseObject, NSString *error))completion;

/**
 *获取助眠配置
 *@param deviceName 设备名
 *@param deviceType 设备类型
 *@param timeout 超时时间（秒s）
 *@param completion 回调
 */
- (void)getAidInfoWithDeviceInfo:(NSString *)deviceName deviceType:(SLPDeviceTypes)deviceType timeOut:(CGFloat)timeout completion:(void (^)(BOOL result,id responseObject, NSString *error))completion;

/**
 *获取时钟休眠
 *@param deviceName 设备名
 *@param timeout 超时时间（秒s）
 *@param completion 回调
 */
- (void)getClockDormancyWithDeviceInfo:(NSString *)deviceName timeOut:(CGFloat)timeout completion:(void (^)(BOOL result,id responseObject, NSString *error))completion;

/**
 *删除闹钟
 *@param alarmID 闹钟id
 *@param deviceName 设备名
 *@param deviceType 设备类型
 *@param timeout 超时时间（秒s）
 *@param completion 回调
 */
- (void)deleteAlarmWithAlarmID:(NSInteger)alarmID deviceInfo:(NSString *)deviceName deviceType:(SLPDeviceTypes)deviceType  timeout:(CGFloat)timeout completion:(void (^)(BOOL result,id responseObject, NSString *error))completion;

/**
 *闹钟配置
 *@param parameters 传入参数字典，具体包含key见文档
 *@param deviceName 设备名
 *@param deviceType 设备类型
 *@param timeout 超时时间（秒s）
 *@param completion 回调
 */
- (void)configAlarmInfoWithParameters:(NSDictionary *)parameters deviceInfo:(NSString *)deviceName deviceType:(SLPDeviceTypes)deviceType  timeout:(CGFloat)timeout completion:(void (^)(BOOL result,id responseObject, NSString *error))completion;

/**
 *获取闹钟列表
 *@param deviceName 设备名
 *@param deviceType 设备类型
 *@param timeout 超时时间（秒s）
 *@param completion 回调
 */
- (void)getAlarmListWithDeviceInfo:(NSString *)deviceName deviceType:(SLPDeviceTypes)deviceType timeOut:(CGFloat)timeout completion:(void (^)(BOOL result,id responseObject, NSString *error))completion;

/**
 * 修改定时香薰 有则改，无则加
 *@param parameters 传入参数字典，具体包含key见文档
 *@param deviceName 设备名
 *@param deviceType 设备类型
 *@param timeout 超时时间（秒s）
 *@param completion 回调
 */
- (void)configTimeAromaInfoWithParameters:(NSDictionary *)parameters deviceInfo:(NSString *)deviceName deviceType:(SLPDeviceTypes)deviceType  timeout:(CGFloat)timeout completion:(void (^)(BOOL result,id responseObject, NSString *error))completion;

/**
 *获取定时香薰
 *@param deviceName 设备名
 *@param deviceType 设备类型
 *@param timeout 超时时间（秒s）
 *@param completion 回调
 */
- (void)getTimeAromaListWithDeviceInfo:(NSString *)deviceName deviceType:(SLPDeviceTypes)deviceType timeOut:(CGFloat)timeout completion:(void (^)(BOOL result,id responseObject, NSString *error))completion;

/**
 *删除定时香薰
 *@param aromatherapyId 定时香薰id
 *@param deviceName 设备名
 *@param deviceType 设备类型
 *@param timeout 超时时间（秒s）
 *@param completion 回调
 */
- (void)deleteTimeAromaWithID:(NSInteger)aromatherapyId deviceInfo:(NSString *)deviceName deviceType:(SLPDeviceTypes)deviceType  timeout:(CGFloat)timeout completion:(void (^)(BOOL result,id responseObject, NSString *error))completion;

/**
 *配置中心健
 *@param parameters 传入参数字典，具体包含key见文档
 *@param deviceName 设备名
 *@param deviceType 设备类型
 *@param timeout 超时时间（秒s）
 *@param completion 回调
 */
- (void)configCenterKeyWithParameters:(NSDictionary *)parameters deviceInfo:(NSString *)deviceName deviceType:(SLPDeviceTypes)deviceType  timeout:(CGFloat)timeout completion:(void (^)(BOOL result,id responseObject, NSString *error))completion;

/**
 *获取中心键
 *@param deviceName 设备名
 *@param deviceType 设备类型
 *@param timeout 超时时间（秒s）
 *@param completion 回调
 */
- (void)getCenterKeyWithDeviceInfo:(NSString *)deviceName deviceType:(SLPDeviceTypes)deviceType timeOut:(CGFloat)timeout completion:(void (^)(BOOL result,id responseObject, NSString *error))completion;

/**
 *配置小夜灯
 *@param parameters 传入参数字典，具体包含key见文档
 *@param deviceName 设备名
 *@param deviceType 设备类型
 *@param timeout 超时时间（秒s）
 *@param completion 回调
 */
- (void)configNightLightWithParameters:(NSDictionary *)parameters deviceInfo:(NSString *)deviceName deviceType:(SLPDeviceTypes)deviceType  timeout:(CGFloat)timeout completion:(void (^)(BOOL result,id responseObject, NSString *error))completion;

/**
 *获取小夜灯
 *@param deviceName 设备名
 *@param deviceType 设备类型
 *@param timeout 超时时间（秒s）
 *@param completion 回调
 */
- (void)getNightLightWithDeviceInfo:(NSString *)deviceName deviceType:(SLPDeviceTypes)deviceType timeOut:(CGFloat)timeout completion:(void (^)(BOOL result,id responseObject, NSString *error))completion;

/**
*获取日报告
*@param param 传入参数字典
*@param timeout 超时时间（秒s）
*@param completion 回调
*/

/**param字典格式
   param = @{
 @"startTime":（Integer）开始时间戳,
 @"num":（Int）返回记录数目，@"order":(Int)返回数据顺序，0降序，1升序，
 @"deviceType: 设备类型"
 }
*/
- (void)getDailyReport:(NSDictionary *)param timeOut:(CGFloat)timeout completion:(void (^)(BOOL result,id responseObject, NSString *error))completion;

/**
*获取日报告带分数
*@param param 传入参数字典
*@param timeout 超时时间（秒s）
*@param completion 回调
*/

/**param字典格式
   param = @{
 @"startTime":（Integer）开始时间戳,
 @"endTime":（Integer）截止时间戳，@"dateFormate":(String)返回日期格式，
 @"deviceType: 设备类型"
 }
*/
- (void)getReportScore:(NSDictionary *)param timeOut:(CGFloat)timeout completion:(void (^)(BOOL result,id responseObject, NSString *error))completion;


@end

NS_ASSUME_NONNULL_END
