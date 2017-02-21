//
//  myMQTTLog.h
//  myMQTTDemo
//
//  Created by Administrator on 2017/2/18.
//
//

#import <Foundation/Foundation.h>
#import "beMQTTClient.h"
@interface myMQTTLog : NSObject


@property (nonatomic) MQTTSessionStatus sessionStatus;

@property (nonatomic,retain) NSString *serverIPAddress;
@property (nonatomic) NSUInteger serverPort;

@property (nonatomic,retain) NSMutableArray *logsArray;

- (instancetype)initWithServerIP:(NSString *)srvipaddr port:(NSUInteger)srvport;

- (void)doStartLogging;
- (void)doStopLogged;

@end




@interface MQRowLog : NSObject

@property (nonatomic,retain) NSString *sendMsgString;
@property (nonatomic,retain) NSString *topic;
@property (nonatomic,retain) NSString *dateTime;



@end
