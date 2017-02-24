//
//  ViewController.m
//  FullTimePickerView
//
//  Created by mac on 16/4/7.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ViewController.h"
#import "FullTimePickerView.h"


@interface ViewController ()<FinishPickerView,UITextFieldDelegate>

@property (nonatomic,strong) FullTimePickerView *timePickerView;
@property (nonatomic,strong) UITextField *field;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    FullTimePickerView *pickerView = [[FullTimePickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height + 200, self.view.frame.size.width, 200)];
    pickerView.curDate = [NSDate date];
    pickerView.delegate = self;
    pickerView.frame = CGRectMake(0, self.view.frame.size.height + 200,self.view.frame.size.width , 200);
    [self.view addSubview:pickerView];
    self.timePickerView = pickerView;
    self.view.backgroundColor = [UIColor greenColor];
    UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(30, 30, self.view.frame.size.width - 60, 30)];
    field.delegate = self;
    field.backgroundColor = [UIColor orangeColor];
    field.inputView = [[UIView alloc] initWithFrame:CGRectZero];
    [field addTarget:self action:@selector(chuxianshijianxuanzeqi) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:field];
    self.field = field;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressTap)];
    [self.view addGestureRecognizer:tap];
    
}
- (void)pressTap{
    [UIView animateWithDuration:1.0 animations:^{
        self.timePickerView.frame = CGRectMake(0, self.view.frame.size.height + 200, self.view.frame.size.width, 200);
    }];
}
- (void)chuxianshijianxuanzeqi{
    [UIView animateWithDuration:1.0 animations:^{
        self.timePickerView.frame = CGRectMake(0, self.view.frame.size.height - 200, self.view.frame.size.width, 200);
    }];
}

-(void)didFinishPickView:(NSDate *)date
{
    //获取的GMT时间，要想获得某个时区的时间，以下代码可以解决这个问题  详情：http://blog.csdn.net/chan1142131456/article/details/50237343
    NSLog(@"传过来的时间%@",date);
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSString *fieldText = [formatter stringFromDate:localeDate];
    self.field.text = fieldText;
    
    NSLog(@"处理后的时间%@", localeDate);
}

@end
