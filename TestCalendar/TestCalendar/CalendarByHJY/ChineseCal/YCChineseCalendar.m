//
//  YCChineseCalendar.m
//  TestCalendar
//
//  Created by JyHu on 15/3/9.
//  Copyright (c) 2015年 JyHu. All rights reserved.
//

#import "YCChineseCalendar.h"
#import "YCDateExtension.h"

int lunarInfo[]={   /*阴历数据*/
    0x04bd8,0x04ae0,0x0a570,0x054d5,0x0d260,0x0d950,0x16554,0x056a0,0x09ad0,0x055d2,
    0x04ae0,0x0a5b6,0x0a4d0,0x0d250,0x1d255,0x0b540,0x0d6a0,0x0ada2,0x095b0,0x14977,
    0x04970,0x0a4b0,0x0b4b5,0x06a50,0x06d40,0x1ab54,0x02b60,0x09570,0x052f2,0x04970,
    0x06566,0x0d4a0,0x0ea50,0x06e95,0x05ad0,0x02b60,0x186e3,0x092e0,0x1c8d7,0x0c950,
    0x0d4a0,0x1d8a6,0x0b550,0x056a0,0x1a5b4,0x025d0,0x092d0,0x0d2b2,0x0a950,0x0b557,
    0x06ca0,0x0b550,0x15355,0x04da0,0x0a5d0,0x14573,0x052d0,0x0a9a8,0x0e950,0x06aa0,
    0x0aea6,0x0ab50,0x04b60,0x0aae4,0x0a570,0x05260,0x0f263,0x0d950,0x05b57,0x056a0,
    0x096d0,0x04dd5,0x04ad0,0x0a4d0,0x0d4d4,0x0d250,0x0d558,0x0b540,0x0b5a0,0x195a6,
    0x095b0,0x049b0,0x0a974,0x0a4b0,0x0b27a,0x06a50,0x06d40,0x0af46,0x0ab60,0x09570,
    0x04af5,0x04970,0x064b0,0x074a3,0x0ea50,0x06b58,0x055c0,0x0ab60,0x096d5,0x092e0,
    0x0c960,0x0d954,0x0d4a0,0x0da50,0x07552,0x056a0,0x0abb7,0x025d0,0x092d0,0x0cab5,
    0x0a950,0x0b4a0,0x0baa4,0x0ad50,0x055d9,0x04ba0,0x0a5b0,0x15176,0x052b0,0x0a930,
    0x07954,0x06aa0,0x0ad50,0x05b52,0x04b60,0x0a6e6,0x0a4e0,0x0d260,0x0ea65,0x0d530,
    0x05aa0,0x076a3,0x096d0,0x04bd7,0x04ad0,0x0a4d0,0x1d0b6,0x0d250,0x0d520,0x0dd45,
    0x0b5a0,0x056d0,0x055b2,0x049b0,0x0a577,0x0a4b0,0x0aa50,0x1b255,0x06d20,0x0ada0};

int solarMonth[2][13] = {{0,31,28,31,30,31,30,31,31,30,31,30,31},
                         {0,31,29,31,30,31,30,31,31,30,31,30,31}};

char *numberString[31] = {"零", "一", "二", "三", "四", "五", "六", "七", "八", "九", "十", "十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八", "十九", "二十", "廿一", "廿二", "廿三", "廿四", "廿五", "廿六", "廿七", "廿八", "廿九", "三十"};

NSInteger getLunarChineseYearLeapMonth(NSInteger year)
{
    //  从1~12，注意，不是从0开始，0表示无闰月
    
    return lunarInfo[year - MinYear]&0xF;
}

NSInteger getLunarChineseYearLeapMonthDays(NSInteger year)
{
    if (getLunarChineseYearLeapMonth(year) == 0)
    {
        return 0;
    }
    
    //  要先计算出是闰大月还是小月，取前四位，但是必须跟最后四位配合使用。
    //  为1为闰大月，为0为闰小月
    
    int type = lunarInfo[year - MinYear]&0xF0000;
    
    return type ? 30 : 29;
}

NSInteger getLunarChineseYearMonthDays(NSInteger year, NSInteger month)
{
    //  month从1开始
    //
    //  判断传进来的是不是0月，是为了避免出现误传参数，月份是从高位开始算
    //  15  14  13  12  ...     7   6   5   4       二进制位
    //   1   2   3   3          9  10  11  12       月份
    //  0x8000 = 1000 0000 0000 0000
    
    NSInteger days = month == 0 ? 0 : (lunarInfo[year - MinYear]&(0x8000>>(month - 1)) ? 30 : 29);
    
//    printf("days ----%ld -- %ld------  %ld\n",year, month,days);
    
    return days;
}

NSInteger getLunarChineseYearDays(NSInteger year)
{
    int sumDays = 0;
    
    for (int i = 1; i <= 12; i ++)
    {
        //  从1月到12月累加计算这年的正常的天数
        
        sumDays += getLunarChineseYearMonthDays(year, i);
    }
    
    //  结果加上闰月的天数
    return sumDays + getLunarChineseYearLeapMonthDays(year);
}

BOOL checkYearLimit(NSInteger year)
{
    if (year >= MinYear && year <= MaxYear)
    {
        /**
         *  @author JyHu, 15-03-09 14:03:05
         *
         *  @brief  合法
         */
        return YES;
    }
    
    return NO;
}

NSInteger getSolarChineseYearDaysFrom19000130(YCDateTime date)
{
    NSInteger count = 0;
    
    for (NSInteger i = YCDateTimeStarter().year; i < date.year; i ++)
    {
        count += isSolarChineseYearIsLeapYear(i) ? 366 : 365;
    }
    
    if (date.month == 1)
    {
        count -= (YCDateTimeStarter().day - date.day);
    }
    else
    {
        for (NSInteger i = 1; i < date.month; i++)
        {
            count += solarMonth[isSolarChineseYearIsLeapYear(date.year)][i];
        }
        count += (date.day - YCDateTimeStarter().day);
    }
    
    return count;
}

BOOL isSolarChineseYearIsLeapYear(NSInteger year)
{
    return ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) ? 1 : 0;
}

YCDateTime solarDateToLunarDate(YCDateTime date)
{
    YCDateTime dt = YCDateTimeStarter();
    
    BOOL hadCountLeapMonth = NO;
    
    NSInteger day = getSolarChineseYearDaysFrom19000130(date);
    
    while (day > 13 * 30)
    {
        
#ifdef Debug
        printf("Y - day:%.6ld    %.4ld-%.2ld-%.2ld\n",day, dt.year, dt.month, dt.day);
#endif
        
        day -= getLunarChineseYearDays(dt.year);
        dt.year ++;
    }
    
    while (day > 30)
    {
        
#if Debug
        printf("M - day:%.6ld    %.4ld-%.2ld-%.2ld\n",day, dt.year, dt.month, dt.day);
#endif
        
        day -= getLunarChineseYearMonthDays(dt.year, dt.month);
        
        if (!hadCountLeapMonth && getLunarChineseYearLeapMonth(dt.year) == dt.month)
        {
            hadCountLeapMonth = YES;
            
            continue;
        }
        
        dt.month ++;
        
        if (dt.month > 12)
        {
            dt.month = 1;
            dt.year ++;
        }
    }
    
    NSInteger lunarMonthDays = getLunarChineseYearMonthDays(dt.year, dt.month);
    
    while (day > lunarMonthDays)
    {
        
#ifdef Debug
        printf("D - day:%.6ld    %.4ld-%.2ld-%.2ld\n",day, dt.year, dt.month, dt.day);
#endif
        
        day -= lunarMonthDays;
        dt.month ++;
        
        if (dt.month > 12)
        {
            dt.month = 1;
            dt.year ++;
        }
    }
    
#ifdef Debug
    printf("L - day:%.6ld    %.4ld-%.2ld-%.2ld\n",day, dt.year, dt.month, dt.day);
#endif
    
    dt.day = day;
    
    if (dt.month > 12)
    {
        dt.month = 1;
        dt.year += 1;
    }
    
    dt.type = YCDateTimeTypeLunar;
    
    return dt;
}

YCDateTime iOSDateToYCDate(NSDate *date)
{
    return YCDateTimeMake(date.calYear, date.calMonth, date.calDay);
}

YCDateTime solarNextDay(YCDateTime date)
{
    date.day += 1;
    
    if (date.day > solarMonth[isSolarChineseYearIsLeapYear(date.year)][date.month])
    {
        date.day = 1;
        
        date.month += 1;
        
        if (date.month > 12)
        {
            date.month = 1;
            
            date.year += 1;
        }
    }
    
    return date;
}

YCDateTime solarLastDay(YCDateTime date)
{
    date.day -= 1;
    
    if (date.day < 1)
    {
        date.month -= 1;
        
        if (date.month < 1)
        {
            date.month = 12;
            
            date.year -= 1;
        }
        
        date.day = solarMonth[isSolarChineseYearIsLeapYear(date.year)][date.month];
    }
    
    return date;
}

YCDateTime solarNextMonth(YCDateTime date)
{
    date.month += 1;
    
    if (date.month > 12)
    {
        date.month = 1;
        
        date.year += 1;
    }
    
    int standardCurMonthDay = solarMonth[isSolarChineseYearIsLeapYear(date.year)][date.month];
    
    if (date.day > standardCurMonthDay)
    {
        date.day = standardCurMonthDay;
    }
    
    return date;
}

YCDateTime solarLastMonth(YCDateTime date)
{
    date.month -= 1;
    
    if (date.month < 1)
    {
        date.month = 12;
        
        date.year -= 1;
    }
    
    int standardCurMonthDay = solarMonth[isSolarChineseYearIsLeapYear(date.year)][date.month];
    
    if (date.day > standardCurMonthDay)
    {
        date.day = standardCurMonthDay;
    }
    
    return date;
}

YCLunarDate* lunarDate(YCDateTime date)
{
    NSString *syear = @"";
    NSInteger iyear = date.year;
    for (int i=0; i<4; i++)
    {
        int t = iyear % 10;
        iyear = iyear / 10;
        syear = [NSString stringWithFormat:@"%@%@",[[NSString alloc] initWithUTF8String:numberString[t]],syear];
    }
    
    NSInteger imonth = date.month;
    NSString *smonth = [NSString stringWithFormat:@"%@月",[[NSString alloc] initWithUTF8String:numberString[imonth]]];
    
    NSInteger iday = date.day;
    NSString *sday = iday > 10 ? [[NSString alloc] initWithUTF8String:numberString[iday]] : [NSString stringWithFormat:@"初%@",[[NSString alloc] initWithUTF8String:numberString[iday]]];
    
    return lunarDateMake(syear, smonth, sday);
}

YCSolarHoliday *solarHolidayFromDate(YCDateTime date)
{
    if (date.type == YCDateTimeTypeLunar)
    {
        return solarHolidayDefault();
    }
    
    static NSMutableArray *holidayArr;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        holidayArr = [[NSMutableArray alloc] init];
        
        [holidayArr addObject:solarHolidayMake(1, 1, 1, @"元旦")];
        [holidayArr addObject:solarHolidayMake(2, 14, 0, @"情人节")];
        [holidayArr addObject:solarHolidayMake(3, 8, 0, @"妇女节")];
        [holidayArr addObject:solarHolidayMake(3, 12, 0, @"植树节")];
        [holidayArr addObject:solarHolidayMake(3, 15, 0, @"消费者权益日")];
        [holidayArr addObject:solarHolidayMake(4, 1, 0, @"愚人节")];
        [holidayArr addObject:solarHolidayMake(5, 1, 3, @"劳动节")];
        [holidayArr addObject:solarHolidayMake(5, 4, 0, @"青年节")];
        [holidayArr addObject:solarHolidayMake(6, 1, 0, @"国际儿童节")];
        [holidayArr addObject:solarHolidayMake(7, 1, 0, @"建党节")];
        [holidayArr addObject:solarHolidayMake(8, 1, 0, @"建军节")];
        [holidayArr addObject:solarHolidayMake(9, 10, 0, @"教师节")];
        [holidayArr addObject:solarHolidayMake(10, 1, 7, @"国庆节")];
        [holidayArr addObject:solarHolidayMake(12, 25, 0, @"圣诞节")];
    });
    
    for (NSInteger i=0; i<holidayArr.count; i++)
    {
        YCSolarHoliday *holiday = [holidayArr objectAtIndex:i];
        
        if (holiday.month == date.month)
        {
            if (date.day >= holiday.day && date.day <= holiday.day + (holiday.recess >= 1 ? holiday.recess - 1 : holiday.recess))
            {
                return holiday;
            }
        }
    }
    
    return solarHolidayDefault();
}

YCLunarHoliday *lunarHolidayFromDate(YCDateTime date)
{
    if (date.type == YCDateTimeTypeSolar)
    {
        return lunarHolidayDefault();
    }
    
    static NSMutableArray *holidayArr;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        holidayArr = [[NSMutableArray alloc] init];
        
        [holidayArr addObject:lunarHolidayMake(1, 1, 7, @"春节")];
        [holidayArr addObject:lunarHolidayMake(1, 15, 0, @"元宵节")];
        [holidayArr addObject:lunarHolidayMake(5, 5, 0, @"端午节")];
        [holidayArr addObject:lunarHolidayMake(7, 7, 0, @"七夕情人节")];
        [holidayArr addObject:lunarHolidayMake(7, 15, 0, @"中元节")];
        [holidayArr addObject:lunarHolidayMake(8, 15, 0, @"中秋节")];
        [holidayArr addObject:lunarHolidayMake(9, 9, 0, @"重阳节")];
        [holidayArr addObject:lunarHolidayMake(12, 8, 0, @"腊八节")];
        [holidayArr addObject:lunarHolidayMake(12, 23, 0, @"北方小年(扫房)")];
        [holidayArr addObject:lunarHolidayMake(12, 24, 0, @"南方小年(掸尘)")];
    });
    
    for (NSInteger i =0; i<holidayArr.count; i++)
    {
        YCLunarHoliday *holiday = [holidayArr objectAtIndex:i];
        
        if (holiday.month == date.month)
        {
            if (date.day >= holiday.day && date.day <= holiday.day + holiday.recess - 1)
            {
                return holiday;
            }
        }
    }
    
    return lunarHolidayDefault();
}

























@implementation YCChineseCalendar

@end
