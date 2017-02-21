//
//  TemperatureSensor.m
//  beMQTTDemo
//
//  Created by Ben Cheng on 2016/10/9, Tainan City, Taiwan
//  Copyright 2016 Ben Cheng. All rights reserved.
///

#import "VirtualFan.h"
#import <MQTTFramework/beMQTTClient.h>
@interface VirtualFan (){

}

@property (nonatomic,retain) beMQTTClient *mqttClient;

@property (nonatomic,retain) NSString *serverIPAddress;
@property (nonatomic) NSUInteger serverPort;

@end

@implementation VirtualFan
@synthesize clientName = _clientName;

- (instancetype)init{
    self = [super init];
    if (self) {
        self.isWorking = NO;
    }
    return self;
}

- (instancetype)initWithServerIP:(NSString *)srvipaddr port:(NSUInteger)srvport clientName:(NSString *)name{
    self = [self init];
    if (self) {
        self.clientName = name;

        self.thumbView = [[MQTTClientThumbView alloc] initWithOrigin:CGPointMake(585, 397) clientName:name];
        self.detailBtn = [[UIButton alloc] initWithFrame:self.thumbView.bounds];
        self.detailBtn.showsTouchWhenHighlighted = YES;
        [self.thumbView addSubview:self.detailBtn];
        
        self.serverIPAddress = srvipaddr;
        self.serverPort = srvport;
        
        self.mqttClient = [[beMQTTClient alloc] initWithClientID:name ServerIP:self.serverIPAddress port:self.serverPort];
        [self.mqttClient setDelegate:(id<beMQTTClientDelegate>)self];
        
        [self.mqttClient doConnect:^(BOOL success, NSString *errorString) {
            if (!success) {
                NSLog(@"%@ doConnect error:%@",self.clientName,errorString);
            }
            else
            {
                [self.mqttClient subscribeTopic:TOPIC_TENPERATURE completion:^(BOOL success, NSString *errorString) {
                    if (!success) {
                        NSLog(@"%@ subscribeTopic error:%@",self.clientName,errorString);
                    }
                    else {
                        self.topic = TOPIC_TENPERATURE;
                    }
                }];
            }
        }];
        
    }
    return self;
}

#pragma mark - @protocol beMQTTClientDelegate <NSObject>

- (void)beMQTTClient:(beMQTTClient *)mqClient newMessageArrivaled:(NSString *)msgString onTopic:(NSString *)topic{
    CGFloat temputure = [msgString floatValue];
    if (temputure > 30) {
        [self.thumbView doPublishFlashing];
        [self startFan];
        [self.mqttClient doPublishMessage:START_FAN_STRING onTopic:TOPIC_FAN completion:^(BOOL success, NSString *errorString) {
            if (!success) {
                NSLog(@"VirtualFan doPublishMessage Error: %@",errorString);
            }
            
        }];
    }
    else if (temputure < 25) {
        [self.thumbView doPublishFlashing];
        [self stopFan];
        [self.mqttClient doPublishMessage:STOP_FAN_STRING onTopic:TOPIC_FAN completion:^(BOOL success, NSString *errorString) {
            if (!success) {
                NSLog(@"VirtualFan doPublishMessage Error: %@",errorString);
            }
            
        }];
    }
    else{
        [self.thumbView doMsgArrivaledFlashing];
    }

}

- (void)startFan{
    [self.thumbView doRotate];
}



- (void)stopFan{
    [self.thumbView stopRotate];
}

- (void)dealloc{
    NSLog(@"<%p>%@ dealloc",self,[self class].description);
    [self.thumbView  removeFromSuperview];
    [self.thumbView release];
    [self.mqttClient doDisConnect:nil];
    [self.mqttClient release];
    [super dealloc];
}



@end
