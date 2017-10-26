//
//  FixTimeView.m
//  MAIDIJIA
//
//  Created by medica_mac on 15-1-28.
//  Copyright (c) 2015年 chenchangrong. All rights reserved.
//

#import "FixTimeView.h"
#import "FixView.h"
#import "SleepView.h"
#import "ToolKit.h"

@implementation FixTimeView

@synthesize startDate,endDate,iTimeZone,timeInterval,space;
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [self createFont];
}


#pragma mark --public

//画文字
- (void)createFont
{
    
//    NSDictionary *dict = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:11],
//                           NSForegroundColorAttributeName:[ToolKit colorFromHexRGB:@"ffffff" alpha:0.8],
//                           NSStrokeWidthAttributeName:@-3,
//                           NSStrokeColorAttributeName:[ToolKit colorFromHexRGB:@"ffffff" alpha:0.8]
//                           };
    NSDictionary *dict = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:11],
                           NSForegroundColorAttributeName:[UIColor lightGrayColor],
                           NSStrokeWidthAttributeName:@-3,
                           NSStrokeColorAttributeName:[UIColor lightGrayColor]
                           };
    
    
    float fontWidth = (self.superview.frame.size.width / kColCout);//文字宽度
    for (int i = 0; i < kColCout +1; i++)
    {
        NSDate *date = [NSDate dateWithTimeInterval:(i * fontWidth + space) * timeInterval sinceDate:startDate];
        NSString *strDate = [ToolKit dateToNSString:date withFormat:@"h:mm" timeZone:iTimeZone];
        
        CGFloat x = 0;
        if (i == 0)
        {
            x = 4;
        }
        else if (i == kColCout)
        {
            x = i * fontWidth -3;
            
//            if (strDate.length == 5)//最后一列，超过5个，就不显示
//            {
//                continue;
//            }
        }
        else
        {
            x = i * fontWidth+3;
        }
        [strDate drawInRect:CGRectMake(x, 0, fontWidth, kFontHeight) withAttributes:dict];
    }
}


@end
