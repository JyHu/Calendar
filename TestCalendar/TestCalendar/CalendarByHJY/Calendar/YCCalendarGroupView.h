//
//  YCCalendarGroupView.h
//  TestCalendar
//
//  Created by JyHu on 15/3/6.
//  Copyright (c) 2015年 JyHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCCalendarView.h"
#import "YCCalendarGroupDelegate.h"

@interface YCCalendarGroupView : UIView

@property (retain, nonatomic) NSDate *calendarDate;

- (id)initWithFrame:(CGRect)frame date:(NSDate *)date delegate:(id<YCCalendarDelegate,YCCalendarGroupDelegate>)delegate;

- (void)turnedToCalendarWithDate:(NSDate *)date;

- (void)turnedToLastMonth;

- (void)turnedToCurrentMonth;

- (void)turnedToNextMonth;

@property (assign, nonatomic, readonly) CGFloat absoluteHeight;

@end
