//
//  MainViewController.m
//  beMQTTDemo
//
//  Created by Ben Cheng on 2016/10/9, Tainan City, Taiwan
//  Copyright 2016 Ben Cheng. All rights reserved.
///
#import "MainViewController.h"
#import "MQTTDemoViewController.h"
@interface MainViewController () {
    IBOutlet UITextField *lbServerIP;
    IBOutlet UITextField *lbServerPort;
}

@end

@implementation MainViewController

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [lbServerIP setDelegate:(id<UITextFieldDelegate> _Nullable)self];
    [lbServerPort setDelegate:(id<UITextFieldDelegate> _Nullable)self];
    
    
    self.title = @"MQTT Demo";
    
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (IBAction)resignKeyboardFirstResponder:(id)sender{
    [lbServerIP resignFirstResponder];
    [lbServerPort resignFirstResponder];
}

- (IBAction)pushMQTTDemoViewController:(id)sender{
    if ([lbServerIP.text isEqualToString:@""]) {
        lbServerIP.text = @"127.0.0.1";
    }
    if ([lbServerPort.text isEqualToString:@""]) {
        lbServerPort.text = @"1883";
    }
    
    [self resignKeyboardFirstResponder:nil];
    
    MQTTDemoViewController *vc = [[MQTTDemoViewController alloc] initWithServerIPDaaress:lbServerIP.text portNumber:[lbServerPort.text integerValue]];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
    
}


#pragma mark - @protocol UITextFieldDelegate <NSObject>

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == lbServerIP) {
        [lbServerPort becomeFirstResponder];
    }
    else
    {
        [self resignKeyboardFirstResponder:nil];
    }
    
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
    [super dealloc];
}


@end
