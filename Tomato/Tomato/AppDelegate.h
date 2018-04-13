//
//  AppDelegate.h
//  Tomato
//
//  Created by qianbingzhen on 2018/4/13.
//  Copyright © 2018年 qian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

