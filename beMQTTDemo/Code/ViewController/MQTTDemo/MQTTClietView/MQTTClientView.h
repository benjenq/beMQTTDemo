//
//  MQTTClientView.h
//  beMQTTDemo
//
//  Created by Ben Cheng on 2016/10/9, Tainan City, Taiwan
//  Copyright 2016 Ben Cheng. All rights reserved.
///

#import <UIKit/UIKit.h>

@interface MQTTClientView : UIView

@property (nonatomic,assign) IBOutlet UIButton *closeButton;

- (void)bindValueWithVirtualObject:(id)virtualObj;

@end
