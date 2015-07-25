//
//  YCCalendarGroupView.m
//  TestCalendar
//
//  Created by JyHu on 15/3/6.
//  Copyright (c) 2015年 JyHu. All rights reserved.
//

#import "YCCalendarGroupView.h"
#import "YCCustomCalendarScrollView.h"

@interface YCCalendarGroupView()<UIScrollViewDelegate>

@property (retain, nonatomic) YCCustomCalendarScrollView *calendarGroup;

@property (retain, nonatomic) YCCalendarDayItem *selectedDayItem;

@property (retain, nonatomic) YCCalendarView *leftCalendar;

@property (retain, nonatomic) YCCalendarView *centerCalendar;

@property (retain, nonatomic) YCCalendarView *rightCalendar;

@property (retain, nonatomic) NSMutableDictionary *cacheCalendarDict;

@property (assign, nonatomic) id delegate;

@end

@implementation YCCalendarGroupView

@synthesize calendarGroup = _calendarGroup;

@synthesize selectedDayItem = _selectedDayItem;

@synthesize leftCalendar = _leftCalendar;

@synthesize centerCalendar = _centerCalendar;

@synthesize rightCalendar = _rightCalendar;

@synthesize cacheCalendarDict = _cacheCalendarDict;

@synthesize calendarDate = _calendarDate;

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame date:(NSDate *)date delegate:(id<YCCalendarDelegate,YCCalendarGroupDelegate>)delegate
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        _calendarDate = date;
        _delegate = delegate;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        
        [self initialize];
    }
    
    return self;
}

- (void)initialize
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectedDayItem:) name:tNotification_DidSelectedDayItem object:nil];
    
    self.cacheCalendarDict = [[NSMutableDictionary alloc] init];
    
    self.calendarGroup = [[YCCustomCalendarScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.calendarGroup.delegate = self;
    self.calendarGroup.pagingEnabled = YES;
    self.calendarGroup.delaysContentTouches = NO;
    self.calendarGroup.panGestureRecognizer.delaysTouchesBegan = YES;
    self.calendarGroup.contentSize = CGSizeMake(self.frame.size.width * 3, self.frame.size.height);
    self.calendarGroup.backgroundColor = [UIColor clearColor];
    self.calendarGroup.showsHorizontalScrollIndicator = NO;
    self.calendarGroup.bounces = NO;
    [self addSubview:self.calendarGroup];
    
    
    [self setCurrentCalendarDate];
    
    [self scrollViewDidEndDecelerating:self.calendarGroup];
}

- (void)setCurrentCalendarDate
{
    if (_leftCalendar)
    {
        [_leftCalendar removeFromSuperview];
        _leftCalendar = nil;
    }
    if (_centerCalendar)
    {
        [_centerCalendar removeFromSuperview];
        _centerCalendar = nil;
    }
    if (_rightCalendar)
    {
        [_rightCalendar removeFromSuperview];
        _rightCalendar = nil;
    }
    
    [self makeUp];
}

- (void)makeUp
{
    CGSize size = self.frame.size;
    
    NSString *leftCalCacheString    = [[self.calendarDate lastMonth] yyyyMMddString];
    NSString *centerCalCacheString  = [self.calendarDate yyyyMMddString];
    NSString *rightCalCacheString   = [[self.calendarDate nextMonth] yyyyMMddString];
    
    CGRect leftCalFrame     = CGRectMake(0, 0, size.width, size.height);
    CGRect centerCalFrame   = CGRectMake(size.width, 0, size.width, size.height);
    CGRect rightCalFrame    = CGRectMake(size.width * 2, 0, size.width, size.height);
    
    _leftCalendar = [self.cacheCalendarDict objectForKey:leftCalCacheString];
    
    if (!_leftCalendar)
    {
        _leftCalendar = [[YCCalendarView alloc] initWithFrame:leftCalFrame date:[self.calendarDate lastMonth] delegate:_delegate];
        [_cacheCalendarDict setObject:_leftCalendar forKey:leftCalCacheString];
    }
    else
    {
        _leftCalendar.frame = leftCalFrame;
    }
    
    _centerCalendar = [self.cacheCalendarDict objectForKey:centerCalCacheString];
    
    if (!_centerCalendar)
    {
        _centerCalendar = [[YCCalendarView alloc] initWithFrame:centerCalFrame date:self.calendarDate delegate:_delegate];
        [_cacheCalendarDict setObject:_centerCalendar forKey:centerCalCacheString];
    }
    else
    {
        _centerCalendar.frame = centerCalFrame;
    }
    
    _rightCalendar = [self.cacheCalendarDict objectForKey:rightCalCacheString];
    
    if (!_rightCalendar)
    {
        _rightCalendar = [[YCCalendarView alloc] initWithFrame:rightCalFrame date:[self.calendarDate nextMonth] delegate:_delegate];
        [_cacheCalendarDict setObject:_rightCalendar forKey:rightCalCacheString];
    }
    else
    {
        _rightCalendar.frame = rightCalFrame;
    }
    
    for (YCCalendarView *calendar in @[_leftCalendar, _centerCalendar, _rightCalendar])
    {
        [self.calendarGroup addSubview:calendar];
    }
    
    [self.calendarGroup setContentOffset:CGPointMake(self.calendarGroup.frame.size.width, 0)];
}

- (void)turnedToCalendarWithDate:(NSDate *)date
{
    self.calendarDate = date;
    [self setCurrentCalendarDate];
}

- (void)turnedToLastMonth
{
    [self turnedToCalendarWithDate:[self.calendarDate lastMonth]];
}

- (void)turnedToNextMonth
{
    [self turnedToCalendarWithDate:[self.calendarDate nextMonth]];
}

- (void)turnedToCurrentMonth
{
    [self turnedToCalendarWithDate:[NSDate date]];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x > self.frame.size.width)
    {
        self.calendarDate = [self.calendarDate nextMonth];
    }
    else if (scrollView.contentOffset.x < self.frame.size.width)
    {
        self.calendarDate = [self.calendarDate lastMonth];
    }
    
    [self setCurrentCalendarDate];
    
    if ([self.delegate respondsToSelector:@selector(calendarGroupDidScrollingEnd:)])
    {
        [self.delegate calendarGroupDidScrollingEnd:self];
    }
}

- (void)setSelectedDayItem:(YCCalendarDayItem *)selectedDayItem
{
    if (selectedDayItem.dayTypeOfMonth != YCCalendarDayTypeInMonthCurrentMonth)
    {
        if (selectedDayItem.dayTypeOfMonth == YCCalendarDayTypeInMonthLastMoth)
        {
            [self turnedToLastMonth];
        }
        else
        {
            [self turnedToNextMonth];
        }
        return;
    }
    
    selectedDayItem.cselected = YES;
    
    if (_selectedDayItem)
    {
        if ([self.delegate respondsToSelector:@selector(calendarGroup:didDeSelectedDayItem:)])
        {
            [self.delegate calendarGroup:self didDeSelectedDayItem:_selectedDayItem];
        }
        
        _selectedDayItem.cselected = NO;
    }
    
    _selectedDayItem = selectedDayItem;
}

- (void)didSelectedDayItem:(NSNotification *)notify
{
    YCCalendarDayItem *item = (YCCalendarDayItem *)notify.object;
    
    if (item.dayTypeOfMonth != YCCalendarDayTypeInMonthCurrentMonth)
    {
        if (item.dayTypeOfMonth == YCCalendarDayTypeInMonthLastMoth)
        {
            [self turnedToLastMonth];
        }
        else
        {
            [self turnedToNextMonth];
        }
        return;
    }
    
    item.cselected = YES;
    
    if (_selectedDayItem)
    {
        if ([self.delegate respondsToSelector:@selector(calendarGroup:didDeSelectedDayItem:)])
        {
            [self.delegate calendarGroup:self didDeSelectedDayItem:_selectedDayItem];
        }
        
        _selectedDayItem.cselected = NO;
    }
    
    _selectedDayItem = item;
}

- (CGFloat)absoluteHeight
{
    return self.centerCalendar.height;
}

@end





































