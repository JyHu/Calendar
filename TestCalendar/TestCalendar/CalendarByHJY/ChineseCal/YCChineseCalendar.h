//
//  YCChineseCalendar.h
//  TestCalendar
//
//  Created by JyHu on 15/3/9.
//  Copyright (c) 2015年 JyHu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YCChineseCalStructs.h"

#define MinYear (1900)
#define MaxYear (2049)
//#define Debug 1


/**
 *  @author JyHu, 15-03-09 14:03:54
 *
 *  @brief  获取农历某一年闰几月
 *
 *  @param year 农历年份
 *
 *  @return 闰几月，如果为0表示不闰月
 */
NSInteger getLunarChineseYearLeapMonth(NSInteger year);

/**
 *  @author JyHu, 15-03-09 14:03:07
 *
 *  @brief  如果这一年有闰月的话，计算这个月多少天
 *
 *  @param year 要计算的年
 *
 *  @return 闰月的天数
 */
NSInteger getLunarChineseYearLeapMonthDays(NSInteger year);

/**
 *  @author JyHu, 15-03-09 14:03:46
 *
 *  @brief  计算阴历某一年的某一个月的天数
 *
 *  @param year  年份
 *  @param month 月份
 *
 *  @return 天数
 */
NSInteger getLunarChineseYearMonthDays(NSInteger year, NSInteger month);

/**
 *  @author JyHu, 15-03-09 14:03:23
 *
 *  @brief  计算阴历计数的年份的天数
 *
 *  @param year 年份
 *
 *  @return 天数
 */
NSInteger getLunarChineseYearDays(NSInteger year);

/**
 *  @author JyHu, 15-03-09 14:03:43
 *
 *  @brief  判断年份是否超过界限    1900 ~ 2049
 *
 *  @param year 年份
 *
 *  @return Bool
 */
BOOL checkYearLimit(NSInteger year);

/**
 *  @author JyHu, 15-03-09 09:03:02
 *
 *  @brief  计算从1900年1月30号到要计算的时间之间的天数
 *
 *  @param date 要计算的时间
 *
 *  @return 计算后的时间
 */
NSInteger getSolarChineseYearDaysFrom19000130(YCDateTime date);

/**
 *  @author JyHu, 15-03-09 14:03:02
 *
 *  @brief  判断阳历年是不是闰年
 *
 *  @param year 年份
 *
 *  @return Bool
 */
BOOL isSolarChineseYearIsLeapYear(NSInteger year);

/**
 *  @author JyHu, 15-03-09 14:03:50
 *
 *  @brief  阳历转换阴历
 *
 *  @param date 要转换的日期
 *
 *  @return 转换后的阴历日期
 */
YCDateTime solarDateToLunarDate(YCDateTime date);

/**
 *  @author JyHu, 15-03-09 14:03:18
 *
 *  @brief  把iOS的时间转换成我们的日期
 *
 *  @param date 要转换的日期
 *
 *  @return 自定义的日期
 */
YCDateTime iOSDateToYCDate(NSDate *date);

/**
 *  @author JyHu, 15-05-18 09:05:23
 *
 *  @brief  阳历的当前日期的下一天
 *
 *  @param date 阳历日期
 *
 *  @return 阳历日期
 */
YCDateTime solarNextDay(YCDateTime date);

YCDateTime solarLastDay(YCDateTime date);

YCDateTime solarNextMonth(YCDateTime date);

YCDateTime solarLastMonth(YCDateTime date);

YCLunarDate* lunarDate(YCDateTime date);

YCSolarHoliday *solarHolidayFromDate(YCDateTime date);

YCLunarHoliday *lunarHolidayFromDate(YCDateTime date);















@interface YCChineseCalendar : NSObject



@end
