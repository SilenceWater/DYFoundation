//
//  DYDate.m
//  DYFoundation
//
//  Created by 德一智慧城市 on 2019/7/1.
//

#import "DYDate.h"
#import <objc/runtime.h>

@implementation DYDate

+ (NSDateFormatter *)sharedDateFormatter {
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
    });
    [dateFormatter  setTimeZone:[NSTimeZone localTimeZone]];
    
    return dateFormatter;
}

+ (NSDate *)dateFromString:(NSString *)dateString withDateFormat:(NSString *)formatString {
    NSDateFormatter *dateFormatter = [DYDate sharedDateFormatter];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setDateFormat:formatString];
    return [dateFormatter dateFromString:dateString];
}

+ (NSString *)stringFromDate:(NSDate *)date withDateFormat:(NSString *)formatString {
    NSDateFormatter *dateFormatter = [DYDate sharedDateFormatter];
    [dateFormatter setDateFormat:formatString];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)stringFromTimestamp:(NSTimeInterval)timeInterval withDateFormat:(NSString *)formatString {
    if (timeInterval > 10000000000.0) {
        timeInterval /=1000.0;
    }
    NSDateFormatter *dateFormatter = [DYDate sharedDateFormatter];
    [dateFormatter setDateFormat:formatString];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [dateFormatter stringFromDate:date];
}

+ (NSDateComponents *)componentFromDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setLocale:[NSLocale currentLocale]];
    NSCalendarUnit unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday;
    NSDateComponents *component = [calendar components:unitFlags fromDate:date];
    
    //今天周几
    NSInteger weekDay = [component weekday];
    //今天是几号
    NSInteger day = [component day];
    
    // 计算当前日期和本周的星期一和星期天相差天数
    long firstDiff,lastDiff;
    //    weekDay = 1;
    if (weekDay == 1)
    {
        firstDiff = -6;
        lastDiff = 0;
    }else{
        
        firstDiff = [calendar firstWeekday] - weekDay + 1;
        lastDiff = 8 - weekDay;
    }
    // 在当前日期基础上加上差的天数
    NSDateComponents *firstDayComp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay  fromDate:date];
    [firstDayComp setDay:day + firstDiff];
    NSDate * curWeekMondayDate = [calendar dateFromComponents:firstDayComp];
    
    NSDateComponents *lastDayComp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay   fromDate:date];
    [lastDayComp setDay:day + lastDiff];
    NSDate *curWeekSundayDate = [calendar dateFromComponents:lastDayComp];
    
    component.curWeekMondayDate = curWeekMondayDate;
    component.curWeekSundayDate = curWeekSundayDate;
    
    return component;
}


+ (NSDate *)dateFromComponents:(NSDateComponents *)comps {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setLocale:[NSLocale currentLocale]];
    NSDate *date = [calendar dateFromComponents:comps];
    return date;
}

+ (NSString *)compareCurrentTime:(NSString *)dateString withDateFormat:(NSString *)formatString {
    //把字符串转为NSdate
    if (!(formatString.length > 0)) {
        formatString = @"yyyy-MM-dd HH:mm:ss";
    }
    
    NSDate * timeDate = [self dateFromString:dateString withDateFormat:formatString];
    NSDate *currentDate = [NSDate date];
    NSDateComponents * timeDateComponents = [self componentFromDate:timeDate];
    NSDateComponents * currentDateComponents = [self componentFromDate:currentDate];
    
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:timeDate];
    long temp = 0;
    NSString *result;
    if (timeInterval/60 < 1)
    {
        result = [NSString stringWithFormat:@"刚刚"];
    }else if((temp = timeInterval/60) <30){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }else if (temp > 30 && temp < 60){
        result = [NSString stringWithFormat:@"半小时前"];
    }else if((temp = temp/60) <24 && currentDateComponents.day == timeDateComponents.day){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }else if (temp < 24 && currentDateComponents.day - timeDateComponents.day == 1){
        result = [NSString stringWithFormat:@"昨天"];
    }else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    return  result;
    
}

+ (NSDate *)getCurrentDate{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    return localeDate;
}


+ (NSDate *)sa_dateFromString:(NSString *)dateString dateFormat:(NSString *)formatString {
    
    NSDateFormatter *dateFormatter = [DYDate sharedDateFormatter];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    [dateFormatter setDateFormat:formatString];
    return [dateFormatter dateFromString:dateString];
}

+ (NSString *)sa_stringFromDate:(NSDate *)date dateFormat:(NSString *)formatString {
    NSDateFormatter *dateFormatter = [DYDate sharedDateFormatter];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    [dateFormatter setDateFormat:formatString];
    return [dateFormatter stringFromDate:date];
}


+ (NSString *)sa_stringFromTimestamp:(NSTimeInterval)timeInterval dateFormat:(NSString *)formatString {
    
    if (timeInterval > 10000000000.0) {
        timeInterval /=1000.0;
    }
    NSDateFormatter *dateFormatter = [DYDate sharedDateFormatter];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"asia/shanghai"]];
    [dateFormatter setDateFormat:formatString];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [dateFormatter stringFromDate:date];
}


+ (NSDateComponents *)sa_componentFromDate:(NSDate *)date {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setLocale:[NSLocale currentLocale]];
    NSCalendarUnit unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday;
    NSDateComponents *component = [calendar components:unitFlags fromDate:date];
    
    //今天周几
    NSInteger weekDay = [component weekday];
    //今天是几号
    NSInteger day = [component day];
    
    // 计算当前日期和本周的星期一和星期天相差天数
    long firstDiff,lastDiff;
    //    weekDay = 1;
    if (weekDay == 1)
    {
        firstDiff = -6;
        lastDiff = 0;
    }else{
        
        firstDiff = [calendar firstWeekday] - weekDay + 1;
        lastDiff = 8 - weekDay;
    }
    // 在当前日期基础上加上差的天数
    NSDateComponents *firstDayComp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay  fromDate:date];
    [firstDayComp setDay:day + firstDiff];
    NSDate * curWeekMondayDate = [calendar dateFromComponents:firstDayComp];
    
    NSDateComponents *lastDayComp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay   fromDate:date];
    [lastDayComp setDay:day + lastDiff];
    NSDate *curWeekSundayDate = [calendar dateFromComponents:lastDayComp];
    
    component.curWeekMondayDate = curWeekMondayDate;
    component.curWeekSundayDate = curWeekSundayDate;
    
    return component;}


+ (NSDate *)sa_dateFromComponents:(NSDateComponents *)comps {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setLocale:[NSLocale currentLocale]];
    NSDate *date = [calendar dateFromComponents:comps];
    return date;
}


+ (NSString *)sa_compareCurrentTime:(NSString *)dateString dateFormat:(NSString *)formatString {
    if (!(formatString.length > 0)) {
        formatString = @"yyyy-MM-dd HH:mm:ss";
    }
    
    NSDate * timeDate = [self dateFromString:dateString withDateFormat:formatString];
    NSDate *currentDate = [NSDate date];
    NSDateComponents * timeDateComponents = [self componentFromDate:timeDate];
    NSDateComponents * currentDateComponents = [self componentFromDate:currentDate];
    
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:timeDate];
    long temp = 0;
    NSString *result;
    if (timeInterval/60 < 1)
    {
        result = [NSString stringWithFormat:@"刚刚"];
    }else if((temp = timeInterval/60) <30){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }else if (temp > 30 && temp < 60){
        result = [NSString stringWithFormat:@"半小时前"];
    }else if((temp = temp/60) <24 && currentDateComponents.day == timeDateComponents.day){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }else if (temp < 24 && currentDateComponents.day - timeDateComponents.day == 1){
        result = [NSString stringWithFormat:@"昨天"];
    }else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    return  result;
    
}

@end


static char * const curWeekMondayDateKey = "com.wwwarehouse.www.curWeekMondayDateKey";
static char * const curWeekSundayKey = "com.wwwarehouse.www.curWeekSunday";

@implementation NSDateComponents (SAExtend)

- (void)setCurWeekMondayDate:(NSDate *)curWeekMondayDate {
    
    objc_setAssociatedObject(self, curWeekMondayDateKey, curWeekMondayDate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (NSDate *)curWeekMondayDate {
    
    return objc_getAssociatedObject(self, curWeekMondayDateKey);
    
}

- (void)setCurWeekSundayDate:(NSDate *)curWeekSundayDate {
    
    objc_setAssociatedObject(self, curWeekSundayKey, curWeekSundayDate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDate *)curWeekSundayDate {
    
    return objc_getAssociatedObject(self, curWeekSundayKey);
}


@end

