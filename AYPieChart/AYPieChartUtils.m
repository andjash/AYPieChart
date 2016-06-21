//
//  AYPieChartUtils.m
//  Pods
//
//  Created by Andrey Yashnev on 21/06/16.
//
//

#import "AYPieChartUtils.h"
#import "AYPieChartEntry.h"

@implementation AYPieChartImageConfiguration
@end

@implementation AYPieChartUtils

+ (UIImage *)chartImageWithConfiguration:(AYPieChartImageConfiguration *)configuration {
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(configuration.imageWidth, configuration.imageWidth), NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    NSArray *innerPieValues = [self createInnerPieValues:configuration.entries minSegmentAngle:configuration.minSegmentAngle];
    CGPoint center = {configuration.imageWidth / 2, configuration.imageWidth / 2};
    CGFloat radius = (configuration.imageWidth / 2) - ((configuration.fillLineWidth + configuration.strokeLineWidth) / 2);
    
    
    CGFloat summ = [self summFromPieValues:innerPieValues];
    if (summ == 0) {
        for (AYPieChartEntry *entry in innerPieValues) {
            [entry.detailsView removeFromSuperview];
        }
        return nil;
    }
    
    CGFloat startAngle = 0;
    CGFloat endAngle = 0.0f;
    CGFloat radiansForSplit = 0;
    
    NSUInteger notVoidValuesCount = 0;
    for (AYPieChartEntry *entry in innerPieValues) {
        if (entry.value > 0) {
            notVoidValuesCount++;
        }
    }
    notVoidValuesCount = notVoidValuesCount == 1 ? 0 : notVoidValuesCount;
    CGFloat avaliableCircleSpace = (2 * M_PI) - (radiansForSplit * notVoidValuesCount);
    
    for (AYPieChartEntry *entry in innerPieValues) {
        if (entry.value == 0) {
            continue;
        }
        endAngle = -(fabs(startAngle) + (avaliableCircleSpace * entry.value / summ));
        CGMutablePathRef path = CGPathCreateMutable();
        
        CGFloat localStartAngle = startAngle;
        CGFloat localEndAngle = endAngle;
        CGPoint localCenter = center;
        
        CGFloat startX = localCenter.x + radius * cos(localStartAngle);
        CGFloat startY = localCenter.y + radius * sin(localStartAngle);
        CGPathMoveToPoint(path, NULL, startX, startY);
        
        if (notVoidValuesCount > 1) {
            CGPathAddArc(path, NULL, localCenter.x, localCenter.y, radius, localStartAngle, localEndAngle, YES);
        } else {
            CGPathAddEllipseInRect(path, NULL, CGRectMake(center.x - radius,
                                                          center.y - radius,
                                                          2 * radius, 2 * radius));
            
        }
        CGPathRef strokedArc = CGPathCreateCopyByStrokingPath(path, NULL, configuration.fillLineWidth, kCGLineCapButt, kCGLineJoinRound, 30);
        
        CGContextAddPath(context, strokedArc);
        CGContextSetFillColorWithColor(context, [entry color].CGColor);
        CGContextSetStrokeColorWithColor(context, configuration.strokeColor.CGColor);
        CGContextSetLineWidth(context, configuration.strokeLineWidth);
        CGContextDrawPath(context, kCGPathFillStroke);
        CGPathRelease(strokedArc);
        CGPathRelease(path);
        startAngle = endAngle - radiansForSplit;
        
        if (entry.image) {
            CGPoint startPoint = CGPointMake(localCenter.x + radius * cos(localStartAngle), center.y + radius * sin(localStartAngle));
            CGPoint endPoint = CGPointMake(localCenter.x + radius * cos(localEndAngle), center.y + radius * sin(localEndAngle));
            CGFloat widthDistance = [self distanceBetween:startPoint and:endPoint];
            if (fabs(localEndAngle - localStartAngle) > M_PI_2) {
                widthDistance = CGFLOAT_MAX;
            }
            
            CGFloat middleAngle = (localStartAngle + localEndAngle) / 2;
            startPoint = CGPointMake(localCenter.x + (radius - (configuration.fillLineWidth - configuration.strokeLineWidth) / 2) * cos(middleAngle),
                                     localCenter.y + (radius - (configuration.fillLineWidth - configuration.strokeLineWidth) / 2) * sin(middleAngle));
            endPoint = CGPointMake(localCenter.x + (radius + (configuration.fillLineWidth + configuration.strokeLineWidth) / 2) * cos(middleAngle),
                                   localCenter.y + (radius + (configuration.fillLineWidth + configuration.strokeLineWidth) / 2) * sin(middleAngle));
            CGFloat heightDistance = [self distanceBetween:startPoint and:endPoint];
            
            CGSize fullSize = [entry.image size];
            CGFloat iconDiagonal = [self diagonalLenght:fullSize];
            
            BOOL useFullSize = NO;
            if (widthDistance > iconDiagonal && heightDistance > iconDiagonal) {
                useFullSize = YES;
            } else {
                iconDiagonal = [self diagonalLenght:CGSizeMake(entry.image.size.width / 2, entry.image.size.height / 2)];
            }
            
            if (widthDistance > iconDiagonal && heightDistance > iconDiagonal) {
                CGFloat distance = radius;
                CGFloat imgWidth = entry.image.size.width;
                CGFloat imgHeight = entry.image.size.height;
                
                if (!useFullSize) {
                    imgWidth = imgWidth / 2;
                    imgHeight = imgHeight / 2;
                }
                
                if (configuration.entryViewPostion == EntryViewPostionCloseToSide){
                    distance = (radius + (configuration.strokeLineWidth + configuration.fillLineWidth) / 2) -
                    ([self diagonalLenght:CGSizeMake(imgWidth, imgHeight)] / 2);
                }                
                
                CGFloat imageX = localCenter.x + distance * cos(middleAngle);
                CGFloat imageY = localCenter.y + distance * sin(middleAngle);
                imageX -= entry.detailsView.frame.size.width / 2;
                imageY -= entry.detailsView.frame.size.height / 2;

                [entry.image drawInRect:CGRectMake(imageX - imgWidth / 2, imageY - imgHeight / 2, imgWidth, imgHeight)];
            }
        }
    }
    
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

+ (CGFloat)summFromPieValues:(NSArray *)pieValues {
    CGFloat result = 0;
    for (AYPieChartEntry *entry in pieValues) {
        result += entry.value;
    }
    return result;
}


+ (NSArray<AYPieChartEntry *> *)createInnerPieValues:(NSArray<AYPieChartEntry *> *)entries minSegmentAngle:(CGFloat)minAngle {
    NSMutableArray *initialValues = [NSMutableArray arrayWithCapacity:[entries count]];
    CGFloat summ = 0;
    for (AYPieChartEntry *entry in entries) {
        [initialValues addObject:@(entry.value)];
        summ += entry.value;
    }
    CGFloat minValue = (minAngle / (2 * M_PI)) * summ;
    NSArray *balancedValues = [self balanceArray:initialValues withMinValue:minValue];
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[entries count]];
    for (int i = 0 ; i < [entries count]; i++) {
        AYPieChartEntry *newEntry = [AYPieChartEntry entryWithValue:[balancedValues[i] floatValue]
                                                              color:[entries[i] color]
                                                              image:entries[i].image
                                                        detailsView:[entries[i] detailsView]];
        [result addObject:newEntry];
    }
    return result;
}

+ (NSArray *)balanceArray:(NSArray *)target withMinValue:(CGFloat)minValue {
    NSMutableArray *neutralValues = [NSMutableArray array];
    NSMutableArray *valuesToDecrease = [NSMutableArray array];
    NSMutableArray *result = [NSMutableArray arrayWithArray:target];
    CGFloat balanceValue = 0;
    
    for (int i = 0; i < [target count]; i++) {
        NSNumber *number = target[i];
        CGFloat floatValue = [number floatValue];
        
        if (floatValue == minValue) {
            [neutralValues addObject:@[@(minValue), @(i)]];
            continue;
        }
        
        if (floatValue < minValue) {
            [neutralValues addObject:@[@(minValue), @(i)]];
            balanceValue += minValue + floatValue;
            continue;
        }
        
        [valuesToDecrease addObject:@[number, @(i)]];
    }
    
    NSArray *decreasedValues = [self decreaseValue:balanceValue
                                         fromArray:valuesToDecrease
                                          minValue:minValue];
    
    for (NSArray *values in decreasedValues) {
        [result replaceObjectAtIndex:[values[1] unsignedIntegerValue] withObject:values[0]];
    }
    for (NSArray *values in neutralValues) {
        [result replaceObjectAtIndex:[values[1] unsignedIntegerValue] withObject:values[0]];
    }
    
    return result;
}

+ (NSArray *)decreaseValue:(CGFloat)balanceValue fromArray:(NSArray *)target minValue:(CGFloat)min {
    NSMutableArray *result = [NSMutableArray array];
    CGFloat targetArraySumm = 0;
    for (NSArray *value in target) {
        targetArraySumm += [value[0] floatValue];
    }
    
    CGFloat difRes = 0;
    for (NSArray *value in target) {
        CGFloat floatValue = [value[0] floatValue];
        
        CGFloat newValue = MAX(min, floatValue - ((floatValue / targetArraySumm) * balanceValue));
        difRes += floatValue - newValue;
        [result addObject:@[@(newValue), value[1]]];
    }
    return result;
}

+ (CGFloat)distanceBetween:(CGPoint)first and:(CGPoint)second {
    CGFloat xDist = (second.x - first.x);
    CGFloat yDist = (second.y - first.y);
    return sqrt((xDist * xDist) + (yDist * yDist));
}

+ (CGFloat)diagonalLenght:(CGSize)size {
    CGFloat diagonalSquare = size.width * size.width + size.height * size.height;
    return sqrtf(diagonalSquare);
}


@end
