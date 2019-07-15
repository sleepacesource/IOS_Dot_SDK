//
//  SLPBLESentPacketV_0.h
//  Sleepace
//
//  Created by Martin on 6/7/16.
//  Copyright © 2016 com.medica. All rights reserved.
//

#import "SLPBLEBaseSendPacket.h"

@interface SLPBLESendPacketV_0 : SLPBLEBaseSendPacket
@property (nonatomic, assign) int messageSequence;//消息序号
@end
