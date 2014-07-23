//
//  AYPieChartView.m
//  AYPieChartDemo
//
//  Created by Andrey Yashnev on 23/07/14.
//  Copyright (c) 2014 Andrey Yashnev. All rights reserved.
//

#import "AYPieChartView.h"
#import "AYPieChartEntry.h"
#import "AYRotationGestureRecognizer.h"

@interface AYPieChartView ()

@property (nonatomic, retain) NSMutableArray *fadeOutEntries;
@property (nonatomic, assign) CGFloat rotation;
@property (nonatomic, retain) AYRotationGestureRecognizer *rotationRecognizer;

@end

@implementation AYPieChartView

#pragma mark - Init&Dealloc

- (void)dealloc {
    [_fadeOutEntries release];
    [_pieValues release];
    [super dealloc];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.rotationRecognizer = [[[AYRotationGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(rotationRecognized:)]
                                                     autorelease];
    self.rotationEnabled = YES;
    self.fadeOutEntries = [NSMutableArray array];
    self.strokeLineColor = [UIColor whiteColor];
    self.strokeLineWidth = 1.5;
    self.fillLineWidth = 80;
    self.degreesForSplit = 8;
}

#pragma mark - Properties

- (void)setRotationEnabled:(CGFloat)rotationEnabled {
    _rotationEnabled = rotationEnabled;
    if (_rotationEnabled) {
        [self addGestureRecognizer:self.rotationRecognizer];
    } else {
        [self removeGestureRecognizer:self.rotationRecognizer];
    }
}

- (void)setDegreesForSplit:(CGFloat)degreesForSplit {
    _degreesForSplit = degreesForSplit;
    [self setNeedsDisplay];
}

- (void)setStrokeLineWidth:(CGFloat)strokeLineWidth {
    _strokeLineWidth = strokeLineWidth;
    [self setNeedsDisplay];
}

- (void)setFillLineWidth:(CGFloat)fillLineWidth {
    _fillLineWidth = fillLineWidth;
    [self setNeedsDisplay];
}

- (void)setPieValues:(NSArray *)pieValues {
    [_pieValues autorelease];
    _pieValues = [pieValues retain];
    [self setNeedsDisplay];
}

#pragma mark - UIView

- (void)drawRect:(CGRect)rect {
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGPoint center = {width / 2, height / 2};
    CGFloat radius = width > height ? center.y : center.x;
    radius -= (_fillLineWidth + _strokeLineWidth) / 2;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat summ = [self summFromPieValues:self.pieValues];
    if (summ == 0) {
        for (AYPieChartEntry *entry in self.pieValues) {
            [entry.detailsView removeFromSuperview];
        }
        return;
    }
    
    CGFloat startAngle = 0;
    if (_rotation > 0) {
        startAngle = (-360 + _rotation) * M_PI / 180;
    } else {
        startAngle = _rotation * M_PI / 180;
    }
    CGFloat endAngle = 0.0f;
    CGFloat radiansForSplit = (_degreesForSplit/*degree per connection*/ * M_PI) / 180;
    
    NSUInteger notVoidValuesCount = 0;
    for (AYPieChartEntry *entry in self.pieValues) {
        if (entry.value > 0) {
            notVoidValuesCount++;
        }
    }
    notVoidValuesCount = notVoidValuesCount == 1 ? 0 : notVoidValuesCount;
    CGFloat avaliableCircleSpace = (2 * M_PI) - (radiansForSplit * notVoidValuesCount);
    
    for (AYPieChartEntry *entry in self.pieValues) {
        if (entry.value == 0) {
            continue;
        }
        endAngle = -(fabs(startAngle) + (avaliableCircleSpace * entry.value / summ));
        
        CGMutablePathRef path = CGPathCreateMutable();
        
        CGFloat startX = center.x + radius * cos(startAngle);
        CGFloat startY = center.y + radius * sin(startAngle);
        CGPathMoveToPoint(path, NULL, startX, startY);
        
        if (notVoidValuesCount > 1) {
            CGPathAddArc(path, NULL, center.x, center.y, radius, startAngle, endAngle, YES);
        } else {
            CGPathAddEllipseInRect(path, NULL, CGRectMake(center.x - radius,
                                                          center.y - radius,
                                                          2 * radius, 2 * radius));
            
        }
        CGPathRef strokedArc = CGPathCreateCopyByStrokingPath(path, NULL, _fillLineWidth, kCGLineCapButt, kCGLineJoinRound, 30);
        
        
        CGContextAddPath(context, strokedArc);
        CGContextSetFillColorWithColor(context, [entry color].CGColor);
        CGContextSetStrokeColorWithColor(context, self.strokeLineColor.CGColor);
        CGContextSetLineWidth(context, _strokeLineWidth);
        CGContextDrawPath(context, kCGPathFillStroke);
        
        if (entry.detailsView) {
            CGPoint startPoint = CGPointMake(center.x + radius * cos(startAngle), center.y + radius * sin(startAngle));
            CGPoint endPoint = CGPointMake(center.x + radius * cos(endAngle), center.y + radius * sin(endAngle));
            CGFloat widthDistance = [self distanceBetween:startPoint and:endPoint];
            if (fabs(endAngle - startAngle) > M_PI_2) {
                widthDistance = CGFLOAT_MAX;
            }
            
            CGFloat middleAngle = (startAngle + endAngle) / 2;
            startPoint = CGPointMake(center.x + (radius - (_fillLineWidth - _strokeLineWidth) / 2) * cos(middleAngle),
                                     center.y + (radius - (_fillLineWidth - _strokeLineWidth) / 2) * sin(middleAngle));
            endPoint = CGPointMake(center.x + (radius + (_fillLineWidth + _strokeLineWidth) / 2) * cos(middleAngle),
                                   center.y + (radius + (_fillLineWidth + _strokeLineWidth) / 2) * sin(middleAngle));
            CGFloat heightDistance = [self distanceBetween:startPoint and:endPoint];
            
            CGSize fullSize = [entry.detailsView fullViewSize];
            CGFloat iconDiagonal = [self diagonalLenght:fullSize];
            
            if (widthDistance > iconDiagonal && heightDistance > iconDiagonal) {
                [entry.detailsView switchToFullView];
            } else {
                iconDiagonal = [self diagonalLenght:[entry.detailsView compressedViewSize]];
                [entry.detailsView switchToCompressedView];
            }
            
            if (widthDistance > iconDiagonal && heightDistance > iconDiagonal) {
                CGFloat imageX = center.x + radius * cos(middleAngle);
                CGFloat imageY = center.y + radius * sin(middleAngle);
                imageX -= entry.detailsView.frame.size.width / 2;
                imageY -= entry.detailsView.frame.size.height / 2;
                entry.detailsView.frame = CGRectMake(imageX, imageY, entry.detailsView.frame.size.width, entry.detailsView.frame.size.height);
                if ([entry.detailsView superview] != self)  {
                    entry.detailsView.alpha = 0;
                    [self addSubview:entry.detailsView];
                    [UIView animateWithDuration:0.4 animations:^{
                        entry.detailsView.alpha = 1;
                    }];
                    [self addSubview:entry.detailsView];
                }
            } else {
                if (![_fadeOutEntries containsObject:entry.detailsView]) {
                    [UIView animateWithDuration:0.3 animations:^{
                        [_fadeOutEntries addObject:entry.detailsView];
                        entry.detailsView.alpha = 0;
                    } completion:^(BOOL finished) {
                        [entry.detailsView removeFromSuperview];
                        [_fadeOutEntries removeObject:entry.detailsView];
                    }];
                }
            }
        }
        startAngle = endAngle - radiansForSplit;
    }
}

#pragma mark - Private

- (CGFloat)summFromPieValues:(NSArray *)pieValues {
    CGFloat result = 0;
    for (AYPieChartEntry *entry in pieValues) {
        result += entry.value;
    }
    return result;
}

- (CGFloat)diagonalLenght:(CGSize)size {
    CGFloat diagonalSquare = size.width * size.width + size.height * size.height;
    return sqrtf(diagonalSquare);
}

- (CGFloat)distanceBetween:(CGPoint)first and:(CGPoint)second {
    CGFloat xDist = (second.x - first.x);
    CGFloat yDist = (second.y - first.y);
    return sqrt((xDist * xDist) + (yDist * yDist));
}

- (void)rotationRecognized:(AYRotationGestureRecognizer *)gesture {
    CGFloat velocity = [gesture velocity];
    if (velocity != 0) {
        [self drawVelocityAnimation:velocity
                  timeSinceLastStep:0
                          clockwise:gesture.velocityIsClockwise];
    }
    [self rotateWithRadians:gesture.rotationInRadians];
}

- (void)drawVelocityAnimation:(CGFloat)velocity
            timeSinceLastStep:(NSUInteger)timeSinceLastStep
                    clockwise:(BOOL)isClockwise {
    if (velocity < 0.01) {
        return;
    }
    long long startTime = [self currentTimeInMilliseconds];
    if (timeSinceLastStep == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSUInteger step = [self currentTimeInMilliseconds] - startTime;
            [self drawVelocityAnimation:velocity
                      timeSinceLastStep:step
                              clockwise:isClockwise];
        });
    } else {
        [self rotateWithRadians:(velocity * timeSinceLastStep * (isClockwise ? 1 : -1)) * M_PI / 180];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSUInteger step = [self currentTimeInMilliseconds] - startTime;
            [self drawVelocityAnimation:velocity * 0.95
                      timeSinceLastStep:step
                              clockwise:isClockwise];
        });
    }
}

- (long long)currentTimeInMilliseconds {
    return (long long)floor([[NSDate date] timeIntervalSince1970] * 1000.0);
}

- (void)rotateWithRadians:(CGFloat)angleRadians {
    CGFloat angleInDegrees = angleRadians * 180 / M_PI;
    _rotation += angleInDegrees;
    _rotation = fmodf(_rotation, 360);
    [self setNeedsDisplay];
}

@end
