//
//  ViewController.m
//  Tomato
//
//  Created by qianbingzhen on 2018/4/13.
//  Copyright © 2018年 qian. All rights reserved.
//
//参考 https://blog.csdn.net/BAOU1371/article/details/51993581
#import "ViewController.h"
#import <EventKit/EventKit.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self addEventNotify:[NSDate dateWithTimeIntervalSinceNow:10] title:@"测试"];
    // Do any additional setup after loading the view, typically from a nib.
    [self addReminderNotify:[NSDate dateWithTimeIntervalSinceNow:10] title:@"测试1"];
    
}

- (void)addEventNotify:(NSDate *)date title:(NSString *)title
{
    //生成事件数据库对象
    EKEventStore *eventDB = [[EKEventStore alloc] init];
    //申请事件类型权限 日历
    [eventDB requestAccessToEntityType:(EKEntityTypeEvent) completion:^(BOOL granted, NSError * _Nullable error) {
        if(granted){
            EKEvent *myEvent = [EKEvent eventWithEventStore:eventDB]; //创建一个日历事件
            myEvent.title = title;//标题
            myEvent.startDate = date;//开始date   required
            myEvent.endDate = [NSDate dateWithTimeInterval:20 sinceDate:date];//结束date    required
            [myEvent addAlarm:[EKAlarm alarmWithAbsoluteDate:date]];//添加一个闹钟  optional
            [myEvent setCalendar:[eventDB defaultCalendarForNewEvents]]; //添加calendar  required
            NSError *err;
            [eventDB saveEvent:myEvent span:EKSpanThisEvent error:&err]; //保存
        }
    }];
}

- (void)addReminderNotify:(NSDate *)date title:(NSString *)title
{
    
    EKEventStore *eventDB = [[EKEventStore alloc] init];
    //申请事件类型权限 提醒
    [eventDB requestAccessToEntityType:(EKEntityTypeReminder) completion:^(BOOL granted, NSError * _Nullable error) {
        if(granted){
            EKReminder *reminder = [EKReminder reminderWithEventStore:eventDB];
            //标题
            reminder.title = title;
            //添加日历
            [reminder setCalendar:[eventDB defaultCalendarForNewReminders]];
            NSCalendar *cal = [NSCalendar currentCalendar];
            [cal setTimeZone:[NSTimeZone systemTimeZone]];
            NSInteger flags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour | NSCalendarUnitMinute |NSCalendarUnitSecond;
            NSDateComponents *dateComp = [cal components:flags fromDate:date];
            dateComp.timeZone = [NSTimeZone systemTimeZone];
            reminder.startDateComponents = dateComp;//开始时间
            NSDateComponents *dateComp1 = [cal components:flags fromDate:[NSDate dateWithTimeInterval:5 sinceDate:date]];
            reminder.dueDateComponents = dateComp1;//到期时间
            reminder.priority = 1;
            EKAlarm *alarm = [EKAlarm alarmWithAbsoluteDate:date];//添加闹钟
            [reminder addAlarm:alarm];
            NSError *err;
            [eventDB saveReminder:reminder commit:YES error:&err];
            if(err)
            {
                NSLog(@"%@",err);
            }

            
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end













