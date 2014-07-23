//
//  AYPieChartView.h
//  AYPieChartDemo
//
//  Created by Andrey Yashnev on 23/07/14.
//  Copyright (c) 2014 Andrey Yashnev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AYPieChartView : UIView

@property (nonatomic, retain) NSArray *pieValues; // array of AYPieChartEntry

@property (nonatomic, assign) CGFloat strokeLineWidth;
@property (nonatomic, retain) UIColor *strokeLineColor;
@property (nonatomic, assign) CGFloat fillLineWidth;
@property (nonatomic, assign) CGFloat degreesForSplit;
@property (nonatomic, assign) CGFloat rotationEnabled;

@end
