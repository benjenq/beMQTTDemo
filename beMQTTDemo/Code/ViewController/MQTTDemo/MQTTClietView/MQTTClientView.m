//
//  MQTTClientView.m
//  beMQTTDemo
//
//  Created by Ben Cheng on 2016/10/9, Tainan City, Taiwan
//  Copyright 2016 Ben Cheng. All rights reserved.
///
#import "MQTTClientView.h"

#import "VirtualTemperatureSensor.h"
#import "VirtualFan.h"
#import "VirtualLogServer.h"
@interface MQTTClientView (){

    IBOutlet UIImageView *_deviceIcon;
    IBOutlet UILabel *_lbClientName;
    IBOutlet UILabel *_lbTopic;

    IBOutlet UITextView *_lbLog;

}

@property (nonatomic,assign) id virtualObj;

@end

@implementation MQTTClientView

- (void)bindValueWithVirtualObject:(id)virtualObj{
    self.virtualObj = virtualObj;
    if ([self.virtualObj isKindOfClass:[VirtualTemperatureSensor class]]) {
        VirtualTemperatureSensor *obj = (VirtualTemperatureSensor *)virtualObj;
        _deviceIcon.image = [UIImage imageNamed:obj.clientName];
        _lbClientName.text = obj.clientName;
        _lbTopic.text = obj.topic;
        
        _lbLog.text = @"- Simulate a temperature sensor with temperature increasing event.\n\
- Always publish temperature value to broker on topic \"Lab/Temperature\".\n\
- If \"Start Fan\" message arrivaled on topic \"Lab/CoolFan\", then turn to temperature decreasing event.\n\
- If \"Stop Fan\" message arrivaled, then turn back to temperature increasing event.";
        
    }
    else if ([self.virtualObj isKindOfClass:[VirtualFan class]]) {
        VirtualFan *obj = (VirtualFan *)virtualObj;
        _deviceIcon.image = [UIImage imageNamed:obj.clientName];
        _lbClientName.text = obj.clientName;
        _lbTopic.text = obj.topic;
        _lbLog.text = @"- Simulate a Cool Fan action.\n\
- Get temperature value on topic \"Lab/Temperature\".\n\
- If temperature value > 30°C , then simulate a \"Start Fan\" action and publish the message to topic \"Lab/CoolFan\".\n\
- If temperature value < 25°C , then simulate a \"Stop Fan\" action and publish this message to topic \"Lab/CoolFan\".";
    }
    else if ([self.virtualObj isKindOfClass:[VirtualLogServer class]]) {
        VirtualLogServer *obj = (VirtualLogServer *)virtualObj;
        _deviceIcon.image = [UIImage imageNamed:obj.clientName];
        _lbClientName.text = obj.clientName;
        _lbTopic.text = obj.topic;
        __block NSString *logStr = @"- Always listening all messages on topic \"Lab/+\" and store these messages:\n";
        
        [obj.allLogs enumerateObjectsUsingBlock:^(MQRowLog * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            logStr = [[logStr stringByAppendingString:[NSString stringWithFormat:@"%@: %@\n",obj.dateTime,obj.sendMsgString]] retain];
        }];
        
        _lbLog.text = logStr;
        NSRange range = NSMakeRange(_lbLog.text.length - 2, 1);
        [_lbLog scrollRangeToVisible:range];
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
