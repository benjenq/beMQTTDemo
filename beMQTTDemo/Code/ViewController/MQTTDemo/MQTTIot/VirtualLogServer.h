//
//  TemperatureSensor.h
//  beMQTTDemo
//
//  Created by Ben Cheng on 2016/10/9, Tainan City, Taiwan
//  Copyright 2016 Ben Cheng. All rights reserved.
///

#import <Foundation/Foundation.h>
#import "MQTTClientThumbView.h"
#import "MQTTClientView.h"
@interface VirtualLogServer : NSObject


@property (nonatomic,retain) NSString *clientName;
@property (nonatomic,retain) NSString *topic;
@property (nonatomic,retain) MQTTClientThumbView *thumbView;
@property (nonatomic,retain) NSMutableArray *allLogs;
@property (nonatomic,retain) UIButton *detailBtn;

- (instancetype)initWithServerIP:(NSString *)srvipaddr port:(NSUInteger)srvport clientName:(NSString *)name;

@end

@interface MQRowLog : NSObject

@property (nonatomic,retain) NSString *sendMsgString;
@property (nonatomic,retain) NSString *topic;
@property (nonatomic,retain) NSString *dateTime;



@end
