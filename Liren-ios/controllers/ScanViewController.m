//
//  ScanViewController.m
//  Liren-ios
//
//  Created by Kewei & Yi on 12/10/12.
//  Copyright (c) 2012 com.thoughtworks.liren. All rights reserved.
//

#define TORCH_LEVEL 0.5

#import "ScanViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ScanViewController () <ZXCaptureDelegate>

@property (retain, nonatomic) IBOutlet UIButton *button;
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
    self.capture.layer.frame = self.view.frame;
    [self.view.layer insertSublayer:self.capture.layer atIndex:0];
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

- (IBAction)toggleTorch:(id)sender {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if ([device hasTorch] == NO) return;
    
    [device lockForConfiguration:nil];
        
    if (device.torchMode == AVCaptureTorchModeOff) {
        [device setTorchModeOnWithLevel:TORCH_LEVEL error:nil];
        [self.button setTitle:@"On" forState:UIControlStateNormal];
    }
    else if (device.torchMode == AVCaptureTorchModeOn) {
        [device setTorchMode:AVCaptureTorchModeOff];
        [self.button setTitle:@"Off" forState:UIControlStateNormal];
    }
    
    [device unlockForConfiguration];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)captureResult:(ZXCapture *)capture result:(ZXResult *)result {
    self.lastBarCode = result.text;
    if (self.dataExchangeDelegate != nil) {
        [self.dataExchangeDelegate putExchangedData:self.lastBarCode];
        [self dismissModalViewControllerAnimated:YES];
    }
}

-(void)dealloc{
    [_capture release];
    [_lastBarCode release];
    [_button release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setButton:nil];
    [super viewDidUnload];
}
@end
