//
//  SleepView.m
//  test
//
//
// 
//

#import "SleepView.h"
#import "FixView.h"
#import "SBJson.h"
#import "Define.h"

//#import "ConstsConfig.h"

@implementation SleepView 
{
    ///呼吸暂停按钮集
    NSMutableArray *huxiBtnArray;
    
    ///心脏暂停按钮集
    NSMutableArray *heartStopBtnArray_;
    
    ///睡眠时长
    NSInteger sleepTime;
    
    ///曲线上所有的点的集合
    NSMutableArray *allCurvePoints;
    
    ///呼吸暂停的时间点
    NSMutableArray *huxiTimeArray;
    
    ///心脏暂停的时间点
    NSMutableArray *heartStopTimeArray_;
    
    ///简化数据点后离床点集合
    NSMutableArray *sampleLeavePoints;
    
    ///
    NSMutableArray *statusArray;
    
    ///
    CGFloat panScale;
    
    /// 是否已有可直接绘制的曲线数据
    BOOL isCurePointExist;
    
    /// 入睡点
    NSMutableArray *fallAsleepArr_;
    
    /// 清醒点
    NSMutableArray *awakeArr_;
    
    /// 呼吸暂停点
    NSMutableArray *breathStopArr_;
    
    /// 心跳暂停点
    NSMutableArray *heartStopArr_;
    
    /// 离床点
    NSMutableArray *leftBedArr_;
    
}

@synthesize originalWidth,anchorPoint,contentOffX,anchorXchange;

#define kGranularity 15//曲线的平滑度系数
#define kStatusSamllImageHeight 18//30// 状态小图标的竖线高度
#define kStatusBigImageHeight 35//110// 状态大图标竖线高度
#define kSmallImageWH 15//20//小图标宽高
#define kBigImageWH 47//50//大图标宽高
#define kMinLimitLeave 0//前后三十分钟不计算离床

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        panScale = 1.0;
        originalWidth = self.frame.size.width;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSleepScale:) name:@"kNotifySleepViewSacleChange" object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)drawRect:(CGRect)rect
{
    [self createGetupWithPoints:nil];
    [self createFallasleepWithPoints:nil];
    [self createHuxi];
    [self createHeartStop];
    [self createLeaveWithPoints:nil];
    [self createCurveWithPoints:allCurvePoints];
}

#pragma mark --analysisReportvcDelegate
// 缩放手势回调
-(void)handleSleepScale:(NSNotification *)notification
{
    CGFloat scale = [[notification object] floatValue];
    UIScrollView *father = (UIScrollView *)[self superview];
    
    int n = 30;
//    if (DEVICE_IS_IPHONE4) n = 18;
    
    //控制放大到最大为30倍
    if (self.frame.size.width * scale > originalWidth * n)
    {
        return;
    }
    
    //控制缩放到最小为多少
    if (self.frame.size.width * scale <= originalWidth && scale < 1)
    {
        scale = originalWidth/self.frame.size.width;
    }
    
    for (int i = 0 ; i < self.curvePoints.count; i++)
    {
        CGPoint p = [self.curvePoints[i] CGPointValue];
        p.x *= scale;
        [self.curvePoints replaceObjectAtIndex:i withObject:[NSValue valueWithCGPoint:p]];
    }
    
    for (int i = 0; i < sampleLeavePoints.count; i++)
    {
        CGPoint p = [sampleLeavePoints[i] CGPointValue];
        p.x *= scale;
        [sampleLeavePoints replaceObjectAtIndex:i withObject:[NSValue valueWithCGPoint:p]];
    }
    
    [self getAllCurvePoints:self.curvePoints];
    
    CGRect frame = self.frame;
    frame.size.width *= scale;
    self.frame = frame;
    father.contentSize = CGSizeMake(self.frame.size.width, 0);
    
    anchorXchange *= scale;
    CGFloat addX = anchorXchange - anchorPoint.x;//缩放后的X轴的增量
//    NSLog(@"contentOffX + addX = %f",contentOffX + addX);
//    NSLog(@"father.frame.size.width = %f",father.frame.size.width);
//    NSLog(@"self.frame.size.width = %f",self.frame.size.width);

    
    if (contentOffX + addX >= 0  && contentOffX + addX + father.frame.size.width <= self.frame.size.width )
    {
        father.contentOffset = CGPointMake(contentOffX + addX, 0);//控制contentOffset， 以抵消缩放后的X轴增量， 使得两手中间点看起来不动
//        NSLog(@"contentOffX  = %f", contentOffX);
    }
    
    if (self.PinBlock)
    {
        self.PinBlock(father.contentOffset.x, scale);
    }
    
    [self setNeedsDisplay];//重绘
}

#pragma mark --public
-(void)sampleSleepData:(NSString *)sleepStrings status:(NSString *)statusString
{
    self.curvePoints = [NSMutableArray array];
    sampleLeavePoints = [NSMutableArray array];
    
    //呼吸button初始化
    for (int i = 0; i < huxiBtnArray.count; i++)
    {
        UIView *view = huxiBtnArray[i];
        [view removeFromSuperview];
    }
    if (huxiBtnArray)  [huxiBtnArray removeAllObjects];
    
    //心脏暂停button初始化
    for (int i = 0; i < heartStopBtnArray_.count; i++)
    {
        UIView *view = heartStopBtnArray_[i];
        [view removeFromSuperview];
    }
    if (heartStopBtnArray_.count)
    {
        [heartStopBtnArray_ removeAllObjects];
    }
#ifdef DRAW_CURVE_DIRECTLY
    //*********是否可直接绘制*********
    NSString *cureStr = self.currentObj.SleepCurveStr;
    NSString *cureStatusStr = self.currentObj.sleepCurveStatusStr;
    if (cureStr && cureStr.length && cureStatusStr && cureStatusStr.length)
    {
        NSArray *cureArr = [cureStr JSONValue];
        if (cureArr && [cureArr isKindOfClass:[NSArray class]] && cureArr.count)
        {
            isCurePointExist = YES;
            [self getAllCurvePoints:self.curvePoints];
            sleepTime = cureArr.count;
            return;
        }
        else
        {
            isCurePointExist = NO;
        }
    }
    else
    {
        isCurePointExist = NO;
    }
#endif
    //*********end******************
    NSMutableArray *sleepArray = [NSMutableArray arrayWithArray:[sleepStrings JSONValue]];
    statusArray = [NSMutableArray arrayWithArray:[statusString JSONValue]];
    
    if (!statusArray || !statusArray.count)
    {
        //异常数据,重置
        if (allCurvePoints)
        {
            [allCurvePoints removeAllObjects];
        }
        [self setNeedsDisplay];
        return;
    }
    for (int i = 0; i < statusArray.count; i++)
    {
        //statusArray只取低三位
        NSNumber *iNum = [statusArray objectAtIndex:i];
        int intNum = iNum.intValue & statusArrayRang;
        [statusArray replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:intNum]];
    }
    
    /***************************************** 改变状态值：三分钟内的离床合并为一次*******************/
    int preLeaveIndex = 0;//记录上一个离床的索引
    int leavePontCount = 0;
    for (int i = 1; i < statusArray.count; i++)
    {
        int s0 = [statusArray[i - 1] intValue];
        int s1 = [statusArray[i] intValue];
        
        //离床点
        if ((i != 1 && s0 == 5 && s1 != 5 )//仅仅第一个点，这种情况不记录为离床
            || (i != sleepArray.count - 1 && s0 != 5 && s1 == 5 )//仅仅最后一个点为离床,这种情况不记录为离床
            || (i == 1 && s0 == 5 && s1 == 5)
            || (i == sleepArray.count - 1 && s1 == 5 && s0 == 5))
        {
            int mod = leavePontCount%2;
            if (mod == 0 && preLeaveIndex != 0 && i - preLeaveIndex <= 3 && i - preLeaveIndex > 0)//三分钟内的离床，合并为一次离床
            {
                id obj1 = statusArray[preLeaveIndex];
                for (int index = preLeaveIndex + 1; index < i ; index++)
                {
                    if ([statusArray[index] intValue] != 2)//不是呼吸暂停
                    {
                        [statusArray replaceObjectAtIndex:index withObject:obj1];
                    }
                }
                leavePontCount--;
            }
            else
            {
                preLeaveIndex = i-1;
                leavePontCount++;
            }
        }
        
    }
    /***************************************** 改变状态值：三分钟内的离床合并为一次*******************/
    
    
    
    //额外增加一个点
    CGPoint p0 = CGPointMake(0, self.frame.size.height / kRowCout/2.0);
    [self.curvePoints addObject:[NSValue valueWithCGPoint:p0]];
    
    //计算每分钟的宽度值
    CGFloat widthPerMinute = self.frame.size.width/sleepArray.count;
    sleepTime = sleepArray.count;
    int midCount = 0;//为了取中间点而计数
    
    BOOL findFallasleepPoint = NO;//是否找到入睡点
    for (int i = 1; i < sleepArray.count; i++)
    {
        int v0 = [sleepArray[i - 1] intValue];
        int v1 = [sleepArray[i] intValue];
        
        int s0 = [statusArray[i - 1] intValue];
        int s1 = [statusArray[i] intValue];
        
        if (v0 != v1)
        {
            CGPoint lastP = [[self.curvePoints lastObject] CGPointValue];
            BOOL isLeavePoint = NO;
            
            for (int i = 0; i < sampleLeavePoints.count; i++)
            {
                CGPoint p = [(NSValue *)sampleLeavePoints[i] CGPointValue];
                NSString *s = [NSString stringWithFormat:@"%0.4f",p.x];
                NSString *s1 = [NSString stringWithFormat:@"%0.4f",lastP.x];
                
                if ([s isEqualToString:s1] && p.y == lastP.y)
                {
                    isLeavePoint = YES;
                    break;
                }
            }
            
            if (v0 == 0 && isLeavePoint && findFallasleepPoint)//过滤离床后还是清醒的情况
            {
                
            }
            else
            {
                if (findFallasleepPoint == NO && v0 == 0)//获得入睡点
                {
                    findFallasleepPoint = YES;
                    CGPoint p = CGPointMake(i*widthPerMinute, kSleepViewGridHeight * (v0+1));
                    [self.curvePoints addObject:[NSValue valueWithCGPoint:p]];
                    midCount = 0;
                }
                else
                {
                    // 顶点
                    CGPoint p = CGPointMake((i-midCount/2.f)*widthPerMinute, kSleepViewGridHeight * (v0+1));
                    [self.curvePoints addObject:[NSValue valueWithCGPoint:p]];
                    midCount = 0;
                }
            }
            
        }
        
        if (self.currentObj && ![self.currentObj isNotRestOnSource])
        {
            //离床点
            if ((i != 1 && s0 == 5 && s1 != 5 )//仅仅第一个点，这种情况不记录为离床
                || (i != sleepArray.count - 1 && s0 != 5 && s1 == 5 )//仅仅最后一个点为离床,这种情况不记录为离床
                || (i == 1 && s0 == 5 && s1 == 5)
                || (i == sleepArray.count - 1 && s1 == 5 && s0 == 5))
            {
                //            int mod = sampleLeavePoints.count%2;
                //            if (mod == 0 && preLeaveIndex != 0 && i - preLeaveIndex <= 3 && i - preLeaveIndex > 0)//三分钟内的离床，合并为一次离床
                //            {
                //                if (sampleLeavePoints.count)
                //                {
                //                    [sampleLeavePoints removeLastObject];
                //                }
                //
                //                if (self.curvePoints.count)
                //                {
                //                    [self.curvePoints removeLastObject];
                //                }
                //            }
                //            else
                {
                    
                    CGPoint p = CGPointMake(i*widthPerMinute, kSleepViewGridHeight);
                    [self.curvePoints addObject:[NSValue valueWithCGPoint:p]];
                    [sampleLeavePoints addObject:[NSValue valueWithCGPoint:p]];
                    midCount = 0;
                }
            }
        }
        midCount++;
    }
    
    //添加起床点
    for (NSInteger i = sleepArray.count - 1; i > 0; i--)
    {
        int v = [sleepArray[i] intValue];
        
        if (v != 0)//倒序找到不为0的点
        {
            CGPoint p = CGPointMake((i+1)*widthPerMinute, kSleepViewGridHeight);
            for (NSInteger j = self.curvePoints.count - 1; j > 0 ; j--)
            {
                CGPoint tempPoint = [self.curvePoints[j] CGPointValue];
                if (p.x >= tempPoint.x)
                {
                    if (p.x >= self.frame.size.width - 2)
                    {
                        p.x  = self.frame.size.width - 2;
                    }
                    [self.curvePoints insertObject:[NSValue valueWithCGPoint:p] atIndex:j+1];
                    break;
                }
            }
            
            break;
        }
    }
    
    //额外增加一个末尾点
    CGPoint pLast = CGPointMake(CGRectGetWidth(self.frame), self.frame.size.height / kRowCout/2.0);
    [self.curvePoints addObject:[NSValue valueWithCGPoint:pLast]];
    
    [self getAllCurvePoints:self.curvePoints];
}

- (void)getAllCurvePoints:(NSMutableArray *)points
{
#ifdef DRAW_CURVE_DIRECTLY
    //*******test(当历史数据有睡眠曲线数据,则直接绘图,不再去生成点)*************
    if (isCurePointExist)
    {
        [self clearStatesArr];
        NSString *cureStatusStr = self.currentObj.sleepCurveStatusStr;
        NSArray *cureArr = [self.currentObj.SleepCurveStr JSONValue];
        NSMutableArray *cureEvenArr = [NSMutableArray arrayWithArray:[cureStatusStr JSONValue]];
        if (cureArr.count)
        {
            CGFloat widthPerMinute = self.frame.size.width/cureArr.count;
            
            for (int i = 0 ; i < cureArr.count; i++)
            {
                float originY = [[cureArr objectAtIndex:i]floatValue];
                float x = i * widthPerMinute;
                float y = kSleepViewGridHeight * (originY + 1);
                if (x >= self.frame.size.width)
                {
                    x -= 1.0;
                }
                
                CGPoint p = CGPointMake(x, y);
                NSValue *thisPoint = [NSValue valueWithCGPoint:p];
                
                int even = [[cureEvenArr objectAtIndex:i]intValue];
                if (even & FALL_ASLEEP)//入睡点
                {
                    if (!fallAsleepArr_.count)
                    {
                        p.y = kSleepViewGridHeight;
                        thisPoint = [NSValue valueWithCGPoint:p];
                        [fallAsleepArr_ addObject:thisPoint];
                    }
                }
                if (even & GET_UP)//起床前的清醒点
                {
                    if (!awakeArr_.count)
                    {
                        p.y = kSleepViewGridHeight;
                        thisPoint = [NSValue valueWithCGPoint:p];
                        [awakeArr_ addObject:thisPoint];
                    }
                }
                
                [allCurvePoints addObject:thisPoint];
                
                if (even & HEART_STOP)//心率暂停
                {
                    [heartStopArr_ addObject:thisPoint];
                    [heartStopTimeArray_ addObject:[NSNumber numberWithInt:i]];
                }
                if (even & BREATH_STOP)//呼吸暂停
                {
                    [breathStopArr_ addObject:thisPoint];
                    [huxiTimeArray addObject:[NSNumber numberWithInt:i]];
                }
                if (even & LEFT_BED)//离床点
                {
                    if (leftBedArr_.count % 2 == 0)
                    {
                        [leftBedArr_ addObject:thisPoint];
                    }
                    else
                    {
                        if (i + 1 < cureEvenArr.count)
                        {
                            int nextEven = [[cureEvenArr objectAtIndex:i + 1]intValue];
                            if (!(nextEven & LEFT_BED))
                            {
                                [leftBedArr_ addObject:thisPoint];
                            }
                        }
                        else
                        {
                            [leftBedArr_ addObject:thisPoint];
                        }
                    }
                }
            }
            return;
        }
    }
#endif
    //*******EndTest***********************
    
    if (points.count)
    {
        allCurvePoints = [NSMutableArray array];
        [allCurvePoints addObject:[NSValue valueWithCGPoint:[points[0] CGPointValue]]];
        CGPoint lastPoit = [[self.curvePoints lastObject]CGPointValue];
        CGFloat maxX = lastPoit.x;
        // 增加两个控制点
        [points insertObject:points[0] atIndex:0];
        [points addObject:[points lastObject]];
        
        for (NSUInteger index = 1; index < points.count - 2; index++)
        {
            CGPoint p0 = [(NSValue *)points[index - 1] CGPointValue];
            CGPoint p1 = [(NSValue *)points[index] CGPointValue];
            CGPoint p2 = [(NSValue *)points[index + 1] CGPointValue];
            CGPoint p3 = [(NSValue *)points[index + 2] CGPointValue];
            
            BOOL isLeavePoint1 = NO;
            BOOL isLeavePoint2 = NO;
            
            for (int i = 0; i < sampleLeavePoints.count; i++)
            {
                CGPoint p = [(NSValue *)sampleLeavePoints[i] CGPointValue];
                NSString *s = [NSString stringWithFormat:@"%0.4f",p.x];
                NSString *s1 = [NSString stringWithFormat:@"%0.4f",p1.x];
                NSString *s2 = [NSString stringWithFormat:@"%0.4f",p2.x];
                
                if ([s isEqualToString:s1] && p.y == p1.y)
                {
                    isLeavePoint1 = YES;
                }
                if ([s isEqualToString:s2] && p.y == p2.y)
                {
                    isLeavePoint2 = YES;
                }
            }
            
            for (int i = 1; i < kGranularity; i++)
            {
                float t = (float) i * (1.0f / (float) kGranularity);
                float tt = t * t;
                float ttt = tt * t;
                
                CGPoint pi; // intermediate point
                pi.x = 0.5 * (2*p1.x+(p2.x-p0.x)*t + (2*p0.x-5*p1.x+4*p2.x-p3.x)*tt + (3*p1.x-p0.x-3*p2.x+p3.x)*ttt);
                pi.y = 0.5 * (2*p1.y+(p2.y-p0.y)*t + (2*p0.y-5*p1.y+4*p2.y-p3.y)*tt + (3*p1.y-p0.y-3*p2.y+p3.y)*ttt);
                
//                if (index >= 2 && index <= points.count - 4 && pi.y < CGRectGetHeight(self.frame)/kRowCout)
//                {
//                    pi.y = CGRectGetHeight(self.frame)/kRowCout;
//                }
                
                
                if (isLeavePoint1 && isLeavePoint2)//判断是否是离床的区间
                {
                    CGPoint p = [(NSValue *)sampleLeavePoints[0] CGPointValue];
                    pi.y = p.y;
                }
                
                CGPoint lastPoint = [[allCurvePoints lastObject]CGPointValue];
                if (pi.x < lastPoint.x)
                {
                    //防止曲线回头
                    pi.x = lastPoint.x + 0.1;
                }
                if (pi.x > maxX)
                {
                    pi.x = maxX - 0.01;
                }
                [allCurvePoints addObject:[NSValue valueWithCGPoint:pi]];
            }
            
            
            CGPoint xlastPoint = [[allCurvePoints lastObject]CGPointValue];
            if (p2.x < xlastPoint.x)
            {
                //防止曲线回头
                p2.x = xlastPoint.x;
            }
            if (p2.x > maxX)
            {
                p2.x = maxX - 0.01;
            }
            [allCurvePoints addObject:[NSValue valueWithCGPoint:p2]];

        }
        
        // finish by adding the last point
        [allCurvePoints addObject:[NSValue valueWithCGPoint:[points[points.count - 1] CGPointValue]]];
        
        //删除先前增加的两个控制点
        [points removeObjectAtIndex:0];
        [points removeLastObject];
    }
}

- (void)scalePoint:(CGFloat)scale
{
    panScale = scale;
    for (int i = 0; i < self.curvePoints.count; i++)
    {
        CGPoint p = [self.curvePoints[i] CGPointValue];
        p.y *= scale;
        [self.curvePoints replaceObjectAtIndex:i withObject:[NSValue valueWithCGPoint:p]];
    }
    
    for (int i = 0; i < sampleLeavePoints.count; i++)
    {
        CGPoint p = [sampleLeavePoints[i] CGPointValue];
        p.y *= scale;
        [sampleLeavePoints replaceObjectAtIndex:i withObject:[NSValue valueWithCGPoint:p]];
    }
    
    [self getAllCurvePoints:self.curvePoints];
}

#pragma mark --private
-(NSArray *)getFallasleepIndexInAllCurve
{
    NSMutableArray *indexArray = [NSMutableArray array];
    
    for (int n = 1; n < allCurvePoints.count; n++)
    {
        CGPoint p0 = [allCurvePoints[n - 1] CGPointValue];
        CGPoint p1 = [allCurvePoints[n] CGPointValue];
        CGFloat y = CGRectGetHeight(self.frame)/kRowCout;
        if ((y - p0.y) * (y - p1.y) <= 0)//找到最近的点
        {
            [indexArray addObject:[NSNumber numberWithInt:n-1]];
            break;
        }
    }
    return indexArray;
}


-(NSArray *)getGetUpIndexInAllCurve
{
    NSMutableArray *indexArray = [NSMutableArray array];
    
    for (NSInteger n = allCurvePoints.count - 1; n > 0; n--)
    {
        CGPoint p0 = [allCurvePoints[n - 1] CGPointValue];
        CGPoint p1 = [allCurvePoints[n] CGPointValue];
        CGFloat y = CGRectGetHeight(self.frame)/kRowCout;
        if ((y - p0.y) * (y - p1.y) <= 0)//找到最近的点
        {
            [indexArray addObject:[NSNumber numberWithInteger:n]];
            break;
        }
    }
    return indexArray;
}
//心跳暂停
- (NSArray *)getHeartStopIndexInAllCurve
{
    
    NSMutableArray *indexArray = [NSMutableArray array];
    if (!heartStopTimeArray_)
    {
        heartStopTimeArray_ = [NSMutableArray array];
    }
    else
    {
        [heartStopTimeArray_ removeAllObjects];
    }
    
    if ([self.currentObj isNotRestOnSource])
    {
        return heartStopTimeArray_;
    }
    
    for (int i = 0; i < statusArray.count; i++)
    {
        if ([statusArray[i] intValue] == 3)//心跳暂停
        {
            for (int n = 1; n < allCurvePoints.count; n++)
            {
                //计算每分钟的宽度值
                CGFloat widthPerMinute = self.frame.size.width/statusArray.count;
                CGPoint p0 = [allCurvePoints[n - 1] CGPointValue];
                CGPoint p1 = [allCurvePoints[n] CGPointValue];
                CGFloat x = i * widthPerMinute;
                if ((x - p0.x) * (x - p1.x) <= 0)//找到最近的点
                {
                    if ([indexArray containsObject:[NSNumber numberWithInt:n]])
                    {
                        [indexArray addObject:[NSNumber numberWithInt:n+1]];
                    }
                    else
                    {
                        [indexArray addObject:[NSNumber numberWithInt:n]];
                    }
                    
                    [heartStopTimeArray_ addObject:[NSNumber numberWithInt:i]];
                    break;
                }
            }
        }
    }
    return indexArray;
}
//呼吸暂停
-(NSArray *)getHuxiIndexInAllCurve
{
    NSMutableArray *indexArray = [NSMutableArray array];
    huxiTimeArray = [NSMutableArray array];
    if ([self.currentObj isNotRestOnSource])
    {
        return huxiTimeArray;
    }
    for (int i = 0; i < statusArray.count; i++)
    {
        if ([statusArray[i] intValue] == 2)//呼吸暂停
        {
            for (int n = 1; n < allCurvePoints.count; n++)
            {
                //计算每分钟的宽度值
                CGFloat widthPerMinute = self.frame.size.width/statusArray.count;
                CGPoint p0 = [allCurvePoints[n - 1] CGPointValue];
                CGPoint p1 = [allCurvePoints[n] CGPointValue];
                CGFloat x = i * widthPerMinute;
                if ((x - p0.x) * (x - p1.x) <= 0)//找到最近的点
                {
                    if ([indexArray containsObject:[NSNumber numberWithInt:n]])
                    {
                        [indexArray addObject:[NSNumber numberWithInt:n+1]];
                    }
                    else
                    {
                        [indexArray addObject:[NSNumber numberWithInt:n]];
                    }
                    
                    [huxiTimeArray addObject:[NSNumber numberWithInt:i]];
                    break;
                }
            }
        }
    }
    return indexArray;
}

-(NSArray *)getLeaveIndexInAllCurve
{

    BOOL findFirstPoint = NO;
    BOOL findSecondPoint = NO;
    NSMutableArray *indexArray = [NSMutableArray array];
    
//    if (statusArray.count < kMinLimitLeave * 2 + 1)//至少一个小时以上
//    {
//        return nil;
//    }
    
    for (int i = kMinLimitLeave; i < statusArray.count - kMinLimitLeave; i++)
    {
        if ([statusArray[i] intValue] == 5)//离床
        {
            for (int n = 1; n < allCurvePoints.count; n++)
            {
                //计算每分钟的宽度值
                CGFloat widthPerMinute = self.frame.size.width/statusArray.count;
                CGPoint p0 = [allCurvePoints[n - 1] CGPointValue];
                CGPoint p1 = [allCurvePoints[n] CGPointValue];
                CGFloat x = i * widthPerMinute;
                if ((x - p0.x) * (x - p1.x) <= 0)//找到最近的点
                {
                    [indexArray addObject:[NSNumber numberWithInt:n]];
                    findFirstPoint = YES;
                    break;
                }
            }
        }
        
        if (findFirstPoint)
        {
            for (int k = i+1; k < statusArray.count; k++)
            {
                if ([statusArray[k] intValue] != 5)//上床
                {
                    if (k > statusArray.count - kMinLimitLeave)
                    {
                        [indexArray removeLastObject];
                        break;
                    }
                    
                    for (int n = 1; n < allCurvePoints.count; n++)
                    {
                        //计算每分钟的宽度值
                        CGFloat widthPerMinute = self.frame.size.width/statusArray.count;
                        CGPoint p0 = [allCurvePoints[n - 1] CGPointValue];
                        CGPoint p1 = [allCurvePoints[n] CGPointValue];
                        CGFloat x = k * widthPerMinute;
                        if ((x - p0.x) * (x - p1.x) <= 0)//找到最近的点
                        {
                            [indexArray addObject:[NSNumber numberWithInt:n]];
                            findSecondPoint = YES;
                            break;
                        }
                    }
                    if (findSecondPoint)
                    {
                        i = k;
                        break;
                    }
                }
            }
            
            findFirstPoint = NO;//赋值0，继续找下一对
        }
    }
    
    return indexArray;
}

// 画曲线
- (void)createCurveWithPoints:(NSMutableArray *)points
{
    if (points.count)
    {
        UIBezierPath* path = [UIBezierPath bezierPath];
        [path setLineWidth:1];
        
        [path moveToPoint:[points[0] CGPointValue]];
        
        for (int i = 0; i < points.count; i++)
        {
            [path addLineToPoint:[(NSValue *)points[i] CGPointValue]];
        }
        
        [[UIColor colorWithRed:51.0/255.0 green:153/255.0 blue:251/255.0 alpha:1.0] setStroke];
        path.lineCapStyle = kCGLineCapRound;
        path.lineJoinStyle = kCGLineJoinRound;
        path.flatness = 1;
        path.lineWidth = 1.0;
        [path stroke];
        
        CGPathRef pathRef = path.CGPath;
        [self fillColorWithPath:pathRef];
    }
}


//画点
- (void)createPointWithPoints:(NSArray *)points
{
    if(points.count)
    {
        for(int i=0; i<points.count; i++)
        {
            [self createPointWithPoint:[points[i] CGPointValue]];
        }
    }
}

//画点2
- (void)createPointWithPoint:(CGPoint )point
{
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:point radius:2.5 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    UIColor *color =[UIColor colorWithRed:51.0/255.0 green:153/255.0 blue:251/255.0 alpha:1.0];
    [color set]; //设置线条颜色
    path.lineWidth = 1;
    [path stroke];
}

//画上床
- (void)createFallasleepWithPoints:(NSArray *)points
{
    CGPoint p = CGPointZero;
    BOOL isPointExist = NO;
    if (isCurePointExist)
    {
        if (fallAsleepArr_.count)
        {
            p = [[fallAsleepArr_ lastObject]CGPointValue];
            isPointExist = YES;
        }
    }
    else
    {
        NSArray *array = [self getFallasleepIndexInAllCurve];
        
        //线
        for (int i = 0; i < array.count; i++)
        {
            int index = [array[i] intValue];
            
            if (index >= allCurvePoints.count)
            {
                break;
            }
            p = [allCurvePoints[index] CGPointValue];
            isPointExist = YES;
        }
    }
    
    if (isPointExist)
    {
        [self createPointWithPoint:p];
        
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(ctx, 1);
        CGContextSetStrokeColorWithColor(ctx, [UIColor grayColor].CGColor);
        CGContextMoveToPoint(ctx, p.x, p.y);
        CGFloat ly;//线的y坐标
        CGFloat imageY;//图标y坐标
        ly =  kStatusSamllImageHeight;
        imageY = ly - kSmallImageWH;
        
        CGFloat imageX;//
        if (p.x - kSmallImageWH/2.0 > 0)
        {
            imageX = p.x - kSmallImageWH/2.0;
        }
        else
        {
            imageX = 0;
        }
        CGContextAddLineToPoint(ctx, p.x, ly);
        CGContextStrokePath(ctx);
        
        [[UIImage imageNamed:@"moon.png"] drawInRect:CGRectMake(imageX, imageY  , kSmallImageWH, kSmallImageWH)];
    }
}



//画离床
- (void)createLeaveWithPoints:(NSArray *)points
{
    NSArray *array = isCurePointExist?leftBedArr_ : sampleLeavePoints;
    if (array.count == 0) return;
    //线
    for (int i = 0; i < array.count; i++)
    {
        CGPoint p = [array[i] CGPointValue];
        [self createPointWithPoint:p];
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(ctx, 1);
        CGContextSetStrokeColorWithColor(ctx, [UIColor grayColor].CGColor);
        CGContextMoveToPoint(ctx, p.x, p.y);
        CGContextAddLineToPoint(ctx, p.x, kStatusSamllImageHeight );
        CGContextStrokePath(ctx);
    }
    
    NSDictionary *dict = @{NSFontAttributeName: [UIFont systemFontOfSize:7],
                           NSForegroundColorAttributeName:[UIColor grayColor],
                           NSStrokeWidthAttributeName:@-3,
                           NSStrokeColorAttributeName:[UIColor grayColor]
                           };
    
    
    //图，文字
    for (int i = 0; i < array.count - 1; i++)
    {
        if (i%2 != 0)//每两个是一组
        {
            continue;
        }

        CGPoint p1 = [array[i] CGPointValue];
        CGPoint p2 = [array[i + 1] CGPointValue];
        [self createPointWithPoint:p1];
        [self createPointWithPoint:p2];
        [[UIImage imageNamed:@"leavebed_sm.png"] drawInRect:CGRectMake((p2.x + p1.x)/2 - kSmallImageWH/2,  kStatusSamllImageHeight - kSmallImageWH - 4, kSmallImageWH, kSmallImageWH)];
        
        //计算离床时间
        CGFloat avg = (self.frame.size.width/sleepTime);
        CGFloat space = fabs(p2.x - p1.x);
        CGFloat m = space/avg;
        int min = m + 0.5;//四舍五入（+0.5后取整）
        if (min == 0) min = 1;
        [[NSString stringWithFormat:@"%dmin",min] drawInRect:CGRectMake((p2.x + p1.x)/2 - 20/2.f, kStatusSamllImageHeight - 8 , 24, 8) withAttributes:dict];
    }

}

/**
 *  画心跳暂停
 */
- (void)createHeartStop
{
    NSArray *array = isCurePointExist?heartStopArr_:[self getHeartStopIndexInAllCurve];
    if (array.count == 0) return;
    
    if (heartStopBtnArray_ == nil)
    {
        heartStopBtnArray_ = [NSMutableArray array];
    }
    else
    {
        for (int i = 0; i < heartStopBtnArray_.count; i++)
        {
            UIView *view = heartStopBtnArray_[i];
            [view removeFromSuperview];
        }
        if (heartStopBtnArray_)  [heartStopBtnArray_ removeAllObjects];
    }
    
    for (int i = 0; i < array.count; i++)
    {
        CGPoint p;
        if (isCurePointExist)
        {
            p = [[array objectAtIndex:i]CGPointValue];
        }
        else
        {
            int index = [array[i] intValue];
            if (index >= allCurvePoints.count)
            {
                break;
            }
            p = [allCurvePoints[index] CGPointValue];
        }

        [self createPointWithPoint:p];
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(ctx, 1);
        CGContextSetStrokeColorWithColor(ctx, [UIColor grayColor].CGColor);
        CGContextMoveToPoint(ctx, p.x, p.y);
        CGFloat ly;//线的y坐标
        CGFloat imageY;//图标y坐标
        
        ly = CGRectGetHeight(self.frame) - kBigImageWH/2.f;
        imageY = CGRectGetHeight(self.frame) - kBigImageWH;
        
        CGContextAddLineToPoint(ctx, p.x, ly);
        CGContextStrokePath(ctx);
        
        UIButton *heartStopBtn = [[UIButton alloc] initWithFrame:CGRectMake(p.x - kBigImageWH/2, imageY, kBigImageWH, kBigImageWH)];
        [heartStopBtn setBackgroundImage:[UIImage imageNamed:@"heart_stop_s"] forState:UIControlStateNormal];
        heartStopBtn.tag = [heartStopTimeArray_[i] intValue];
        [heartStopBtn addTarget:self action:@selector(heartStopBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:heartStopBtn];
        [heartStopBtnArray_ addObject:heartStopBtn];
    }
}

//画呼吸
- (void)createHuxi
{
    NSArray *array = isCurePointExist?breathStopArr_:[self getHuxiIndexInAllCurve];
    if (array.count == 0) return;
    
    if (huxiBtnArray == nil)
    {
        huxiBtnArray = [NSMutableArray array];
    }
    else
    {
        for (int i = 0; i < huxiBtnArray.count; i++)
        {
            UIView *view = huxiBtnArray[i];
            [view removeFromSuperview];
        }
        if (huxiBtnArray)  [huxiBtnArray removeAllObjects];
    }
    
    for (int i = 0; i < array.count; i++)
    {
        CGPoint p;
        if (isCurePointExist)
        {
            p = [[array objectAtIndex:i]CGPointValue];
        }
        else
        {
            int index = [array[i] intValue];
            if (index >= allCurvePoints.count)
            {
                break;
            }
            p = [allCurvePoints[index] CGPointValue];
        }

        [self createPointWithPoint:p];
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(ctx, 1);
        CGContextSetStrokeColorWithColor(ctx, [UIColor grayColor].CGColor);
        CGContextMoveToPoint(ctx, p.x, p.y);
        CGFloat ly;//线的y坐标
        
        ly = CGRectGetHeight(self.frame) - kBigImageWH + 15;
        
        CGContextAddLineToPoint(ctx, p.x, ly);
        CGContextStrokePath(ctx);
        
        UIButton *huxiBtn = [[UIButton alloc] initWithFrame:CGRectMake(p.x - kBigImageWH/2, CGRectGetHeight(self.frame) - kBigImageWH, kBigImageWH, kBigImageWH)];
        [huxiBtn setBackgroundImage:[UIImage imageNamed:@"huxi_3-177"] forState:UIControlStateNormal];
        huxiBtn.tag = [huxiTimeArray[i] intValue];
        [huxiBtn addTarget:self action:@selector(huxiBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:huxiBtn];
        [huxiBtnArray addObject:huxiBtn];
    }
}

//画起床
- (void)createGetupWithPoints:(NSArray *)points
{
    CGPoint p;
    BOOL isPointExist = NO;
    if (isCurePointExist)
    {
        if (awakeArr_.count)
        {
            isPointExist = YES;
            p = [[awakeArr_ lastObject]CGPointValue];
        }
    }
    else
    {
        NSArray *array = [self getGetUpIndexInAllCurve];
        
        //线
        for (int i = 0; i < array.count; i++)
        {
            int index = [array[i] intValue];
            
            if (index >= allCurvePoints.count)
            {
                break;
            }
            p = [allCurvePoints[index] CGPointValue];
            isPointExist = YES;
        }
    }
    
    if (isPointExist)
    {
        [self createPointWithPoint:p];
        
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(ctx, 1);
        CGContextSetStrokeColorWithColor(ctx, [UIColor grayColor].CGColor);
        CGContextMoveToPoint(ctx, p.x, p.y);
        CGFloat ly;//线的y坐标
        CGFloat imageY;//图标y坐标
        CGFloat imageX;//图标X坐标
        
        ly =  kStatusSamllImageHeight;
        imageY = ly - kSmallImageWH;
        
        if (p.x + kSmallImageWH/2.0 > self.frame.size.width)
        {
            imageX = p.x - kSmallImageWH;
        }
        else
        {
            imageX = p.x - kSmallImageWH/2.0;
        }
        CGContextAddLineToPoint(ctx, p.x, ly);
        CGContextStrokePath(ctx);
        
        [[UIImage imageNamed:@"sun.png"] drawInRect:CGRectMake(imageX, imageY , kSmallImageWH, kSmallImageWH)];
    }
}


//颜色渐变
-(void)fillColorWithPath:(CGPathRef)pathRef
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:51.0/255.0 green:153/255.0 blue:251/255.0 alpha:1.0].CGColor);
    CGContextSetLineWidth(context, 2.0);
    CGMutablePathRef startPath = CGPathCreateMutableCopy(pathRef);
    CGContextSetShouldAntialias(context, YES);
    
    CGPathCloseSubpath(startPath);    //封闭
    CGContextSaveGState(context);     //Save context for cliping
    
    CGContextAddPath(context, startPath);
    CGContextClip(context);
    CGPathRelease(startPath);
    // 创建色彩空间对象
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    
    // 创建起点颜色
    CGColorRef endColor = CGColorCreate(colorSpaceRef, (CGFloat[]){16/255.0, 45/255.0, 136/255.0, 0.8});
    CGColorRef midColor = CGColorCreate(colorSpaceRef, (CGFloat[]){17/255.0, 104/255.0, 128/255.0, 0.5});
    // 创建终点颜色
    CGColorRef beginColor = CGColorCreate(colorSpaceRef, (CGFloat[]){0.0f, 0.0f, 0.0f, 0.0f});
    
    // 创建颜色数组
    CFArrayRef colorArray = CFArrayCreate(kCFAllocatorDefault, (const void*[]){beginColor,midColor, endColor}, 3, nil);
    
    // 创建渐变对象
    CGGradientRef gradientRef = CGGradientCreateWithColors(colorSpaceRef, colorArray, (CGFloat[]){
        0.0f,
        0.5,// 对应起点颜色位置
        1.0f// 对应终点颜色位置
    });
    
    // 释放颜色数组
    CFRelease(colorArray);
    
    // 释放起点和终点颜色
    CGColorRelease(beginColor);
    CGColorRelease(midColor);
    CGColorRelease(endColor);
    
    // 释放色彩空间
    CGColorSpaceRelease(colorSpaceRef);
    
    CGContextDrawLinearGradient(context, gradientRef, CGPointMake(0.0f, 0.0f), CGPointMake(0.0f, self.frame.size.height ), 0);
    
    // 释放渐变对象
    CGGradientRelease(gradientRef);
}

/**
 *  初始化曲线中的各个状态坐标数组
 */
- (void)clearStatesArr
{
    if (fallAsleepArr_)
    {
        [fallAsleepArr_ removeAllObjects];
    }
    else
    {
        fallAsleepArr_ = [NSMutableArray array];
    }
    
    if (awakeArr_)
    {
        [awakeArr_ removeAllObjects];
    }
    else
    {
        awakeArr_ = [NSMutableArray array];
    }
    
    if (breathStopArr_)
    {
        [breathStopArr_ removeAllObjects];
    }
    else
    {
        breathStopArr_ = [NSMutableArray array];
    }
    
    if (heartStopArr_)
    {
        [heartStopArr_ removeAllObjects];
    }
    else
    {
        heartStopArr_ = [NSMutableArray array];
    }
    
    if (leftBedArr_)
    {
        [leftBedArr_ removeAllObjects];
    }
    else
    {
        leftBedArr_ = [NSMutableArray array];
    }
    
    if (allCurvePoints)
    {
        [allCurvePoints removeAllObjects];
    }
    else
    {
        allCurvePoints = [NSMutableArray array];
    }
    
    if (huxiTimeArray)
    {
        [huxiTimeArray removeAllObjects];
    }
    else
    {
        huxiTimeArray = [NSMutableArray array];
    }
    
    if (heartStopTimeArray_)
    {
        [heartStopTimeArray_ removeAllObjects];
    }
    else
    {
        heartStopTimeArray_ = [NSMutableArray array];
    }
}

#pragma mark --button click


-(void)huxiBtnClick:(UIButton *)btn
{
    if (self.sleepDelegate && [self.sleepDelegate respondsToSelector:@selector(SleepViewClickHuxiButton:btn:)])
    {
        [self.sleepDelegate SleepViewClickHuxiButton:self btn:btn];
    }
    return;
}

- (void)heartStopBtnClick:(UIButton *)btn
{
    if (self.sleepDelegate && [self.sleepDelegate respondsToSelector:@selector(SleepViewClickHeartStopButton:btn:)])
    {
        [self.sleepDelegate SleepViewClickHeartStopButton:self btn:btn];
    }
}

@end
