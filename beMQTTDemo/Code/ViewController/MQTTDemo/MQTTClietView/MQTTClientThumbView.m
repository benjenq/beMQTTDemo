//
//  MQTTClientThumbView.m
//  beMQTTDemo
//
//  Created by Ben Cheng on 2016/10/9, Tainan City, Taiwan
//  Copyright 2016 Ben Cheng. All rights reserved.
///

#import "MQTTClientThumbView.h"
#import <QuartzCore/QuartzCore.h>
@interface MQTTClientThumbView (){
    UILabel *lbName;
    UIImageView *deviceIcon;
    UILabel *lbFresh;
    

}

@end
@implementation MQTTClientThumbView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        lbFresh = [[UILabel alloc] initWithFrame:self.bounds];
        lbFresh.backgroundColor = [UIColor colorWithRed:0.85f green:0.85f blue:0.0f alpha:0.8];
        lbFresh.alpha = 0;
        [self addSubview:lbFresh];
        
        deviceIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75, 75)];
        [self addSubview:deviceIcon];

        lbName = [[UILabel alloc] initWithFrame:CGRectMake(0,frame.size.height - 30,frame.size.width,30)];
        lbName.adjustsFontSizeToFitWidth = YES;
        lbName.minimumScaleFactor = 0.1;
        lbName.numberOfLines = 2;
        
        [self addSubview:lbName];
        
        
        
    }
    return self;
}

- (instancetype)initWithOrigin:(CGPoint)orogin clientName:(NSString *)name{
    self = [self initWithFrame:CGRectMake(orogin.x, orogin.y, 93, 116)];
    if (self) {
        self.clientName = name;
        deviceIcon.image = [UIImage imageNamed:name];
        
        lbName.text = name;
        
        self.isRotating = NO;
        
    }
    return self;

}

- (void)changeTitle:(NSString *)title{
    lbName.text = title;
}

- (void)doPublishFlashing{
    [lbFresh setBackgroundColor:[UIColor iOS7tintColor]];
    lbFresh.alpha = 1;
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         lbFresh.alpha = 0;
                     } completion:^(BOOL finished) {
                         lbFresh.alpha = 0;
                     }];
    
    
}
- (void)doMsgArrivaledFlashing{
    [lbFresh setBackgroundColor:[UIColor greenColor]];
    lbFresh.alpha = 1;
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         lbFresh.alpha = 0;
                     } completion:^(BOOL finished) {
                         lbFresh.alpha = 0;
                     }];
    
}

- (void)doRotate{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * 1.0 * 40.0f ];
    rotationAnimation.duration = 20.0f;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 1;
    
    [deviceIcon.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

-(void)stopRotate{
    [deviceIcon.layer removeAllAnimations];
}


- (void)removeFromSuperview{
    [super removeFromSuperview];
    [lbName removeFromSuperview];
    [deviceIcon removeFromSuperview];
    [lbFresh removeFromSuperview];
    
}

- (void)dealloc{
    NSLog(@"<%p>%@ dealloc",self,[self class].description);
    [lbName release];
    [deviceIcon release];
    [lbFresh release];

    [super dealloc];
}


@end
