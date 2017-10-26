//
//  HeartCurveView.m
//  Profession
//
//  Created by medica_mac on 15/7/24.
//  Copyright (c) 2015年 com.medica. All rights reserved.
//

#import "HeartCurveView.h"

@implementation HeartCurveView
{
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.firstHeartPoints = [NSMutableArray array];
        self.secondHeartPoints = [NSMutableArray array];
        self.x_count = 0;
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctx, rect);
    
    [self createCurveWithPoints:self.firstHeartPoints];
    [self createCurveWithPoints:self.secondHeartPoints];
}

// 画曲线
- (void)createCurveWithPoints:(NSMutableArray *)points
{
    if (points.count)
    {
        UIBezierPath* path = [UIBezierPath bezierPath];
        
        [path moveToPoint:[points[0] CGPointValue]];
        
        for (int i = 0; i < points.count; i++)
        {
            [path addLineToPoint:[(NSValue *)points[i] CGPointValue]];
        }
        [[UIColor colorWithRed:51.0/255.0 green:153/255.0 blue:251/255.0 alpha:1.0]setStroke];
        path.lineCapStyle = kCGLineCapRound;
        path.lineJoinStyle = kCGLineJoinRound;
        path.flatness = 1;
        path.lineWidth = 0.8;
        [path stroke];
    }
}

@end
