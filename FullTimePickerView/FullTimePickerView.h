//
//  FullTimePickerView.h
//  FullTimePickerView
//
//  Created by mac on 16/4/7.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 //获取的GMT时间 要想获取某个时区的时间 以下代码可以解决这个问题 详情：http://blog.csdn.net/chan1142131456/article/details/50237343
 
 NSTimeZone *zone = [NSTimeZone systemTimeZone];
 NSDate *date = [NSDate date];
 NSInteger intervar = [zone secondsFromGMTForDate:date];
 NSDate *localeDate = [date dateByAddingTimeInterval:intervar];
 NSLog(@"%@",date);
 NSLog(@"%@",localeDate);
 //定金支付 全款支付 尾款支付 其他消费
 */
@protocol FinishPickerView <NSObject>

- (void)didFinishPickView:(NSDate *)date;

@end

@interface FullTimePickerView : UIView

@property (nonatomic,strong) NSDate *curDate;

@property (nonatomic,weak) id <FinishPickerView>delegate;


+ (instancetype) showOnView:(UIView *)view;

@end
