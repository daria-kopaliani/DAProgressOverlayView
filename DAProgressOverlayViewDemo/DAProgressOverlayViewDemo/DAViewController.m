//
//  DAViewController.m
//  DAProgressOverlayViewDemo
//
//  Created by Daria Kopaliani on 8/1/13.
//  Copyright (c) 2013 Daria Kopaliani. All rights reserved.
//

#import "DAViewController.h"

#import <QuartzCore/QuartzCore.h>
#import "DAProgressOverlayView.h"


@interface DAViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *downloadButton;
@property (strong, nonatomic) DAProgressOverlayView *progressOverlayView;
@property (strong, nonatomic) NSTimer *timer;

@end


@implementation DAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 35.;
}

- (IBAction)downloadButtonTapped:(id)sender
{
    self.progressOverlayView = [[DAProgressOverlayView alloc] initWithFrame:self.imageView.bounds];
    [self.imageView addSubview:self.progressOverlayView];
    self.downloadButton.enabled = NO;
    [self.downloadButton setTitle:@"Downloading..." forState:UIControlStateNormal];
    [self.progressOverlayView displayOperationWillTriggerAnimation];
    double delayInSeconds = self.progressOverlayView.stateChangeAnimationDuration;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
    });
}

- (void)updateProgress
{
    CGFloat progress = self.progressOverlayView.progress + 0.01;
    if (progress >= 1) {
        [self.timer invalidate];
        [self.progressOverlayView displayOperationDidFinishAnimation];
        double delayInSeconds = self.progressOverlayView.stateChangeAnimationDuration;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            self.progressOverlayView.progress = 0.;
            [self.downloadButton setTitle:@"Download" forState:UIControlStateNormal];
            self.progressOverlayView.hidden = YES;
            self.downloadButton.enabled = YES;
        });
    } else {
        self.progressOverlayView.progress = progress;
    }
}

@end