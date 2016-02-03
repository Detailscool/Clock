//
//  ViewController.m
//  ClockWithCoreAnimation
//
//  Created by Detailscool on 16/1/12.
//  Copyright © 2016年 Detailscool. All rights reserved.
//

#import "ViewController.h"
#define angleToArc(angle) ((angle)*M_PI/180)

@interface ViewController ()

@property (nonatomic,strong)CALayer * secondLayer;
@property (nonatomic,strong)CALayer * minuteLayer;
@property (nonatomic,strong)CALayer * hourLayer;

@property (nonatomic,strong)NSDate * todayZero;


@property (weak, nonatomic) IBOutlet UILabel *timeLable;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.hourLayer = [self addClockHandWithBounds:CGRectMake(0, 0, 10, 90) andColor:[UIColor cyanColor]];
    self.minuteLayer = [self addClockHandWithBounds:CGRectMake(0, 0, 8, 100) andColor:[UIColor greenColor]];
    self.secondLayer = [self addClockHandWithBounds:CGRectMake(0, 0, 5, 120) andColor:[UIColor blackColor]];
    [self addCenter];
    
    CADisplayLink * displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateTime)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)updateTime{
    
    //设置秒针旋转角度
    CGFloat secondAngle = [self getMillisecond]%(3600*1000)%(60*1000)/(60*1000*1.0)*360;
    
    self.secondLayer.transform = CATransform3DMakeRotation(angleToArc(secondAngle), 0, 0, 1);

    //设置分针旋转角度
    CGFloat minuteAngle = [self getMillisecond]%(3600*1000)/(3600*1000*1.0f)*360;
    
    self.minuteLayer.transform = CATransform3DMakeRotation(angleToArc(minuteAngle), 0, 0, 1);

    //设置时针旋转角度
    CGFloat hourAngle = [self getMillisecond]/(3600*1000*1.0f)>12?([self getMillisecond]/(3600*1000*1.0f)-12)/12*360:[self getMillisecond]/(3600*1000*1.0f)/12*360;
    
    self.hourLayer.transform = CATransform3DMakeRotation(angleToArc(hourAngle), 0, 0, 1);
    
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    formatter.timeZone = [NSTimeZone systemTimeZone];
    formatter.dateFormat = @"HH: mm: ss : SSS";
    self.timeLable.text =[formatter stringFromDate:[NSDate date]];
}

- (void)addCenter{
    
    CALayer * centerLayer = [CALayer layer];
    [self.view.layer addSublayer:centerLayer];
    centerLayer.bounds = CGRectMake(0, 0, 10, 10);
    centerLayer.cornerRadius = 5;
    centerLayer.position = self.view.center;
    centerLayer.backgroundColor = [UIColor yellowColor].CGColor;
    
}

- (CALayer *)addClockHandWithBounds:(CGRect)bounds andColor:(UIColor *)color{
    CALayer * layer = [CALayer layer];
    [self.view.layer addSublayer:layer];
    layer.bounds = bounds;
    layer.position = self.view.center;
    layer.anchorPoint = CGPointMake(0.5, 0.8);
    layer.backgroundColor = color.CGColor;
    return layer;
}

- (NSInteger)getMillisecond{

    NSTimeZone * zone = [NSTimeZone systemTimeZone];
    NSTimeInterval interval = [zone secondsFromGMTForDate:[NSDate date]];
    NSDate * today = [[NSDate date] dateByAddingTimeInterval:interval];
//    NSLog(@"%@",today);
    
    NSTimeInterval timeInterval = [today timeIntervalSinceDate:self.todayZero];
//    NSLog(@"%lf",timeInterval);

    return (NSInteger)(timeInterval*1000);
}

- (NSDate *)todayZero{
    if (!_todayZero) {
        NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyy-MM-dd";
        formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        NSString * dateStr = [formatter stringFromDate:[NSDate date]];
        _todayZero = [formatter dateFromString:dateStr];
    }
    return _todayZero;
}


@end
