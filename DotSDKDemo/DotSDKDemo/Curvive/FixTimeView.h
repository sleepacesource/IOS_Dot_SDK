//
//  FixTimeView.h
//  MAIDIJIA
//
//  Created by medica_mac on 15-1-28.
//  Copyright (c) 2015年 chenchangrong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FixTimeView : UIView

@property (nonatomic,strong) NSDate *startDate;
@property (nonatomic,strong) NSDate *endDate;

@property (nonatomic) int iTimeZone;

@property (nonatomic) NSTimeInterval timeInterval;

@property (nonatomic) CGFloat space;


@end
