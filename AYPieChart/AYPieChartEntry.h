//
//  AYPieChartEntry.h
//  AYPieChartDemo
//
//  Created by Andrey Yashnev on 23/07/14.
//  Copyright (c) 2014 Andrey Yashnev. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AYCompressibleView.h"

@interface AYPieChartEntry : NSObject

@property (nonatomic, assign, readonly) CGFloat value;
@property (nonatomic, retain, readonly) UIColor *color;
@property (nonatomic, retain, readonly) UIView<AYCompressibleView> *detailsView;
@property (nonatomic, retain, readonly) UIImage *image;

+ (instancetype)entryWithValue:(CGFloat)value
                         color:(UIColor *)color
                   detailsView:(UIView<AYCompressibleView> *)detailsView;

+ (instancetype)entryWithValue:(CGFloat)value
                         color:(UIColor *)color
                         image:(UIImage *)image
                   detailsView:(UIView<AYCompressibleView> *)detailsView;

@end
