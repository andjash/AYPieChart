//
//  AYPieChartEntryDetailsView.h
//  PieChartAnalytics
//
//  Created by Andrey Yashnev on 22/07/14.
//  Copyright (c) 2014 Andrey Yashnev. All rights reserved.
//

#import "AYCompressibleView.h"

@interface AYPieChartEntryDetailsView : UIView<AYCompressibleView>

@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;

+ (instancetype)instance;

@end
