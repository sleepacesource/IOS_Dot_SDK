//
//  SLPUnderlineButton.m
//  Sleepace
//
//  Created by San on 16/7/12.
//  Copyright © 2016年 com.medica. All rights reserved.
//

#import "SLPUnderlineButton.h"

@implementation SLPUnderlineButton

- (id)init
{
    self=[super init];
    if (self) {
        
    }
    
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        
    }
    
    return  self;
}


- (void)setColor:(UIColor *)color
{
    lineColor=[color copy];
    
    [self setNeedsDisplay];
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    lineOfWidth=lineWidth;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGRect textRect = self.titleLabel.frame;
    CGRect buttonRect=self.frame;
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    if([lineColor isKindOfClass:[UIColor class]]){
        if (lineColor) {
            CGContextSetStrokeColorWithColor(contextRef, lineColor.CGColor);
        }else{
            CGContextSetStrokeColorWithColor(contextRef, [UIColor whiteColor].CGColor);
        }
    }
    
    CGFloat w=1.0;
    if (lineOfWidth) {
        w=lineOfWidth;
    }
    CGContextSetLineWidth(contextRef, w);
    CGContextMoveToPoint(contextRef, textRect.origin.x,  buttonRect.size.height-w-5);
    CGContextAddLineToPoint(contextRef, textRect.origin.x + textRect.size.width, buttonRect.size.height-w-5);
    CGContextClosePath(contextRef);
    CGContextDrawPath(contextRef, kCGPathStroke);
}

@end
