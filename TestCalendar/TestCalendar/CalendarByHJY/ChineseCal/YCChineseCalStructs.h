//
//  YCChineseCalStructs.h
//  TestCalendar
//
//  Created by JyHu on 15/3/9.
//  Copyright (c) 2015年 JyHu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YCLunarDate.h"
#import "YCLunarHoliday.h"
#import "YCSolarHoliday.h"

typedef enum{
    YCCalErrorYearOut = -1,
} YCCalError;

typedef enum{
    YCDateTimeTypeLunar,    /* 阴历*/
    YCDateTimeTypeSolar     /* 阳历 */
} YCDateTimeType;

struct YCDateTime {
    NSInteger year;
    NSInteger month;
    NSInteger day;
    YCDateTimeType type;
};

typedef struct YCDateTime YCDateTime;

YCDateTime YCDateTimeMake(NSInteger year, NSInteger month, NSInteger day);

YCDateTime YCDateTimeStarter();

YCLunarDate *lunarDateMake(NSString *year, NSString *month, NSString *day);

YCLunarHoliday *lunarHolidayMake(NSInteger month, NSInteger day, NSInteger recess, NSString *holidayName);

YCLunarHoliday *lunarHolidayDefault();

BOOL isLunarHolidayEqual(YCLunarHoliday *holiday1, YCLunarHoliday *holiday2);

YCSolarHoliday *solarHolidayMake(NSInteger month, NSInteger day, NSInteger recess, NSString *holidayName);

YCSolarHoliday *solarHolidayDefault();

BOOL isSolarHolidayEqual(YCSolarHoliday *holiday1, YCSolarHoliday *holiday2);

@interface YCChineseCalStructs : NSObject

@end


@interface NSDate(YCChineseCalendarDateExtension)

@property (assign, nonatomic, readonly) NSInteger calYear;

@property (assign, nonatomic, readonly) NSInteger calMonth;

@property (assign, nonatomic, readonly) NSInteger calDay;

@end