//
//  MQTTDemoViewController.m
//  beMQTTDemo
//
//  Created by Ben Cheng on 2016/10/9, Tainan City, Taiwan
//  Copyright 2016 Ben Cheng. All rights reserved.
///

#import "MQTTDemoViewController.h"

#import "VirtualTemperatureSensor.h"
#import "VirtualFan.h"
#import "VirtualLogServer.h"

#import "MQTTClientView.h"

#import "MQTTChatDemoViewController.h"

@interface MQTTDemoViewController () {
    
    NSString *_mqServerIP;
    NSUInteger _mqServerPort;
    
    IBOutlet UIScrollView *scrollMapView;
    CGFloat originalScaleVal;
    UIView *clientMapView;
    UILabel *lbServerIP;
    
    
    VirtualTemperatureSensor *_virtualTempSensor;
    VirtualFan *_virtualFan;
    VirtualLogServer *_virtualLogServer;
    
    MQTTClientView *_currentSelectedClientView;
    
}

@end

@implementation MQTTDemoViewController

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}


- (instancetype)initWithServerIPDaaress:(NSString *)seripaddr portNumber:(NSUInteger)port{
    self = [self initWithNibName:[self class].description bundle:nil];
    if (self) {
        _mqServerIP = [[[NSString alloc] initWithString:seripaddr] retain];
        _mqServerPort = port;
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeAll;
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
    
    self.title = @"MQTT Clients Map";
    
    [scrollMapView setDelegate:(id<UIScrollViewDelegate> _Nullable)self];
    
    if ([UIDevice deviceIsiPad]) {
        scrollMapView.minimumZoomScale = 1;
        scrollMapView.maximumZoomScale = 1;
    }
    else
    {
        scrollMapView.minimumZoomScale = MIN((float)320/768,(float)480/960);
        scrollMapView.maximumZoomScale = 1;
    }
    
    if (!_virtualTempSensor) {
        _virtualTempSensor = [[VirtualTemperatureSensor alloc] initWithServerIP:_mqServerIP port:_mqServerPort clientName:CLIENTNAME_TEMPSENSOR];
    }
    if (!_virtualFan) {
        _virtualFan = [[VirtualFan alloc] initWithServerIP:_mqServerIP port:_mqServerPort clientName:CLIENTNAME_COOLFAN];
    }
    if (!_virtualLogServer) {
        _virtualLogServer = [[VirtualLogServer alloc] initWithServerIP:_mqServerIP port:_mqServerPort clientName:CLIENTNAME_LOGSERVER];
    }
    
    
}

- (void)createClientMapView{
    if ( ! clientMapView) {
        clientMapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 960)];
        [clientMapView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"clientMapView"]]];
        scrollMapView.contentSize = clientMapView.frame.size;
        
        lbServerIP = [[UILabel alloc] initWithFrame:CGRectMake(300, 509, 258, 40)];
        lbServerIP.text = [NSString stringWithFormat:@"Broker- %@:%lu",_mqServerIP,(unsigned long)_mqServerPort];
        lbServerIP.adjustsFontSizeToFitWidth = YES;
        [lbServerIP setMinimumScaleFactor:0.1];
        [lbServerIP setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.5]];
        [clientMapView addSubview:lbServerIP];
    }
    
    [clientMapView addSubview:_virtualTempSensor.thumbView];
    [_virtualTempSensor.detailBtn addTarget:self action:@selector(showDetail:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [clientMapView addSubview:_virtualFan.thumbView];
    [_virtualFan.detailBtn addTarget:self action:@selector(showDetail:) forControlEvents:UIControlEventTouchUpInside];

    [clientMapView addSubview:_virtualLogServer.thumbView];
    [_virtualLogServer.detailBtn addTarget:self action:@selector(showDetail:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *cheatBtn = [[[UIButton alloc] initWithFrame:CGRectMake(266, 758 , 218, 97)] autorelease];
    //[cheatBtn setBackgroundColor:[UIColor iOS7tintColor]];
    cheatBtn.showsTouchWhenHighlighted = YES;
    [cheatBtn addTarget:self action:@selector(gotoMQTTChatDemoViewController:) forControlEvents:UIControlEventTouchUpInside];
    [clientMapView addSubview:cheatBtn];
    
    [scrollMapView addSubview:clientMapView];
}

- (void)viewWillAppear:(BOOL)animated{
    [self createClientMapView];
    if (![UIDevice deviceIsiPad]) {
        [scrollMapView setZoomScale:MIN((float)320/768,(float)480/960) animated:NO];
        
    }
    originalScaleVal = scrollMapView.zoomScale;
}

- (void)viewDidAppear:(BOOL)animated{
    
}

- (void)showDetail:(UIButton *)sender{
    
    
    
    CGFloat currentScale = scrollMapView.zoomScale;
    
    CGRect clickFrame = [sender convertRect:sender.frame toView:scrollMapView];
    
    CGRect toFrame = CGRectMake(clickFrame.origin.x / currentScale, clickFrame.origin.y  / currentScale,
                                clickFrame.size.width  / currentScale, clickFrame.size.height  / currentScale);

    CGFloat scale = (scrollMapView.frame.size.width / toFrame.size.width);

    scrollMapView.maximumZoomScale = scale;
    
    [scrollMapView zoomToRect:toFrame animated:YES];
    
    scrollMapView.scrollEnabled = NO;
    
    if (!_currentSelectedClientView) {
        _currentSelectedClientView = [[[NSBundle mainBundle] loadNibNamed:@"MQTTClientView" owner:self options:nil] objectAtIndex:0];
    }
    
    if (sender == _virtualTempSensor.detailBtn) {
        
            [_currentSelectedClientView bindValueWithVirtualObject:_virtualTempSensor];
        
        
    }
    else if (sender == _virtualFan.detailBtn) {
        [_currentSelectedClientView bindValueWithVirtualObject:_virtualFan];

        
    }
    else if (sender == _virtualLogServer.detailBtn) {
        [_currentSelectedClientView bindValueWithVirtualObject:_virtualLogServer];
    }
    _currentSelectedClientView.transform = CGAffineTransformMakeScale(1/scale, 1/scale);
    [_currentSelectedClientView setFrame:toFrame];
    _currentSelectedClientView.alpha = 0;
    [_currentSelectedClientView.closeButton addTarget:self action:@selector(zoomOutToOriginal) forControlEvents:UIControlEventTouchUpInside];
    
    
    [clientMapView addSubview:_currentSelectedClientView];
    
    [UIView animateWithDuration:0.3 animations:^{
        _currentSelectedClientView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
        
}

- (void)zoomOutToOriginal{
    scrollMapView.scrollEnabled = YES;
    [scrollMapView setZoomScale:originalScaleVal animated:YES];
    
    [UIView animateWithDuration:0.4 animations:^{
        _currentSelectedClientView.alpha = 0;
    } completion:^(BOOL finished) {
        [_currentSelectedClientView removeFromSuperview];
        _currentSelectedClientView = nil;
    }];
    
}

#pragma mark - MQTTChatDemoViewController

- (void)gotoMQTTChatDemoViewController:(UIButton *)sender{
    MQTTChatDemoViewController *vc = [[MQTTChatDemoViewController alloc] initWithServerIP:_mqServerIP
                                                                                     port:_mqServerPort
                                                                               clientName:CLIENTNAME_CHATDEMO];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
    
}

#pragma mark - @protocol UIScrollViewDelegate<NSObject>
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return clientMapView;
}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
    NSLog(@"<%p>%@(%@:%lu) dealloc",self,[self class].description,_mqServerIP,(unsigned long)_mqServerPort);
    
    [_virtualTempSensor stopWorking];
    [_virtualTempSensor release];
    [_virtualFan release];
    [_virtualLogServer release];
    
    
    [_mqServerIP release];
    
    [clientMapView removeFromSuperview];
    [clientMapView release];
    
    
    
    [super dealloc];
}


@end
