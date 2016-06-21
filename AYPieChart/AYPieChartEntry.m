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
@property (nonatomic, retain, readwrite) UIImage *image;

@end

@implementation AYPieChartEntry

#pragma mark - Static

+ (instancetype)entryWithValue:(CGFloat)value
                         color:(UIColor *)color
                   detailsView:(UIView<AYCompressibleView> *)detailsView{
    return [self entryWithValue:value color:color image:nil detailsView:detailsView];
}

+ (instancetype)entryWithValue:(CGFloat)value
                         color:(UIColor *)color
                         image:(UIImage *)image
                   detailsView:(UIView<AYCompressibleView> *)detailsView {
    AYPieChartEntry *result = [[[AYPieChartEntry alloc] init] autorelease];
    result.value = value;
    result.color = color;
    result.detailsView = detailsView;
    result.image = image;
    return result;
}


#pragma mark - Init&Dealloc

- (void)dealloc {
    [_image release];
    [_detailsView release];
    [_color release];
    [super dealloc];
}

@end