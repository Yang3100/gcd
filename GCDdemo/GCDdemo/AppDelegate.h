//
//  AppDelegate.h
//  GCDdemo
//
//  Created by 杨科军 on 2018/9/1.
//  Copyright © 2018年 杨科军. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

