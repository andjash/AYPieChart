//
//  AYPieChartView.h
//  AYPieChartDemo
//
//  Created by Andrey Yashnev on 23/07/14.
//  Copyright (c) 2014 Andrey Yashnev. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, EntryViewPostion) {
    EntryViewPostionCenter,
    EntryViewPostionCloseToSide,
};

@class AYPieChartView;
@class AYPieChartEntry;

@protocol AYPieChartViewDelegate <NSObject>

@optional
- (BOOL)pieChart:(AYPieChartView *)chartView willSelectChartEntry:(AYPieChartEntry *)entry;
- (void)pieChart:(AYPieChartView *)chartView didSelectChartEntry:(AYPieChartEntry *)entry;
- (void)pieChart:(AYPieChartView *)chartView didDeselectChartEntry:(AYPieChartEntry *)entry;

@end

@interface AYPieChartView : UIView

@property (nonatomic, retain) NSArray *pieValues; // array of AYPieChartEntry

@property (nonatomic, assign) CGFloat strokeLineWidth;
@property (nonatomic, retain) UIColor *strokeLineColor;
@property (nonatomic, assign) CGFloat fillLineWidth;
@property (nonatomic, assign) CGFloat degreesForSplit;
@property (nonatomic, assign) EntryViewPostion entryViewPostion;
@property (nonatomic, assign) CGFloat minSegmentAngle;

@property (nonatomic, assign) BOOL rotationEnabled;
@property (nonatomic, assign) BOOL selectionEnabled;

@property (nonatomic, retain) AYPieChartEntry *selectedChartEntry;
@property (nonatomic, retain) UIColor *selectedEntryColor;
@property (nonatomic, assign) CGFloat selectedChartValueIndent;
@property (nonatomic, assign) CGFloat selectedChartValueAngleDelta; // in radians
@property (nonatomic, assign) CGFloat minDrawDetailViewWith;
@property (nonatomic, assign) BOOL showDetailForZeroEnabled;
@property (nonatomic, assign) id<AYPieChartViewDelegate> delegate;

- (CGFloat)angleInDegreesForPieChartEntry:(AYPieChartEntry *)entry;

@end
