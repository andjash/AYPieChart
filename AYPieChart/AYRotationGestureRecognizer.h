//
//  AYRotationGestureRecognizer.h
//  AYPieChartDemo
//
//  Created by Andrey Yashnev on 23/07/14.
//  Copyright (c) 2014 Andrey Yashnev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AYRotationGestureRecognizer : UIGestureRecognizer

@property (nonatomic, assign) CGFloat rotationInRadians;
@property (nonatomic, assign) CGFloat velocity;
@property (nonatomic ,assign) BOOL velocityIsClockwise;

@end
