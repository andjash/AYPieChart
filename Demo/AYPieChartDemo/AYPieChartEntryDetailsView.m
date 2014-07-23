//
//  AYPieChartEntryDetailsView.m
//  PieChartAnalytics
//
//  Created by Andrey Yashnev on 22/07/14.
//  Copyright (c) 2014 Andrey Yashnev. All rights reserved.
//

#import "AYPieChartEntryDetailsView.h"

@implementation AYPieChartEntryDetailsView

#pragma mark - Static

+ (instancetype)instance {
    AYPieChartEntryDetailsView *view = [[NSBundle mainBundle] loadNibNamed:@"AYPieChartEntryDetailsView"
                                                                     owner:nil
                                                                   options:nil][0];
    return view;
}

#pragma mark - Init&Dealloc

- (void)dealloc {
    [_titleLabel release];
    [_imageView release];
    [super dealloc];
}

#pragma mark - CompressibleView

- (CGSize)compressedViewSize {
    return CGSizeMake(25, 25);
}

- (CGSize)fullViewSize {
    return CGSizeMake(70, 45);
}

- (void)switchToCompressedView {
    self.titleLabel.alpha = 0;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 30, 30);
    self.imageView.frame = CGRectMake(0, 0, self.imageView.frame.size.width, self.imageView.frame.size.height);
}

- (void)switchToFullView {
    self.titleLabel.alpha = 1;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 70, 45);
    self.imageView.frame = CGRectMake(23, 0, self.imageView.frame.size.width, self.imageView.frame.size.height);
}

@end
