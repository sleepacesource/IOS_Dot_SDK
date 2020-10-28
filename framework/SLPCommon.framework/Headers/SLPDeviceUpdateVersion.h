//
//  SLPDeviceUpdateVersion.h
//  SLPCommon
//
//  Created by Michael on 2020/6/6.
//  Copyright © 2020 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLPDeviceUpdateVersion : NSObject

@property (nonatomic, copy) NSString *version;//设备版本号
@property (nonatomic, assign) NSInteger deviceType;//设备类型
@property (nonatomic, copy) NSString *des;//描述
@property (nonatomic, copy) NSString *url;//升级链接
@property (nonatomic, assign) NSInteger fileLen;
@property (nonatomic, assign) NSInteger crcBin;
@property (nonatomic, assign) NSInteger crcDes;


@end

NS_ASSUME_NONNULL_END
