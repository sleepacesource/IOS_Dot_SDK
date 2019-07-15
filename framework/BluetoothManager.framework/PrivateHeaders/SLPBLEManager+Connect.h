//
//  SLPBLEManager+Connect.h
//  Sleepace
//
//  Created by Martin on 7/13/16.
//  Copyright © 2016 com.medica. All rights reserved.
//

#import "SLPBLEManager.h"
#import "SLPBLEDef.h"
#import <SLPCommon/SLPCommon.h>
#import <Foundation/Foundation.h>

@class CBPeripheral;
@interface SLPBLEManager (Connect)
- (BOOL)connectPeripheral:(CBPeripheral *)peripheral deviceCode:(NSString *)deviceCode deviceName:(NSString*)deviceName timeout:(CGFloat)timeout completion:(SLPBLEConnectHandle)handle;

- (BOOL)connectPeripheral:(CBPeripheral *)peripheral deviceType:(SLPDeviceTypes)deviceType timeout:(CGFloat)timeout completion:(SLPBLEConnectHandle)handle;
@end
