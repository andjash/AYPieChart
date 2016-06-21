//
//  AYRotationGestureRecognizer.m
//  AYPieChartDemo
//
//  Created by Andrey Yashnev on 23/07/14.
//  Copyright (c) 2014 Andrey Yashnev. All rights reserved.
//

#import "AYRotationGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation AYRotationGestureRecognizer

- (long long)currentTimeInMilliseconds {
    return (long long)floor([[NSDate date] timeIntervalSince1970] * 1000.0);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([[event touchesForGestureRecognizer:self] count] > 1) {
        [self setState:UIGestureRecognizerStateFailed];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([self state] == UIGestureRecognizerStatePossible) {
        [self setState:UIGestureRecognizerStateBegan];
    } else {
        [self setState:UIGestureRecognizerStateChanged];
    }
    UITouch *touch = [touches anyObject];
    UIView *view = [self view];
    CGPoint center = CGPointMake(CGRectGetMidX([view bounds]), CGRectGetMidY([view bounds]));
    CGPoint currentTouchPoint = [touch locationInView:view];
    CGPoint previousTouchPoint = [touch previousLocationInView:view];
    
    CGFloat angleInRadians = atan2f(currentTouchPoint.y - center.y, currentTouchPoint.x - center.x) - atan2f(previousTouchPoint.y - center.y, previousTouchPoint.x - center.x);
    if (fabs(angleInRadians) > M_PI) {
        if (angleInRadians > 0) {
            angleInRadians -= 2 * M_PI;
        } else {
            angleInRadians += 2 * M_PI;
        }
    }
    [self setRotationInRadians:angleInRadians];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([self state] == UIGestureRecognizerStateChanged) {
        [self setState:UIGestureRecognizerStateEnded];
    } else {
        [self setState:UIGestureRecognizerStateFailed];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self setState:UIGestureRecognizerStateFailed];
}

#pragma mark - Properties

- (void)setState:(UIGestureRecognizerState)state {
    [super setState:state];
    [self updateVelocity];
}

#pragma mark - Pirvate

- (void)updateVelocity {
    CGFloat angleInDegrees = _rotationInRadians * 180 / M_PI;
    
    static long long rotationStartTime = 0;
    static float rotationSummary = 0;
    switch (self.state) {
        case UIGestureRecognizerStateBegan:
            rotationStartTime = [self currentTimeInMilliseconds];
            rotationSummary = 0;
            break;
        case UIGestureRecognizerStateChanged:
        {
            long long rotationEndTime = [self currentTimeInMilliseconds];
            long long rotationTime = rotationEndTime - rotationStartTime;
            if (rotationTime > 50) {
                rotationStartTime = [self currentTimeInMilliseconds];
                rotationSummary = 0;
            } else {
                rotationSummary += fabs(angleInDegrees);
                self.velocityIsClockwise = angleInDegrees > 0;
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            long long rotationEndTime = [self currentTimeInMilliseconds];
            long long rotationTime = MAX((rotationEndTime - rotationStartTime), 1);
            self.velocity = (rotationSummary / rotationTime);
            return;
        }
            break;
        default:
            break;
    }
    self.velocity = 0;
}

@end
