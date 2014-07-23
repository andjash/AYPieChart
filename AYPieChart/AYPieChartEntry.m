//
//  AYPieChartEntry.m
//  AYPieChartDemo
//
//  Created by Andrey Yashnev on 23/07/14.
//  Copyright (c) 2014 Andrey Yashnev. All rights reserved.
//

#import "AYPieChartEntry.h"

@interface AYPieChartEntry ()

@property (nonatomic, assign, readwrite) CGFloat value;
@property (nonatomic, retain, readwrite) UIColor *color;
@property (nonatomic, retain, readwrite) UIView<AYCompressibleView> *detailsView;

@end

@implementation AYPieChartEntry

#pragma mark - Static

+ (instancetype)entryWithValue:(CGFloat)value
                         color:(UIColor *)color
                   detailsView:(UIView<AYCompressibleView> *)detailsView{
    AYPieChartEntry *result = [[[AYPieChartEntry alloc] init] autorelease];
    result.value = value;
    result.color = color;
    result.detailsView = detailsView;
    return result;
}

#pragma mark - Init&Dealloc

- (void)dealloc {
    [_detailsView release];
    [_color release];
    [super dealloc];
}

@end