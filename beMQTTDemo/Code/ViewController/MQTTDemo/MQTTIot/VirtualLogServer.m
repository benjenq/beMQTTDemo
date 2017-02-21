//
//  TemperatureSensor.m
//  beMQTTDemo
//
//  Created by Ben Cheng on 2016/10/9, Tainan City, Taiwan
//  Copyright 2016 Ben Cheng. All rights reserved.
///
#import "VirtualLogServer.h"
#import <MQTTFramework/beMQTTClient.h>
@interface VirtualLogServer (){

}

@property (nonatomic,retain) beMQTTClient *mqttClient;

@property (nonatomic,retain) NSString *serverIPAddress;
@property (nonatomic) NSUInteger serverPort;

@end

@implementation VirtualLogServer
@synthesize clientName = _clientName;

- (instancetype)init{
    self = [super init];
    if (self) {
    }
    return self;
}

- (instancetype)initWithServerIP:(NSString *)srvipaddr port:(NSUInteger)srvport clientName:(NSString *)name{
    self = [self init];
    if (self) {
        self.clientName = name;
        self.allLogs = [[NSMutableArray alloc] init];

        self.thumbView = [[MQTTClientThumbView alloc] initWithOrigin:CGPointMake(332, 68) clientName:name];
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
                [self.mqttClient subscribeTopic:TOPIC_LAB completion:^(BOOL success, NSString *errorString) {
                    if (!success) {
                        NSLog(@"%@ subscribeTopic error:%@",self.clientName,errorString);
                    }
                    else{
                        self.topic = TOPIC_LAB;
                    }
                }];
            }
        }];
        
        
    }
    return self;
}

#pragma mark - @protocol beMQTTClientDelegate <NSObject>

- (void)beMQTTClient:(beMQTTClient *)mqClient newMessageArrivaled:(NSString *)msgString onTopic:(NSString *)topic{
    [self.thumbView doMsgArrivaledFlashing];
    MQRowLog *log = [[MQRowLog alloc] init];
    log.sendMsgString = msgString;
    log.dateTime = [beHelper dateToString:[NSDate date]];
    [self.allLogs addObject:log];
    [log release];

}

- (void)dealloc{
    NSLog(@"<%p>%@ dealloc",self,[self class].description);
    [self.thumbView removeFromSuperview];
    [self.thumbView  release];
    [self.mqttClient doDisConnect:nil];
    [self.mqttClient release];
    
    [super dealloc];
}



@end

@interface MQRowLog (){
}


@end

@implementation MQRowLog

- (instancetype)init{
    self = [super init];
    if (self) {
        self.sendMsgString = @"";
        self.topic = @"";
        self.dateTime = @"";
    }
    return self;
}

- (void)dealloc{

    
    NSLog(@"<%p>%@ dealloc",self,self.sendMsgString);
    [super dealloc];
    
}

@end



