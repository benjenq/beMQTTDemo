//
//  TemperatureSensor.m
//  beMQTTDemo
//
//  Created by Ben Cheng on 2016/10/9, Tainan City, Taiwan
//  Copyright 2016 Ben Cheng. All rights reserved.
///

#import "VirtualTemperatureSensor.h"
#import <MQTTFramework/beMQTTClient.h>
@interface VirtualTemperatureSensor (){
    
    NSTimer *_timer;
    
    CGFloat tspeed;
}

@property (nonatomic,retain) beMQTTClient *mqttClient;

@property (nonatomic,retain) NSString *serverIPAddress;
@property (nonatomic) NSUInteger serverPort;

@end

@implementation VirtualTemperatureSensor
@synthesize clientName = _clientName;

- (instancetype)init{
    self = [super init];
    if (self) {
        tspeed = 0.7f;
        self.currentTemperature = 25.0f;
    }
    return self;
}

- (instancetype)initWithServerIP:(NSString *)srvipaddr port:(NSUInteger)srvport clientName:(NSString *)name{
    self = [self init];
    if (self) {
        self.clientName = name;

        self.thumbView = [[MQTTClientThumbView alloc] initWithOrigin:CGPointMake(74, 397) clientName:name];
        self.detailBtn = [[UIButton alloc] initWithFrame:self.thumbView.bounds];
        self.detailBtn.showsTouchWhenHighlighted = YES;
        [self.thumbView addSubview:self.detailBtn];
        
        self.serverIPAddress = srvipaddr;
        self.serverPort = srvport;
        
        self.mqttClient = [[beMQTTClient alloc] initWithClientID:name ServerIP:self.serverIPAddress port:self.serverPort];
        [self.mqttClient setDelegate:(id<beMQTTClientDelegate>)self];
        self.mqttClient.topic = TOPIC_FAN;
        self.topic = self.mqttClient.topic;
        
        [self.mqttClient doConnect:^(BOOL success, NSString *errorString) {
            if (!success) {
                NSLog(@"%@ doConnect error:%@",self.clientName,errorString);
            }
            else
            {
                [self.mqttClient subscribeTopic:TOPIC_FAN completion:^(BOOL success, NSString *errorString) {
                    if (!success) {
                        NSLog(@"VirtualTemperatureSensor:subscribeTopic error:%@",errorString);
                    }
                    
                }];
            }
        }];
        
        if (!_timer) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(changeTemperature) userInfo:nil repeats:YES];
            [_timer fire];
        }
        
    }
    return self;
}

- (void)changeTemperature{
    self.currentTemperature = self.currentTemperature + tspeed;
    [self.mqttClient doPublishMessage:[NSString stringWithFormat:@"%.1f",self.currentTemperature]
                              onTopic:TOPIC_TENPERATURE completion:^(BOOL success, NSString *errorString) {
                                  [self.thumbView doPublishFlashing];
                              }];
    
    [self.thumbView changeTitle:[NSString stringWithFormat:@"Temp: %.1f °C",self.currentTemperature]];
    
}

- (void)stopWorking{
    if ([_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark - @protocol beMQTTClientDelegate <NSObject>

- (void)beMQTTClient:(beMQTTClient *)mqClient newMessageArrivaled:(NSString *)msgString onTopic:(NSString *)topic{
    if ([msgString isEqualToString:START_FAN_STRING]) {
        [self.thumbView doMsgArrivaledFlashing];
        tspeed = -0.7f;
    }
    else if ([msgString isEqualToString:STOP_FAN_STRING]) {
        [self.thumbView doMsgArrivaledFlashing];
        tspeed = 0.7f;
    }
    
}

- (void)dealloc{
    NSLog(@"<%p>%@ dealloc",self,[self class].description);
    //[self stopWorking];
    [self.thumbView removeFromSuperview];
    [self.thumbView release];
    [self.mqttClient doDisConnect:nil];
    [self.mqttClient release];
    
    [super dealloc];
}



@end
