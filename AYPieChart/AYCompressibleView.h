//
//  AYCompressibleView.h
//  AYPieChartDemo
//
//  Created by Andrey Yashnev on 23/07/14.
//  Copyright (c) 2014 Andrey Yashnev. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AYCompressibleView <NSObject>

- (CGSize)compressedViewSize;
- (CGSize)fullViewSize;

- (void)switchToCompressedView;
- (void)switchToFullView;

@end
