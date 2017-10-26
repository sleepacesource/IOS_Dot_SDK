//
//  HeartCurveView.h
//  Profession
//
//  Created by medica_mac on 15/7/24.
//  Copyright (c) 2015年 com.medica. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeartCurveView : UIView
//@property (nonatomic,strong)NSMutableArray *heartPoints;
@property (nonatomic,strong)NSMutableArray *firstHeartPoints;
@property (nonatomic,strong)NSMutableArray *secondHeartPoints;

@property (nonatomic)BOOL needClean;
@property (nonatomic)CGRect clearRect;
@property (nonatomic)BOOL isFullScreen;
@property (nonatomic)CGFloat x_count;
@property (nonatomic)long long interval;
@property (nonatomic)BOOL isFirstCopy;
@end
