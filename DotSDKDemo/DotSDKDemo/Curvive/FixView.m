//
//  FixView.m
//  test
//
//  Created by medica_mac on 14-9-11.
//  Copyright (c) 2014年 lcq. All rights reserved.
//

#import "FixView.h"
#import "SleepView.h"
#import "FixTimeView.h"
#import "ToolKit.h"

@implementation FixView
{
    NSDate *_startDate;
    NSDate *_endDate;
    BOOL hadCreateGrid;
    int iTimeZone;
    FixTimeView *ftView;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.compress = 1.0;
        
        CGFloat fontWidth = self.frame.size.width / kColCout;
        ftView = [[FixTimeView alloc] initWithFrame:CGRectMake(-fontWidth/2.0 + 3, -2, self.frame.size.width + fontWidth, kFontHeight)];
        ftView.backgroundColor = [UIColor clearColor];
        [self addSubview:ftView];
        
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    [self createGrid];
    [self createFontWithStartTime:_startDate endTime:_endDate];
}
#pragma mark --public

-(void)initDateTime:(NSNumber *)fromtime timeInterval:(NSNumber *)timeInterval timeZone:(int)timeZone
{
    int second = [fromtime intValue];
    NSDate *originDate = [NSDate dateWithTimeIntervalSince1970:second];
    NSString *string = [ToolKit dateToNSString:originDate withFormat:@"yyyy-MM-dd HH:mm" timeZone:timeZone];
    _startDate = [ToolKit stringToNSDate:string withFormat:@"yyyy-MM-dd HH:mm" timeZone:timeZone];
    _endDate = [[NSDate alloc] initWithTimeInterval:([timeInterval doubleValue] * 60) sinceDate:_startDate];
    iTimeZone = timeZone;
}
#pragma mark --private
//画文字
- (void)createFontWithStartTime:(NSDate *)startDate endTime:(NSDate *)endDate
{
    ftView.startDate = startDate;
    ftView.endDate = endDate;
    ftView.space = self.x;
    ftView.iTimeZone = iTimeZone;
    ftView.timeInterval = [endDate timeIntervalSinceDate:startDate]/self.sleepView.frame.size.width;//计算每份宽度的时间值
    [ftView setNeedsDisplay];
    
    return;
    
#if 0
    if (self.sleepView == nil)
    {
        return;
    }
    
    NSDictionary *dict = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:11],
                           NSForegroundColorAttributeName:[ToolKit colorFromHexRGB:@"ffffff" alpha:0.8],
                           NSStrokeWidthAttributeName:@-3,
                           NSStrokeColorAttributeName:[ToolKit colorFromHexRGB:@"ffffff" alpha:0.8]
                           };

    NSTimeInterval timeInterval = [endDate timeIntervalSinceDate:startDate]/self.sleepView.frame.size.width;//计算每份宽度的时间值
//    NSLog(@"self.sleepView.frame.size.width=%f", self.sleepView.frame.size.width);
//    NSLog(@"timeInterval=%f", timeInterval);
    
    float fontWidth = (self.frame.size.width / kColCout);//文字宽度
    for (int i = 0; i < kColCout +1; i++)
    {
        NSDate *date = [NSDate dateWithTimeInterval:(i * fontWidth + self.x) * timeInterval sinceDate:startDate];
        NSString *strDate = [ToolKit dateToNSString:date withFormat:@"h:mm" timeZone:iTimeZone];
        
        CGFloat x = 0;
        if (i == 0)
        {
            x = 0;
        }
        else if (i == kColCout)
        {
            x = (i-1) * fontWidth + fontWidth/2 - 2;
            
            if (strDate.length == 5)//最后一列，超过5个，就不显示
            {
//                continue;
            }
        }
        else
        {
            x = i * fontWidth - fontWidth/2.f + 10;
        }
        [strDate drawInRect:CGRectMake(x, 0, fontWidth, kFontHeight) withAttributes:dict];
    }
#endif
}

//画方格子
- (void)createGrid
{
    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetRGBStrokeColor(context, 240.0/255, 248.0/255, 255.0/255, 0.1);
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGContextSetLineWidth(context, 0.7);
    
    CGFloat yGap = 5;
    CGFloat yOffset = kFontHeight + yGap;
    //横线
    for (int i = 0; i < kRowCout + 1; i++)
    {
        float y = (yOffset + i * ((self.frame.size.height - yOffset)/kRowCout)) ;
        CGContextMoveToPoint(context, 0, y);
        CGContextAddLineToPoint(context, self.frame.size.width, y);
    }
    
    
    float w = (self.frame.size.width / kColCout);//竖线间隔
    //竖线
    for (int i = 0; i < kColCout + 1; i++)
    {
        float x = i * w ;
//        float y = self.frame.size.height;
        CGContextMoveToPoint(context, x, yOffset);
        CGContextAddLineToPoint(context, x, self.frame.size.height);
    }
    CGContextDrawPath(context, kCGPathStroke);
}

@end

