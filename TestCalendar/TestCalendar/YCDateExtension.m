//
//  YCDateExtension.m
//  Shecare
//
//  Created by JyHu on 15-1-8.
//  Copyright (c) 2015年 JyHu. All rights reserved.
//

#import "YCDateExtension.h"

@implementation NSDate(YCDateExtension)

- (NSDateComponents *)dateComponents
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger unitFlag = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
    NSDateComponents *comp = [calendar components:unitFlag fromDate:self];
    
    return comp;
}

- (NSRange)dateRangeBetweenMonthAndDay
{
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [currentCalendar setFirstWeekday:1];
    [currentCalendar setMinimumDaysInFirstWeek:7];
    
    NSRange dateRange = [currentCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[self monthBegin]];
    
    return dateRange;
}

- (NSInteger)year
{
    return [[self dateComponents] year];
}

- (NSInteger)month
{
    return [[self dateComponents] month];
}

- (NSInteger)day
{
    return [[self dateComponents] day];
}

- (NSInteger)hour
{
    return [[self dateComponents] hour];
}

- (NSInteger)minute
{
    return [[self dateComponents] minute];
}

- (NSInteger)seconds
{
    return [[self dateComponents] second];
}

- (NSString *)weekdayString
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:(NSWeekdayCalendarUnit) fromDate:self];
    NSInteger weekday = [components weekday];
    NSArray *array = @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"];
    
    return [array objectAtIndex:weekday];
}

- (NSInteger)daysOfMonth
{
    return [self dateRangeBetweenMonthAndDay].length;
}

- (NSDate *)dayBegin
{
    NSInteger offsetSecond = (self.hour * 60 + self.minute) * 60 + self.seconds;
    
    return [self dateByAddingTimeInterval:(-1 * offsetSecond)];
}

- (NSDate *)dayEnd
{
    return [[self dayBegin] dateByAddingTimeInterval:kYC_DAY_TIME_INTERVAL];
}

- (NSDate *)monthBegin
{
    NSString *dateString = [NSString stringWithFormat:@"%.4ld-%.2ld-01 12:00:00",self.year,self.month];
    
    return [self dateWithyyyyMMddHHmmssString:dateString];
}

- (NSDate *)dateWithyyyyMMddHHmmssString:(NSString *)yyyyMMddHHmmss
{
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setLocale:[NSLocale currentLocale]];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formater dateFromString:yyyyMMddHHmmss];
    
    return date;
}

- (NSInteger)firstDayWeekOfCurMonth
{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    
    [calendar setFirstWeekday:1];
    [calendar setMinimumDaysInFirstWeek:7];
    
//    NSDate *firstDayInMonth = [NSDate makeADateWithYear:[self year] month:[self month] day:1];
    
    NSDate *firstDayInMonth = [NSDate dateWithyyyyMMddString:[NSString stringWithFormat:@"%.4ld-%.2ld-01",[self year], [self month]]];
    
//#ifdef IS_IOS8
    NSInteger weekDay = [calendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayInMonth];
//#else
//    NSInteger weekDay = [calendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSWeekCalendarUnit forDate:firstDayInMonth];
//#endif
    
    return weekDay;
}

- (NSDate *)lastMonth
{
    NSInteger curYear = self.year;
    NSInteger curMonth = self.month;
    
    curMonth -= 1;
    
    if (curMonth <= 0)
    {
        curMonth = 12;
        curYear -= 1;
    }
    
    NSString *dateString = [NSString stringWithFormat:@"%.4ld-%.2ld-01 12:00:00",curYear,curMonth];
    
    return [self dateWithyyyyMMddHHmmssString:dateString];
}

- (NSDate *)nextMonth
{
    NSInteger curYear = self.year;
    NSInteger curMonth = self.month;
    
    curMonth += 1;
    
    if (curMonth > 12)
    {
        curMonth = 1;
        curYear += 1;
    }
    
    NSString *dateString = [NSString stringWithFormat:@"%.4ld-%.2ld-01 12:00:00",curYear,curMonth];
    
    return [self dateWithyyyyMMddHHmmssString:dateString];
}

+ (NSDate *)dateWithyyyyMMddString:(NSString *)yyyyMMddString
{
    NSDateFormatter *dateFormate = [[NSDateFormatter alloc] init];
    [dateFormate setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormate setDateFormat:@"yyyy-MM-dd"];
    
    return [[dateFormate dateFromString:yyyyMMddString] dateByAddingTimeInterval:[[NSTimeZone systemTimeZone] secondsFromGMT]];
}

- (NSString *)yyyyMMddString
{
    return [NSString stringWithFormat:@"%.4ld-%.2ld-%.2ld",self.year, self.month, self.day];
}

@end
