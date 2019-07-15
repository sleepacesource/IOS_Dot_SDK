//
//  SLPBLECommonHeads.h
//  SDK
//
//  Created by Martin on 17/3/31.
//  Copyright © 2017年 Martin. All rights reserved.
//

#ifndef SLPBLECommonHeads_h
#define SLPBLECommonHeads_h

#import <SLPCommon/SLPCommon.h>
#import "SLPBLECommon.h"
#import "SDCCPEnums.h"
#import "SLPBLEBaseEntity.h"
#import "SLPBLEManager+Connect.h"
#import "SLPBLEScanObject.h"
#import "SLPBaseMusicModel.h"
#import "SLPAudioPlayerCommon.h"

#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0)
#define CBCentralManagerStateUnknown   CBManagerStateUnknown
#define CBCentralManagerStateResetting   CBManagerStateResetting
#define CBCentralManagerStateUnsupported   CBManagerStateUnsupported
#define CBCentralManagerStateUnauthorized  CBManagerStateUnauthorized
#define CBCentralManagerStatePoweredOff  CBManagerStatePoweredOff
#define CBCentralManagerStatePoweredOn  CBManagerStatePoweredOn
#endif
#endif /* SLPBLECommonHeads_h */
