//
//  DAProgressOverlayView.m
//  DAProgressOverlayView
//
//  Created by Daria Kopaliani on 8/1/13.
//  Copyright (c) 2013 Daria Kopaliani. All rights reserved.
//

#import "DAProgressOverlayView.h"

@implementation DAProgressOverlayView

#pragma mark - Initialization

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUp];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    self.backgroundColor = [UIColor clearColor];
    self.progress = 0;
    self.outerRadiusRatio = 0.7;
    self.innerRadiusRatio = 0.6;
    self.overlayColor = [UIColor colorWithRed:0. green:0. blue:0. alpha:0.3];
}

#pragma mark - Public

- (void)setInnerRadiusRatio:(CGFloat)innerRadiusRatio
{
    _innerRadiusRatio = (innerRadiusRatio < 0.) ? 0. : (innerRadiusRatio > 1.) ? 1. : innerRadiusRatio;
}

- (void)setOuterRadiusRatio:(CGFloat)outerRadiusRatio
{
    _outerRadiusRatio = (outerRadiusRatio < 0.) ? 0. : (outerRadiusRatio > 1.) ? 1. : outerRadiusRatio;
}

- (void)setProgress:(CGFloat)progress
{
    if (_progress != progress) {
        _progress = (progress < 0.) ? 0. : (progress > 1.) ? 1. : progress;
        [self setNeedsDisplay];
    }
}

#pragma mark - Private

- (void)drawRect:(CGRect)rect
{
    CGFloat width = CGRectGetWidth(rect);
    CGFloat height = CGRectGetHeight(rect);
    
    CGFloat outerRadius = MIN(width, height) / 2. * self.outerRadiusRatio;
    CGFloat innerRadius = MIN(width, height) / 2. * self.innerRadiusRatio;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, width / 2., height / 2.);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 0.5);
    CGContextSetFillColorWithColor(context, self.overlayColor.CGColor);
    
    CGMutablePathRef path0 = CGPathCreateMutable();
    CGPathMoveToPoint(path0, NULL, width / 2., 0);
    CGPathAddLineToPoint(path0, NULL, width / 2., height / 2.);
    CGPathAddLineToPoint(path0, NULL, -width / 2., height / 2.);
    CGPathAddLineToPoint(path0, NULL, -width / 2., 0);
    CGPathAddLineToPoint(path0, NULL, (cosf(M_PI) * outerRadius), 0);
    CGPathAddArc(path0, NULL, 0, 0, outerRadius, M_PI, 0, 1);
    CGPathAddLineToPoint(path0, NULL, width / 2., 0);
    CGPathCloseSubpath(path0);

    CGMutablePathRef path1 = CGPathCreateMutable();
    CGAffineTransform rotation = CGAffineTransformMakeScale(1.0, -1.0);
    CGPathAddPath(path1, &rotation, path0);
   
    CGContextAddPath(context, path0);
    CGContextFillPath(context);
    CGPathRelease(path0);
    
    CGContextAddPath(context, path1);
    CGContextFillPath(context);
    CGPathRelease(path1);
   
    if (_progress < 1.) {
        CGFloat angle = 360. - (360. * _progress);
        CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI_2);
        CGMutablePathRef path2 = CGPathCreateMutable();
        CGPathMoveToPoint(path2, &transform, innerRadius, 0);
        CGPathAddArc(path2, &transform, 0, 0, innerRadius, 0, angle / 180. * M_PI, 0);
        CGPathAddLineToPoint(path2, &transform, 0, 0);
        CGPathAddLineToPoint(path2, &transform, innerRadius, 0);
        CGContextAddPath(context, path2);
        CGContextFillPath(context);
        CGPathRelease(path2);
    }
}

@end