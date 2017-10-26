//
//  SLPUnderlineButton.h
//  Sleepace
//
//  Created by San on 16/7/12.
//  Copyright © 2016年 com.medica. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLPUnderlineButton : UIButton
{
    UIColor *lineColor;
    
    CGFloat lineOfWidth;
}

@property (assign,nonatomic) CGFloat lineWidth;
- (void)setColor:(UIColor*)color;
- (void)setLineWidth:(CGFloat)lineWidth;
@end
