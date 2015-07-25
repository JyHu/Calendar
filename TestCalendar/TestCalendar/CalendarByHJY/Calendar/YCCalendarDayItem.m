//
//  YCCalendarDayItem.m
//  TestCalendar
//
//  Created by JyHu on 15/3/5.
//  Copyright (c) 2015年 JyHu. All rights reserved.
//

#import "YCCalendarDayItem.h"

#define kDaySelectedColor ((UIColor *)[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2])

@interface YCCalendarDayItem()

@property (retain, nonatomic) UILabel *dayLabel;

@property (retain, nonatomic) UIImageView *daySelectedImageView;

@property (retain, nonatomic) UILabel *lunarCalendarLabel;

@property (retain, nonatomic) UILabel *workTypeLabel;

@property (retain, nonatomic) UIImageView *dayActivityImageView;

@end

@implementation YCCalendarDayItem

@synthesize solarNSDate = _solarNSDate;

@synthesize dayData = _dayData;

@synthesize dayTypeOfMonth = _dayTypeOfMonth;

@synthesize daySelectedImageView = _daySelectedImageView;

@synthesize cselected = _cselected;

@synthesize lunarDate = _lunarDate;

- (id)init
{
    self = [super init];
    
    if (self)
    {
        
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self package];
    }
    
    return self;
}

- (void)package
{
    CGSize size = self.frame.size;
    CGFloat dayTypeLabelMargin = 5;
    
    CGFloat tempWidth = size.width - dayTypeLabelMargin * 2;
    CGFloat tempYOrigin = dayTypeLabelMargin + (size.width - dayTypeLabelMargin * 2) / 2.0;
    CGFloat tempHeight = size.height - tempWidth / 2.0 - dayTypeLabelMargin;
    
    _daySelectedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(dayTypeLabelMargin, tempYOrigin, tempWidth, tempHeight)];
    self.cselected = NO;
    [self addSubview:_daySelectedImageView];
    
    _dayLabel = [self roundConnerLabelWithFrame:CGRectMake(dayTypeLabelMargin, dayTypeLabelMargin, size.width - dayTypeLabelMargin * 2, size.width - dayTypeLabelMargin * 2)];
    
    CGFloat scale = _dayLabel.frame.size.width / 42.0;
    CGFloat workTypeLabelLegth = 18 * scale;
    
    _dayLabel.font = [UIFont systemFontOfSize:22 * scale];
    _dayLabel.backgroundColor = arc4random()%2 ? [UIColor blueColor] : [UIColor clearColor];
    [self addSubview:_dayLabel];
    
    _workTypeLabel = [self roundConnerLabelWithFrame:CGRectMake(0, 0, workTypeLabelLegth, workTypeLabelLegth)];
    _workTypeLabel.text = @"假";
    _workTypeLabel.backgroundColor = [UIColor blueColor];
    _workTypeLabel.font = [UIFont systemFontOfSize:12 * scale];
    _workTypeLabel.alpha = 0;
    [self addSubview:_workTypeLabel];
    
    _lunarCalendarLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, size.width, size.width, 12 * scale)];
    _lunarCalendarLabel.textAlignment = NSTextAlignmentCenter;
    _lunarCalendarLabel.backgroundColor = [UIColor clearColor];
    _lunarCalendarLabel.textColor = [UIColor blueColor];
    _lunarCalendarLabel.text = @"十五";
    _lunarCalendarLabel.font = [UIFont systemFontOfSize:12 * scale];
    _lunarCalendarLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_lunarCalendarLabel];
    
    CGRect lunarRect = _lunarCalendarLabel.frame;
    if (lunarRect.origin.y + lunarRect.size.height > size.height)
    {
        lunarRect.origin.y = size.height - lunarRect.size.height;
    }
    _lunarCalendarLabel.frame = lunarRect;
}

- (UILabel *)roundConnerLabelWithFrame:(CGRect)frame
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = label.frame.size.height / 2.0;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor greenColor];
    
    label.adjustsFontSizeToFitWidth = YES;
    
    return label;
}

- (void)setSolarNSDate:(NSDate *)solarNSDate
{
    _solarNSDate = solarNSDate;
    _dayLabel.text = [NSString stringWithFormat:@"%ld",(long)[solarNSDate day]];
    YCDateTime ssolarDate = iOSDateToYCDate(solarNSDate);
    _lunarDate = solarDateToLunarDate(ssolarDate);
    YCLunarDate *date = lunarDate(_lunarDate);
    if (_lunarDate.day == 1)
    {
        _lunarCalendarLabel.text = date.month;
    }
    else
    {
        _lunarCalendarLabel.text = date.day;
    }
    
    YCLunarHoliday *lholiday = lunarHolidayFromDate(_lunarDate);
    
    if (!isLunarHolidayEqual(lholiday, lunarHolidayDefault()))
    {
        if (lholiday.recess > 0)
        {
            [self showHoliday:YES];
        }
        if (lholiday.month == _lunarDate.month && lholiday.day == _lunarDate.day)
        {
            _lunarCalendarLabel.text = lholiday.holidayName;
        }
    }
    else
    {
        YCSolarHoliday *sholiday = solarHolidayFromDate(ssolarDate);
        
        if (!isSolarHolidayEqual(sholiday, solarHolidayDefault()))
        {
            if (sholiday.recess > 0)
            {
                [self showHoliday:YES];
            }
            if (sholiday.month == solarNSDate.month && sholiday.day == solarNSDate.day)
            {
                _lunarCalendarLabel.text = sholiday.holidayName;
            }
        }
    }
}

- (void)setDayTypeOfMonth:(YCCalendarDayTypeInMonth)dayTypeOfMonth
{
    _dayTypeOfMonth = dayTypeOfMonth;
    
    if (dayTypeOfMonth != YCCalendarDayTypeInMonthCurrentMonth)
    {
        _dayLabel.textColor = [UIColor grayColor];
        _lunarCalendarLabel.textColor = [UIColor grayColor];
    }
}

- (void)setCselected:(BOOL)cselected
{
    _cselected = cselected;
    
    if (cselected)
    {
        _daySelectedImageView.backgroundColor = kDaySelectedColor;
    }
    else
    {
        _daySelectedImageView.backgroundColor = [UIColor clearColor];
    }
}

- (BOOL)cselected
{
    return _cselected;
}

- (void)showHoliday:(BOOL)show
{
    _workTypeLabel.alpha = show ? 100 : 0;
}

@end
