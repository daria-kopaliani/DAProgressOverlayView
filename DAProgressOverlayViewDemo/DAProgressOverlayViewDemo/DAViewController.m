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
    self.progressOverlayView = [[DAProgressOverlayView alloc] initWithFrame:self.imageView.bounds];
    [self.imageView addSubview:self.progressOverlayView];
    self.progressOverlayView.hidden = YES;
}

- (IBAction)downloadButtonTapped:(id)sender
{
    self.downloadButton.enabled = NO;
    [self.downloadButton setTitle:@"Downloading..." forState:UIControlStateNormal];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
    self.progressOverlayView.hidden = NO;
}

- (void)updateProgress
{
    CGFloat progress = self.progressOverlayView.progress + 0.005;
    if (progress > 1) {
        [self.timer invalidate];
        [UIView animateWithDuration:0.2 delay:0. options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.progressOverlayView.alpha = 0.;
        } completion:^(BOOL finished) {
            self.progressOverlayView.progress = 0.;
            self.progressOverlayView.alpha = 1.;
            [self.downloadButton setTitle:@"Download" forState:UIControlStateNormal];
            self.progressOverlayView.hidden = YES;
            self.downloadButton.enabled = YES;
        }];
    } else {
        self.progressOverlayView.progress = progress;
    }
}

@end