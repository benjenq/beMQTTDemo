//
//  MainViewController.m
//  beMQTTDemo
//
//  Created by Ben Cheng on 2016/10/9, Tainan City, Taiwan
//  Copyright 2016 Ben Cheng. All rights reserved.
///
#import "MQTTChatDemoViewController.h"
#import <MQTTFramework/beMQTTClient.h>
@interface MQTTChatDemoViewController () {
    

    IBOutlet UITextView *_inComingMessage;
    CGRect _inComingOriFrame;
    
    IBOutlet UIView *_publishView;
    CGRect _publishViewOriFrame;
    IBOutlet UITextField *_publishMessage;
    IBOutlet UIButton *_sendBtn;
    
    
}

@property (nonatomic,retain) beMQTTClient *mqttClient;
@property (nonatomic,retain) NSString *clientName;
@property (nonatomic,retain) NSString *topic;
@end

@implementation MQTTChatDemoViewController

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}


- (instancetype)initWithServerIP:(NSString *)srvipaddr port:(NSUInteger)srvport clientName:(NSString *)name{
    self = [self initWithNibName:[self class].description bundle:nil];
    if (self) {
        
        self.clientName = name;

        self.mqttClient = [[beMQTTClient alloc] initWithClientID:name ServerIP:srvipaddr port:srvport];
        [self.mqttClient setDelegate:(id<beMQTTClientDelegate>)self];
        [self.mqttClient doConnect:^(BOOL success, NSString *errorString) {
            if (!success) {
                NSLog(@"%@ doConnect error:%@",self.mqttClient.clientIdentifier,errorString);
            }
            else
            {
                [self.mqttClient subscribeTopic:TOPIC_CHEAT completion:^(BOOL success, NSString *errorString) {
                    if (!success) {
                        NSLog(@"%@ doConnect error:%@",self.mqttClient.clientIdentifier,errorString);
                    }
                    else
                    {
                        self.topic = TOPIC_CHEAT;
                    }

                }];
            }
        }];
        
    }
    
    return self;
    
    
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
    self.title = @"MQTT Chat Demo";
    [_publishMessage setDelegate:(id<UITextFieldDelegate> _Nullable)self];
    [_inComingMessage setBackgroundColor:[UIColor colorWithRed:0.0f green:0.25f blue:0.0f alpha:1.0f]];
    _inComingMessage.textColor = [UIColor whiteColor];
    
    [_publishMessage.layer setBorderColor:[UIColor iOS7tintColor].CGColor];
    [_publishMessage.layer setBorderWidth:1];
    
    [_sendBtn.layer setBorderColor:[UIColor iOS7tintColor].CGColor];
    [_sendBtn.layer setBorderWidth:1];
    
    [self addObserverKeyboardEvent];
}

- (void)viewWillAppear:(BOOL)animated{
}

- (void)viewDidAppear:(BOOL)animated{
    _inComingOriFrame = _inComingMessage.frame;
    _publishViewOriFrame = _publishView.frame;
}


-(void)addObserverKeyboardEvent{

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}

-(void)keyboardWillShow:(NSNotification *)n{
    NSDictionary* userInfo = [n userInfo];
    // get the size of the keyboard
    CGRect keyboardFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //NSLog(@"keyboardWillShow:%@",[n userInfo]);
    
    //計算 formScroll frame 的變量，將下緣與KeyBoard上端切齊
    _publishView.frame = CGRectMake(_publishView.frame.origin.x,
                                    keyboardFrame.origin.y - _publishView.frame.size.height
                                    - self.navigationController.navigationBar.frame.size.height -20,
                                    _publishView.frame.size.width, _publishView.frame.size.height);
    
    _inComingMessage.frame = CGRectMake(_inComingMessage.frame.origin.x, _inComingMessage.frame.origin.y,
                                        _inComingMessage.frame.size.width,
                                        _publishView.frame.origin.y -5 - _inComingMessage.frame.origin.y);
    
    
    
    //NSLog(@"_publishView.frame=%@",NSStringFromCGRect(_publishView.frame));
    
    
    
}
-(void)keyboardDidShow:(NSNotification *)n{
    //NSLog(@"keyboardDidShow:%@",[n userInfo]);
    
    
}
-(void)keyboardWillHide:(NSNotification *)n{
    _inComingMessage.frame = _inComingOriFrame;
    _publishView.frame = _publishViewOriFrame;
    //[formScroll setContentSize:formScrollOriginalContentSize];
    
    //NSLog(@"keyboardWillHide:%@",[n userInfo]);
}
-(void)keyboardDidHide:(NSNotification *)n{
    //NSLog(@"keyboardDidHide:%@",[n userInfo]);
    
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (IBAction)resignKeyboardFirstResponder:(id)sender{
    [_publishMessage resignFirstResponder];
}

- (IBAction)doPublishMessage:(UIButton *)sender{
    if ([_publishMessage.text isEqualToString:@""]) {
        [self resignKeyboardFirstResponder:nil];
        return;
    }
    [self.mqttClient doPublishMessage:_publishMessage.text onTopic:TOPIC_CHEAT completion:^(BOOL success, NSString *errorString) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                _publishMessage.text = @"";
                
            });
        }
    }];
    
}

#pragma mark - @protocol beMQTTClientDelegate <NSObject>

- (void)beMQTTClient:(beMQTTClient *)mqClient newMessageArrivaled:(NSString *)msgString onTopic:(NSString *)topic{
    if ([topic isEqualToString:TOPIC_CHEAT]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _inComingMessage.text = [_inComingMessage.text stringByAppendingString:[NSString stringWithFormat:@"%@\n",msgString]];
            NSRange range = NSMakeRange(_inComingMessage.text.length - 1, 1);
            [_inComingMessage scrollRangeToVisible:range];            
        });
    }
}


#pragma mark - @protocol UITextFieldDelegate <NSObject>

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self doPublishMessage:nil];
    //NSLog(@"textFieldShouldReturn");
    return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    NSLog(@"<%p>%@ dealloc",self,[self class].description);
    [self.mqttClient doDisConnect:nil];
    [self.mqttClient release];
    
    [super dealloc];
}


@end
