//
//  AYPieChartUtils.h
//  AYWatchPieChart
//
//  Created by Andrey Yashnev on 21/06/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AYPieChartEntry;

typedef NS_ENUM(NSUInteger, EntryViewPostion) {
    EntryViewPostionCenter,
    EntryViewPostionCloseToSide,
};

@interface AYPieChartImageConfiguration : NSObject

@property (nonatomic, assign) CGFloat imageWidth;
@property (nonatomic, assign) CGFloat fillLineWidth;
@property (nonatomic, assign) CGFloat strokeLineWidth;
@property (nonatomic, assign) CGFloat minSegmentAngle;
@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, strong) NSArray<AYPieChartEntry *> *entries;
@property (nonatomic, assign) EntryViewPostion entryViewPostion;

@end

@interface AYPieChartUtils : NSObject

+ (UIImage *)chartImageWithConfiguration:(AYPieChartImageConfiguration *)configuration;


+ (CGFloat)summFromPieValues:(NSArray *)pieValues;
+ (NSArray<AYPieChartEntry *> *)createInnerPieValues:(NSArray<AYPieChartEntry *> *)entries minSegmentAngle:(CGFloat)minAngle;
+ (NSArray *)balanceArray:(NSArray *)target withMinValue:(CGFloat)minValue;
+ (NSArray *)decreaseValue:(CGFloat)balanceValue fromArray:(NSArray *)target minValue:(CGFloat)min;
+ (CGFloat)distanceBetween:(CGPoint)first and:(CGPoint)second;
+ (CGFloat)diagonalLenght:(CGSize)size;

@end
