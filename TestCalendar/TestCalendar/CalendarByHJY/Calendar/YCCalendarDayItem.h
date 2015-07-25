//
//  YCCalendarDayItem.h
//  TestCalendar
//
//  Created by JyHu on 15/3/5.
//  Copyright (c) 2015年 JyHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCDateExtension.h"
#import "YCChineseCalendar.h"

typedef enum{
    YCCalendarDayTypeInMonthLastMoth,
    YCCalendarDayTypeInMonthCurrentMonth,
    YCCalendarDayTypeInMonthNextMonth
} YCCalendarDayTypeInMonth;

@interface YCCalendarDayItem : UIButton

@property (retain, nonatomic) NSDate *solarNSDate;

@property (assign, nonatomic) YCCalendarDayTypeInMonth dayTypeOfMonth;

@property (assign, nonatomic) id dayData;

@property (assign, nonatomic) BOOL cselected;

@property (assign, nonatomic) YCDateTime lunarDate;



@end
