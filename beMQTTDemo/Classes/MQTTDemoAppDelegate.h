//
//  MQTTDemoAppDelegate.h
//  beMQTTDemo
//
//  Created by Ben Cheng on 2016/10/9, Tainan City, Taiwan
//  Copyright 2016 Ben Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MQTTDemoAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

