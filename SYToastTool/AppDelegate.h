//
//  AppDelegate.h
//  SYToastTool
//
//  Created by 孙宇 on 16/12/22.
//  Copyright © 2016年 孙宇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

