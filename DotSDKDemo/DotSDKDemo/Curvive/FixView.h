//
//  FixView.h
//  test
//
//  Created by medica_mac on 14-9-11.
//  Copyright (c) 2014年 lcq. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kSleepViewGridHeight 28//55 //格子高度
#define kColCout 7//竖格数
#define kRowCout 5//横格数
#define kFontWidth 15//23//文字宽度
#define kFontHeight 13//文字高度
#define kDetailStatusWidth  28.0

@class SleepView;

@interface FixView : UIView
@property (nonatomic, strong)NSMutableArray *times;
@property (nonatomic)CGFloat x;
@property (nonatomic)CGFloat compress ;//上下压缩倍数
@property (nonatomic)CGFloat scale;//缩放倍数
@property (nonatomic,strong)SleepView *sleepView;

-(void)initDateTime:(NSNumber *)fromtime timeInterval:(NSNumber *)timeInterval timeZone:(int)timeZone;

@end
