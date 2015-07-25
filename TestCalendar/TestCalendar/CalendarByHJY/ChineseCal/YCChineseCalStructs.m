//
//  YCChineseCalStructs.m
//  TestCalendar
//
//  Created by JyHu on 15/3/9.
//  Copyright (c) 2015年 JyHu. All rights reserved.
//

#import "YCChineseCalStructs.h"

YCDateTime YCDateTimeMake(NSInteger year, NSInteger month, NSInteger day)
{
    YCDateTime date;
    
    date.year = year;
    date.month = month;
    date.day = day;
    date.type = YCDateTimeTypeSolar;
    
    return date;
}

YCDateTime YCDateTimeStarter()
{
    return YCDateTimeMake(1900, 1, 30);
}

YCLunarDate *lunarDateMake(NSString *year, NSString *month, NSString *day)
{
    YCLunarDate *date = [[YCLunarDate alloc] init];
    
    date.year = year;
    date.month = month;
    date.day = day;
    
    return date;
}

YCLunarHoliday *lunarHolidayMake(NSInteger month, NSInteger day, NSInteger recess, NSString *holidayName)
{
    YCLunarHoliday *holiday = [[YCLunarHoliday alloc] init];
    
    holiday.month = month;
    holiday.day = day;
    holiday.recess = recess;
    holiday.holidayName = holidayName;
    
    return holiday;
}

YCSolarHoliday *solarHolidayMake(NSInteger month, NSInteger day, NSInteger recess, NSString *holidayName)
{
    YCSolarHoliday *holiday = [[YCSolarHoliday alloc] init];
    
    holiday.month = month;
    holiday.day = day;
    holiday.recess = recess;
    holiday.holidayName = holidayName;
    
    return holiday;
}

YCLunarHoliday *lunarHolidayDefault()
{
    YCLunarHoliday *holiday = [[YCLunarHoliday alloc] init];
    
    holiday.month = -1;
    holiday.day = -1;
    holiday.recess = -1;
    holiday.holidayName = nil;
    
    return holiday;
}

YCSolarHoliday *solarHolidayDefault()
{
    YCSolarHoliday *holiday = [[YCSolarHoliday alloc] init];
    
    holiday.month = -1;
    holiday.day = -1;
    holiday.recess = -1;
    holiday.holidayName = nil;
    
    return holiday;
}

BOOL isLunarHolidayEqual(YCLunarHoliday *holiday1, YCLunarHoliday *holiday2)
{
    if (holiday1.month == holiday2.month && holiday1.day == holiday2.day && holiday1.recess == holiday2.recess)
    {
        return YES;
    }
    return NO;
}

BOOL isSolarHolidayEqual(YCSolarHoliday *holiday1, YCSolarHoliday *holiday2)
{
    if (holiday1.month == holiday2.month && holiday1.day == holiday2.day && holiday1.recess == holiday2.recess)
    {
        return YES;
    }
    return NO;
}

@implementation YCChineseCalStructs

@end


@implementation NSDate(YCChineseCalendarDateExtension)

- (NSDateComponents *)dateComponents
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger unitFlat = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit ;
    NSDateComponents *comp = [calendar components:unitFlat fromDate:self];
    
    return comp;
}

- (NSInteger)calYear
{
    NSInteger year = [[self dateComponents] year];
    return year;
}

- (NSInteger)calMonth
{
    NSInteger month = [[self dateComponents] month];
    return month;
}

- (NSInteger)calDay
{
    NSInteger day = [[self dateComponents] day];
    return day;
}

@end