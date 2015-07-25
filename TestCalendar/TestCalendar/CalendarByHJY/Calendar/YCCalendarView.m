//
//  YCCalendarView.m
//  TestCalendar
//
//  Created by JyHu on 15/3/5.
//  Copyright (c) 2015年 JyHu. All rights reserved.
//

#import "YCCalendarView.h"

/**
 *  @author JyHu, 15-03-26 16:03:25
 *
 *  @brief  如果是使用VFL的话，能够适配的布局，但是没有摆放控件
 */
//#define USING_VFL (YES)

@interface YCCalendarView()
{
    NSInteger controlTag;
}

@property (retain, nonatomic) NSDate *calenDate;

@property (assign, nonatomic) id delegate;

@end

@implementation YCCalendarView

@synthesize calenDate;

- (id)initWithDate:(NSDate *)date delegate:(id<YCCalendarDelegate>)delegate
{
    self = [super init];
    
    if (self)
    {
        self.calenDate = date;
        self.delegate = delegate;
        controlTag = 9999;
        [self package];
        self.clipsToBounds = YES;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame date:(NSDate *)date delegate:(id<YCCalendarDelegate>)delegate
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.frame = frame;
        self.calenDate = date;
        self.delegate = delegate;
        controlTag = 9999;
        [self package];
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)package
{
    CGSize size = self.frame.size;
    
    YCCalendarSpacingControl spacingControl;
    
    if ([self.delegate respondsToSelector:@selector(spacingControlForCalendar:)])
    {
        spacingControl = [self.delegate spacingControlForCalendar:self];
    }
    else
    {
        spacingControl = YCCalendarSpacingControlMake(5, 5, 5, 5, 5);
    }
    
    CGFloat weekTitleHeight;
    
    if ([self.delegate respondsToSelector:@selector(heightForWeekTitleOfCalendar:)])
    {
        weekTitleHeight = [self.delegate heightForWeekTitleOfCalendar:self];
    }
    else
    {
        weekTitleHeight = 30;
    }
    
#ifndef USING_VFL
    CGFloat perWidth = (size.width - spacingControl.leftSpacing - spacingControl.rightSpacing - spacingControl.elementsSpacing * 6) / 7.0;
    CGFloat perHeight = (size.height - spacingControl.topSpacing - spacingControl.bottomSpacing - weekTitleHeight - spacingControl.elementsSpacing * 6) / 6.0;
#endif
    
    NSInteger curMonthDays = [self.calenDate daysOfMonth];
    NSInteger lastMonthDays = [[self.calenDate lastMonth] daysOfMonth];
    NSInteger curMonthFirstDayWeek = [self.calenDate firstDayWeekOfCurMonth];
    
    NSInteger lCount = 0;
    NSInteger cCount = 0;
    NSInteger nCount = 0;
    
    NSArray *weeksArr = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
    
    for (NSInteger i = 0 ; i<7; i++)
    {
        for (NSInteger j = 0; j<7; j++)
        {
            if (i == 0)
            {
#ifdef USING_VFL
                UILabel *label = [[UILabel alloc] init];
#else
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(spacingControl.leftSpacing + (perWidth + spacingControl.elementsSpacing) * j, spacingControl.topSpacing, perWidth, weekTitleHeight)];
#endif
                
                label.backgroundColor = [UIColor clearColor];
                label.text = [weeksArr objectAtIndex:j];
                label.tag = (i + 1) * 10 + j + controlTag;
                label.textAlignment = NSTextAlignmentCenter;
                [label setTranslatesAutoresizingMaskIntoConstraints:NO];
                
                if ([self.delegate respondsToSelector:@selector(calendar:weeksLabel:)])
                {
                    [self.delegate calendar:self weeksLabel:label];
                }
                
                [self addSubview:label];
            }
            else
            {
                
#ifdef USING_VFL
                YCCalendarDayItem *cItem = [[YCCalendarDayItem alloc] init];
#else
                YCCalendarDayItem *cItem = [[YCCalendarDayItem alloc] initWithFrame:
                                            CGRectMake(spacingControl.leftSpacing + (perWidth + spacingControl.elementsSpacing) * j,
                                                      spacingControl.topSpacing + weekTitleHeight + spacingControl.elementsSpacing + (perHeight + spacingControl.elementsSpacing) * (i - 1),
                                                      perWidth, perHeight)];
#endif
                [cItem setTranslatesAutoresizingMaskIntoConstraints:NO];
                [cItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [cItem addTarget:self action:@selector(daySelected:) forControlEvents:UIControlEventTouchUpInside];
                cItem.clipsToBounds = YES;
                cItem.tag = (i + 1) * 10 + j + controlTag;
                
                YCCalendarDayTypeInMonth dayType;
                NSInteger day ;
                
                if (lCount < curMonthFirstDayWeek - 1)
                {
                    day = (lastMonthDays + lCount - curMonthFirstDayWeek + 2);
                    cItem.solarNSDate = [NSDate dateWithyyyyMMddString:[NSString stringWithFormat:@"%.4ld-%.2ld-%.2ld",[[self.calenDate lastMonth] year],[[self.calenDate lastMonth] month],day]];
                    lCount ++;
                    dayType = YCCalendarDayTypeInMonthLastMoth;
                }
                else if (lCount >= curMonthFirstDayWeek - 1 && cCount < curMonthDays)
                {
                    day = ((i - 1) * 7) + j - lCount + 1;
                    cItem.solarNSDate = [NSDate dateWithyyyyMMddString:[NSString stringWithFormat:@"%.4ld-%.2ld-%.2ld",[self.calenDate year], [self.calenDate month], day]];
                    cCount ++;
                    dayType = YCCalendarDayTypeInMonthCurrentMonth;
                }
                else
                {
                    day = nCount + 1;
                    cItem.solarNSDate = [NSDate dateWithyyyyMMddString:[NSString stringWithFormat:@"%.4ld-%.2ld-%.2ld", [[self.calenDate nextMonth] year], [[self.calenDate nextMonth] month], day]];
                    nCount ++;
                    dayType = YCCalendarDayTypeInMonthNextMonth;
                }
                
                cItem.dayTypeOfMonth = dayType;
                
                if ([self.delegate respondsToSelector:@selector(calendar:addElementsForDayItem:)])
                {
                    [self.delegate calendar:self addElementsForDayItem:cItem];
                }
                
                if ([self.delegate respondsToSelector:@selector(needShowDayItemTitleForCalendar:)])
                {
                    if ([self.delegate needShowDayItemTitleForCalendar:self])
                    {
                        [cItem setTitle:[NSString stringWithFormat:@"%ld",day] forState:UIControlStateNormal];
                    }
                }
                
                [self addSubview:cItem];
            }
        }
        if (curMonthDays == cCount)
        {
            CGRect rect = self.frame;
            
            rect.size.height -= (spacingControl.bottomSpacing + (spacingControl.elementsSpacing + perHeight) * (6 - i));
            
            self.height = rect.size.height;
            
            self.frame = rect;
            
            break;
        }
    }
    
#pragma mark - VCL control
    
#ifdef USING_VFL
    
    NSDictionary *metric  = @{@"topSpacing"        :@(spacingControl.topSpacing),
                              @"bottomSpacing"     :@(spacingControl.bottomSpacing),
                              @"leftSpacing"       :@(spacingControl.bottomSpacing),
                              @"rightSpacing"      :@(spacingControl.rightSpacing),
                              @"elementsSpacing"   :@(spacingControl.elementsSpacing),
                              @"weekTitleHeight"   :@(weekTitleHeight)};
    
    for (int i=0; i<7; i++)
    {
        UILabel        *l1x = (UILabel *)[self viewWithTag:(10 + i + controlTag)];

        YCCalendarDayItem *b2x = (YCCalendarDayItem *)[self viewWithTag:(20 + i + controlTag)];
        YCCalendarDayItem *b3x = (YCCalendarDayItem *)[self viewWithTag:(30 + i + controlTag)];
        YCCalendarDayItem *b4x = (YCCalendarDayItem *)[self viewWithTag:(40 + i + controlTag)];
        YCCalendarDayItem *b5x = (YCCalendarDayItem *)[self viewWithTag:(50 + i + controlTag)];
        YCCalendarDayItem *b6x = (YCCalendarDayItem *)[self viewWithTag:(60 + i + controlTag)];
        YCCalendarDayItem *b7x = (YCCalendarDayItem *)[self viewWithTag:(70 + i + controlTag)];
        NSDictionary *dict = NSDictionaryOfVariableBindings(l1x,b2x,b3x,b4x,b5x,b6x,b7x);
        
        NSString *vfl = @"V:|-topSpacing-[l1x(weekTitleHeight)]-elementsSpacing-[b2x(b3x)]-elementsSpacing-[b3x(b4x)]-elementsSpacing-[b4x(b5x)]-elementsSpacing-[b5x(b6x)]-elementsSpacing-[b6x(b7x)]-elementsSpacing-[b7x]-bottomSpacing-|";
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl options:0 metrics:metric views:dict]];
    }
    
    for (int i=0;i<7;i++)
    {
        if (i == 0)
        {
            UILabel *l1 = (UILabel *)[self viewWithTag:(10 + controlTag)];
            UILabel *l2 = (UILabel *)[self viewWithTag:(11 + controlTag)];
            UILabel *l3 = (UILabel *)[self viewWithTag:(12 + controlTag)];
            UILabel *l4 = (UILabel *)[self viewWithTag:(13 + controlTag)];
            UILabel *l5 = (UILabel *)[self viewWithTag:(14 + controlTag)];
            UILabel *l6 = (UILabel *)[self viewWithTag:(15 + controlTag)];
            UILabel *l7 = (UILabel *)[self viewWithTag:(16 + controlTag)];
            
            NSDictionary *dict = NSDictionaryOfVariableBindings(l1,l2,l3,l4,l5,l6,l7);
            NSString *vfl = @"H:|-leftSpacing-[l1(l2)]-elementsSpacing-[l2(l3)]-elementsSpacing-[l3(l4)]-elementsSpacing-[l4(l5)]-elementsSpacing-[l5(l6)]-elementsSpacing-[l6(l7)]-elementsSpacing-[l7]-rightSpacing-|";
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl options:0 metrics:metric views:dict]];
        }
        else
        {
            YCCalendarDayItem *bx0 = (YCCalendarDayItem *)[self viewWithTag:((i + 1) * 10 + 0 + controlTag)];
            YCCalendarDayItem *bx1 = (YCCalendarDayItem *)[self viewWithTag:((i + 1) * 10 + 1 + controlTag)];
            YCCalendarDayItem *bx2 = (YCCalendarDayItem *)[self viewWithTag:((i + 1) * 10 + 2 + controlTag)];
            YCCalendarDayItem *bx3 = (YCCalendarDayItem *)[self viewWithTag:((i + 1) * 10 + 3 + controlTag)];
            YCCalendarDayItem *bx4 = (YCCalendarDayItem *)[self viewWithTag:((i + 1) * 10 + 4 + controlTag)];
            YCCalendarDayItem *bx5 = (YCCalendarDayItem *)[self viewWithTag:((i + 1) * 10 + 5 + controlTag)];
            YCCalendarDayItem *bx6 = (YCCalendarDayItem *)[self viewWithTag:((i + 1) * 10 + 6 + controlTag)];
            
            NSDictionary *dict = NSDictionaryOfVariableBindings(bx0,bx1,bx2,bx3,bx4,bx5,bx6);
            NSString *vfl = @"H:|-leftSpacing-[bx0(bx1)]-elementsSpacing-[bx1(bx2)]-elementsSpacing-[bx2(bx3)]-elementsSpacing-[bx3(bx4)]-elementsSpacing-[bx4(bx5)]-elementsSpacing-[bx5(bx6)]-elementsSpacing-[bx6]-rightSpacing-|";
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl options:0 metrics:metric views:dict]];
        }
    }
#endif
    
}

- (void)daySelected:(YCCalendarDayItem *)item
{
    if ([self.delegate respondsToSelector:@selector(calendar:didSelectedDayItem:)])
    {
        [self.delegate calendar:self didSelectedDayItem:item];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:tNotification_DidSelectedDayItem object:item];
}

@end

NSString *const tNotification_DidSelectedDayItem = @"tNotification_DidSelectedDayItem";
