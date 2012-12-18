//
//  ScanViewController.m
//  Liren-ios
//
//  Created by Kewei & Yi on 12/10/12.
//  Copyright (c) 2012 com.thoughtworks.liren. All rights reserved.
//

#import "ScanViewController.h"

@interface ScanViewController () <ZXCaptureDelegate>

@end

@implementation ScanViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.trackedViewName=[NSString stringWithFormat:@"%s", class_getName(self.class)];
    
    if (self.capture == nil) {
        ZXCapture *cap = [[ZXCapture alloc] init];
        self.capture = cap;
        [cap release];
    }

    self.capture.rotation = 90.0f;
    self.capture.camera = self.capture.back;
    self.capture.layer.frame = CGRectMake(20.0f, 60.0f, 280.0f, 220.0f);
    [self.view.layer addSublayer:self.capture.layer];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.capture.delegate = self;
    [self.capture start];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.capture setDelegate:nil];
    [self.capture stop];
}

#pragma mark - UIAction method
- (IBAction) cancelButtonPressed:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)captureResult:(ZXCapture *)capture result:(ZXResult *)result {
    NSLog(@"%@", result.text);
    self.lastBarCode = result.text;
    if (self.dataExchangeDelegate != nil) {
        [self.dataExchangeDelegate putExchangedData:self.lastBarCode];
        [self dismissModalViewControllerAnimated:YES];
    }
}

-(void)dealloc{
    [_capture release];
    [_lastBarCode release];
    [super dealloc];
}

@end
