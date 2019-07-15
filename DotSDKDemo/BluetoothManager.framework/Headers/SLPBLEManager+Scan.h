//
//  SLPBLEManager+Scan.h
//  Sleepace
//
//  Created by Martin on 7/13/16.
//  Copyright © 2016 com.medica. All rights reserved.
//

#import "SLPBLEManager.h"
#import "SLPBLEDef.h"

//扫描蓝牙
typedef NS_ENUM(int,SLPBleConnectStatus) {
    SLPBleConnectStatus_Connected = 0,
    SLPBleConnectStatus_Connecting,//正在连接
    SLPBleConnectStatus_Disconnected,//连接断开
};

@interface SLPBLEManager (Scan)

//停止单个扫描
- (void)stopScanHandle:(NSInteger)handleID;
//扫描设置
- (BOOL)scanBluetoothWithTimeoutInterval:(CGFloat)timeOutInterval completion:(SLPBLEScanHandle)handle;

//蓝牙是否打开
- (BOOL)blueToothIsOpen;
/*-1 未知
 0 disable
 1 enable
 */
- (NSInteger)blueToothStatus;

///停止所有扫描
- (void)stopAllPeripheralScan;

//断开连接
- (BOOL)disconnectPeripheral:(CBPeripheral *)peripheral timeout:(CGFloat)timeout completion:(SLPBLEDisconnectHandle)handle;
//判断蓝牙是否连接
- (BOOL)peripheralIsConnected:(CBPeripheral *)peripheral;

//查询设备连接状态
- (SLPBleConnectStatus)checkDeviceConnecteStatus:(NSString *)deviceName;
//通过设备查询连接状态
- (SLPBleConnectStatus)checkPeripheralConnecteStatus:(CBPeripheral *)peripheral;

- (void)_checkScan;
@end

@class CBPeripheral;
@interface SLPPeripheralInfo : NSObject
@property (nonatomic,strong) CBPeripheral *peripheral;
@property (nonatomic,copy) NSString *name;
@end
