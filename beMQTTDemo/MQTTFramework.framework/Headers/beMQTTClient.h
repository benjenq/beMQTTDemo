//
//  beMQTTClient.h
//  beMQTTDemo
//
//  Created by Ben Cheng on 2016/10/9, Tainan City, Taiwan
//  Copyright 2016 Ben Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MQTTFramework.h"


@protocol beMQTTClientDelegate;
@interface beMQTTClient : NSObject{
    
    id <beMQTTClientDelegate> _delegate;

}

@property (nonatomic,assign) id <beMQTTClientDelegate> delegate;

@property (nonatomic) MQTTSessionStatus sessionStatus;

@property (nonatomic,retain,readonly) NSString *clientIdentifier;

@property (nonatomic,retain) NSString *serverIPAddress;
@property (nonatomic) NSUInteger serverPort;
@property (nonatomic,retain) NSString *topic;


- (instancetype)initWithClientID:(NSString *)clientid ServerIP:(NSString *)srvipaddr port:(NSUInteger)srvport;

- (void)doConnect:(void(^)(BOOL success,NSString *errorString))completion;

- (void)subscribeTopic:(NSString *)topicString completion:(void(^)(BOOL success,NSString *errorString))completion;

- (void)doPublishMessage:(NSString *)msgString onTopic:(NSString *)topic completion:(void(^)(BOOL success,NSString *errorString))completion;

- (void)doDisConnect:(void(^)(BOOL success,NSString *errorString))completion;

@end





@protocol beMQTTClientDelegate <NSObject>

- (void)beMQTTClient:(beMQTTClient *)mqClient newMessageArrivaled:(NSString *)msgString onTopic:(NSString *)topic;

- (void)beMQTTClient:(beMQTTClient *)mqClient raisedError:(NSError *)error  errorMessage:(NSString *)errorMessage;

@end
