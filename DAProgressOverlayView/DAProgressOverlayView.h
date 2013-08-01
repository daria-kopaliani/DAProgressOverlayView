//
//  DAProgressOverlayView.h
//  DAProgressOverlayView
//
//  Created by Daria Kopaliani on 8/1/13.
//  Copyright (c) 2013 Daria Kopaliani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DAProgressOverlayView : UIView

@property (strong, nonatomic) UIColor *overlayColor;

/*
 ratio of inner circle to the minimum side of DAProgressOverlayView
 0 ≤ innerRadiusRatio ≤ 1
 */
@property (assign, nonatomic) CGFloat innerRadiusRatio;

/*
 ratio of outer circle to the minimum side of DAProgressOverlayView
 0 ≤ outerRadiusRatio ≤ 1
 */
@property (assign, nonatomic) CGFloat outerRadiusRatio;

/*
  0 ≤ progress ≤ 1
 */
@property (assign, nonatomic) CGFloat progress;

@end
