//
//  myMQTTLog.m
//  myMQTTDemo
//
//  Created by Administrator on 2017/2/18.
//
//

#import "myMQTTLog.h"

@interface myMQTTLog (){
    
    
}

@property (nonatomic,retain) beMQTTClient *logMQClient;

@end

@implementation myMQTTLog
- (instancetype)init{
    self = [super init];
    if (self) {
        self.serverIPAddress = @"127.0.0.1";
        self.serverPort = 1883;        
    }
    return self;
}

- (instancetype)initWithServerIP:(NSString *)srvipaddr port:(NSUInteger)srvport{
    self = [self init];
    if (!self) {
        NSLog(@"initWithServerIP:port: ERROR");
        return nil;
    }
    
    self.serverIPAddress = srvipaddr;
    self.serverPort = srvport;
    
    if (!self.logMQClient) {
        self.logMQClient = [[beMQTTClient alloc] initWithClientID:@"LogCenter" ServerIP:srvipaddr port:srvport];
        [self.logMQClient setDelegate:(id<beMQTTClientDelegate>)self];
    }
    
    
    
    return self;
}

- (void)doStartLogging{
    if (!self.logMQClient) {
        NSLog(@"logMQClient not init");
        return;
    }
    if (!self.logsArray) {
        self.logsArray = [[NSMutableArray alloc] init];
    }
    [self.logMQClient doConnect:^(BOOL success, NSString *errorString) {
        if (success) {
            NSLog(@"logMQClient doConnect SUCCESS: %@",errorString);
            
            [self.logMQClient subscribeTopic:@"#" completion:^(BOOL success, NSString *errorString) {
                if (success) {
                    NSLog(@"MQTTLog subscribe success!:%@",errorString);
                }
                else
                {
                    NSLog(@"MQTTLog subscribe NOT success!:%@",errorString);
                }
            }];
            
        }
        else
        {
            NSLog(@"logMQClient doConnect Failed: %@",errorString);
        }
    }];
}

- (void)doStopLogged{
    if (self.logMQClient.sessionStatus == MQTTSessionStatusConnected) {
        [self.logMQClient doDisConnect:^(BOOL success, NSString *errorString) {
            if (success) {
                NSLog(@"myMQTTLog Stop Logged success");
            }
            else
            {
                NSLog(@"myMQTTLog Stop Logged NOT success: %@", errorString);
            }
            
        }];
    }
}

- (MQTTSessionStatus) sessionStatus{
    if (!self.logMQClient) {
        return MQTTSessionStatusError;
    }
    return self.logMQClient.sessionStatus;
}

#pragma mark -  @protocol beMQTTClientDelegate <NSObject>

- (void)beMQTTClient:(beMQTTClient *)mqClient newMessageArrivaled:(NSString *)msgString onTopic:(NSString *)topic{
    MQRowLog *log = [[MQRowLog alloc] init];
    log.topic = mqClient.topic;
    log.dateTime = [beHelper dateToString:[NSDate date]];
    log.sendMsgString = msgString;

    NSLog(@"新訊息(%@)：%@:%@",log.dateTime,log.topic,log.sendMsgString);
    
    [self.logsArray addObject:log];
    
    
    
    [log release];
}

- (void)beMQTTClient:(beMQTTClient *)mqClient raisedError:(NSError *)error  errorMessage:(NSString *)errorMessage{
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
