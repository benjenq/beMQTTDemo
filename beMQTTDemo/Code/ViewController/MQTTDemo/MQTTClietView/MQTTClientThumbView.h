//
//  MQTTClientThumbView.h
//  beMQTTDemo
//
//  Created by Ben Cheng on 2016/10/9, Tainan City, Taiwan
//  Copyright 2016 Ben Cheng. All rights reserved.
///

#import <UIKit/UIKit.h>

@interface MQTTClientThumbView : UIView

@property (nonatomic,retain) NSString *clientName;
@property (nonatomic)  BOOL isRotating;

- (instancetype)initWithOrigin:(CGPoint)orogin clientName:(NSString *)name;

- (void)changeTitle:(NSString *)title;

- (void)doPublishFlashing;
- (void)doMsgArrivaledFlashing;

- (void)doRotate;
-(void)stopRotate;

@end
