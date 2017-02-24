//
//  FullTimePickerView.m
//  FullTimePickerView
//
//  Created by mac on 16/4/7.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "FullTimePickerView.h"

#define screenWith [UIScreen mainScreen].bounds.size.width
#define screenHeight  [UIScreen mainScreen].bounds.size.height

@interface FullTimePickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>{
    UIPickerView *fullPickerView;
    
    NSInteger yearRange;
    NSInteger dayRange;
    NSInteger startYear;
    
    NSInteger selectedYear;
    NSInteger selectedMonth;
    NSInteger selectedDay;
    NSInteger selectedHour;
    NSInteger selectedMinute;
    NSInteger selectedSecond;
    
    NSCalendar *calendar;
}

@property (nonatomic,strong) UIView *mask;

@end

@implementation FullTimePickerView

- (instancetype) initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addTap];
        [self config];
    }
    return self;
}

- (void)addTap
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [self.mask addGestureRecognizer:tap];
}



- (void)hide
{
    [UIView animateWithDuration:0.5 animations:^(void) {
        self.frame = CGRectMake(0, self.superview.frame.size.height + 200, self.superview.frame.size.width, 200);
        self.mask.alpha = 0.0;
    } completion:^(BOOL isFinished) {
        [self.mask removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)config{
    CGFloat perWidth = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    fullPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, perWidth, height)];
    fullPickerView.dataSource = self;
    fullPickerView.delegate = self;
    [self addSubview:fullPickerView];

    //时间操作
    NSCalendar *calendar0 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMonthCalendarUnit | NSSecondCalendarUnit;
    
    comps = [calendar0 components:unitFlags fromDate:[NSDate date]];
    //获取年份
    NSInteger year = [comps year];
    
    startYear = year - 15;
    yearRange = 30;//前十五年 后十五年
    selectedYear = 2000;
    selectedMonth = 1;
    selectedDay = 1;
    selectedHour = 0;
    selectedMinute = 0;
    selectedSecond = 0;
    //获取开始年的第一个月的天数
    dayRange = [self isAllDay:startYear andMonth:1];
}
//默认的时间处理
- (void)setCurDate:(NSDate *)curDate{
    //获取当前的时间
    NSCalendar *calendar0 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    comps = [calendar0 components:unitFlags fromDate:curDate];
    
    NSInteger year = [comps year];
    NSInteger month = [comps month];
    NSInteger day = [comps day];
    NSInteger hour = [comps hour];
    NSInteger minute = [comps minute];
    NSInteger second = [comps second];
    
    
    selectedYear = year;
    selectedMonth = month;
    selectedDay = day;
    selectedHour = hour;
    selectedMinute = minute;
    selectedSecond = second;
    
    dayRange = [self isAllDay:year andMonth:month];
    //设置pickerView 默认选中的行
    [fullPickerView selectRow:year - startYear inComponent:0 animated:YES];
    [fullPickerView selectRow:month-1 inComponent:1 animated:true];
    [fullPickerView selectRow:day-1 inComponent:2 animated:true];
    [fullPickerView selectRow:hour inComponent:3 animated:true];
    [fullPickerView selectRow:minute inComponent:4 animated:true];
    [fullPickerView selectRow:second inComponent:5 animated:true];
    
    [fullPickerView reloadAllComponents];
}






#pragma mark - UIPickerView的代理方法
//总共有多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 6;
}

//获取每列有多少个数据
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return yearRange;
            break;
        case 1:
            return 12;
            break;
        case 2:
            return dayRange;
            break;
        case 3:
            return 24;
            break;
        case 4:
            return 60;
            break;
        default:
            return 60;
            break;
    }
}
//定制每列 每行显示数据的View
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(screenWith *component/6.0, 0, screenWith/6.0, 30)];
    label.font = [UIFont systemFontOfSize:15];
    label.tag = component * 100 + row;
    label.textAlignment = NSTextAlignmentCenter;
    
    switch (component) {
        case 0:
            label.frame = CGRectMake(5, 0, screenWith/4.0, 30);
            label.text = [NSString stringWithFormat:@"%ld年",(long)(startYear + row)];
            break;
        case 1:
            label.frame=CGRectMake(screenWith/4.0, 0, screenWith/8.0, 30);
            label.text=[NSString stringWithFormat:@"%ld月",(long)row+1];
            break;
        case 2:
        {
            label.frame=CGRectMake(screenWith*3/8, 0, screenWith/8.0, 30);
            label.text=[NSString stringWithFormat:@"%ld日",(long)row+1];
        }
            break;
        case 3:
        {
            label.textAlignment=NSTextAlignmentRight;
            label.text=[NSString stringWithFormat:@"%ld时",(long)row];
        }
            break;
        case 4:
        {
            label.textAlignment=NSTextAlignmentRight;
            label.text=[NSString stringWithFormat:@"%ld分",(long)row];
        }
            break;
        default:
        {
            label.textAlignment=NSTextAlignmentRight;
            label.frame=CGRectMake(screenWith*component/6.0, 0, screenWith/6.0-5, 30);
            label.text=[NSString stringWithFormat:@"%ld秒",(long)row];
        }
            break;
    }
    return label;
}
//获取每月的总天数
- (NSInteger) isAllDay:(NSInteger)startYear andMonth:(NSInteger)Month{
    int day = 0;
    switch (Month) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            day = 31;
            break;
        case 2:{
            if (((startYear % 4 == 0)&&(startYear%100 != 0)) || (startYear % 400 == 0)) {
                day = 29;
            }else{
                day = 28;
            }
        }
        default:
            day = 30;
            break;
    }
    return day;
}

//监听pickerView的滑动
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    switch (component) {
        case 0:
            selectedYear= startYear + row;
            dayRange = [self isAllDay:selectedYear andMonth:selectedMonth];
            break;
        case 1:
            selectedMonth = row + 1;
            dayRange = [self isAllDay:selectedYear andMonth:selectedMonth];
            break;
        case 2:
            selectedDay = row + 1;
            break;
        case 3:
        {
            selectedHour=row;
        }
            break;
        case 4:
        {
            selectedMinute=row;
        }
            break;
        case 5:
        {
            selectedSecond=row;
        }
            break;

        default:
            break;
    }
    
    NSString*string =[NSString stringWithFormat:@"%ld-%.2ld-%.2ld %.2ld:%.2ld:%.2ld",(long)selectedYear,(long)selectedMonth,(long)selectedDay,(long)selectedHour,(long)selectedMinute,(long)selectedSecond];
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *inputDate = [inputFormatter dateFromString:string];
    NSLog(@"%@",inputDate);
    
    
    //解决时区的问题
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:inputDate];
    NSDate *localeDate = [inputDate dateByAddingTimeInterval:interval];
    NSLog(@"解决时区的东西%@",localeDate);
    
    if ([self.delegate respondsToSelector:@selector(didFinishPickView:)]) {
        [self.delegate didFinishPickView:inputDate];
    }
    
    
}

//
+ (instancetype)showOnView:(UIView *)view{
    FullTimePickerView *fullTimePicker = [[FullTimePickerView alloc] init];
    fullTimePicker.mask = [[UIView alloc] initWithFrame:view.window.bounds];
    fullTimePicker.mask.backgroundColor = [UIColor whiteColor];
    fullTimePicker.mask.alpha = 0.3;

    [view addSubview:fullTimePicker];
    return fullTimePicker;
}


























@end
