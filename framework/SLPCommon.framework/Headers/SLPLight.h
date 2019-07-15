//
//  SLPLight.h
//  SDK
//
//  Created by Martin on 2018/3/1.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLPLight : NSObject
@property (nonatomic, assign) UInt8 r;
@property (nonatomic, assign) UInt8 g;
@property (nonatomic, assign) UInt8 b;
@property (nonatomic, assign) UInt8 w;

- (NSData *)data;
@end
