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

@property (retain, nonatomic) IBOutlet UIButton *torchToggleButton;
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
    if([self isTorchOn]){
        [self turnOffTorch];
    }else{
        [self turnOnTorch];
    }
}

-(BOOL)isTorchOn{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch] == NO) return NO;
    return device.torchMode == AVCaptureTorchModeOn;
}

-(void)turnOnTorch{
    [self changeTorchMode:AVCaptureTorchModeOn];
    [self.torchToggleButton setImage:[UIImage imageNamed:@"torch_mode_on.png"] forState:UIControlStateNormal];
}

-(void)turnOffTorch{
    [self changeTorchMode:AVCaptureTorchModeOff];
    [self.torchToggleButton setImage:[UIImage imageNamed:@"torch_mode_off.png"] forState:UIControlStateNormal];
}

-(void)changeTorchMode:(AVCaptureTorchMode) mode{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if ([device hasTorch] == NO) return;
    [device lockForConfiguration:nil];
    
    [device setTorchMode:mode];
    
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
    [_torchToggleButton release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setTorchToggleButton:nil];
    [super viewDidUnload];
}
@end
