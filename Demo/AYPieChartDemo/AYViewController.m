//
//  AYViewController.m
//  AYPieChartDemo
//
//  Created by Andrey Yashnev on 23/07/14.
//  Copyright (c) 2014 Andrey Yashnev. All rights reserved.
//

#import "AYViewController.h"
#import "AYPieChartView.h"
#import "AYPieChartEntryDetailsView.h"
#import "AYPieChartEntry.h"

@interface AYViewController ()

@property (nonatomic, retain) IBOutlet AYPieChartView *pieChartView;
@property (nonatomic, retain) IBOutlet UISlider *strokeSlider;
@property (nonatomic, retain) IBOutlet UISlider *fillSlider;
@property (nonatomic, retain) IBOutlet UISlider *degreeSlider;

@property (nonatomic, retain) IBOutlet UISlider *firstEntrySlider;
@property (nonatomic, retain) IBOutlet UISlider *secondEntrySlider;
@property (nonatomic, retain) IBOutlet UISlider *thirdEntrySlider;


@property (nonatomic, retain) AYPieChartEntryDetailsView *firstDetails;
@property (nonatomic, retain) AYPieChartEntryDetailsView *secondDetails;
@property (nonatomic, retain) AYPieChartEntryDetailsView *thirdDetails;



@end

@implementation AYViewController

#pragma mark - Init&Dealloc

- (void)dealloc {
    [_strokeSlider release];
    [_fillSlider release];
    [_degreeSlider release];
    [_firstEntrySlider release];
    [_secondEntrySlider release];
    [_thirdEntrySlider release];
    [_firstDetails release];
    [_secondDetails release];
    [_thirdDetails release];
    [super dealloc];
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.firstDetails = [AYPieChartEntryDetailsView instance];
    self.firstDetails.imageView.image = [UIImage imageNamed:@"pizza"];
    self.firstDetails.titleLabel.text = @"Pizza";
    
    self.secondDetails = [AYPieChartEntryDetailsView instance];
    self.secondDetails.imageView.image = [UIImage imageNamed:@"beer"];
    self.secondDetails.titleLabel.text = @"Beer";
    
    self.thirdDetails = [AYPieChartEntryDetailsView instance];
    self.thirdDetails.imageView.image = [UIImage imageNamed:@"fry"];
    self.thirdDetails.titleLabel.text = @"Fry";

    self.pieChartView.selectionEnabled = YES;
    self.pieChartView.selectedChartValueIndent = 20;
    [self slidersActions:nil];
}

#pragma mark - Private

- (void)recreatePieWithPizzaValue:(CGFloat)pizzaValue
                        beerValue:(CGFloat)beerValue
                         fryValue:(CGFloat)fryValue {
    
    
    NSArray *chartValues = @[[AYPieChartEntry entryWithValue:pizzaValue
                                                     color:[UIColor redColor]
                                               detailsView:_firstDetails],
                             [AYPieChartEntry entryWithValue:beerValue
                                                     color:[UIColor brownColor]
                                               detailsView:_secondDetails],
                             [AYPieChartEntry entryWithValue:fryValue
                                                     color:[UIColor orangeColor]
                                               detailsView:_thirdDetails]
                             ];
    self.pieChartView.pieValues = chartValues;
}

#pragma mark - Actions

- (IBAction)slidersActions:(id)sender {
    _pieChartView.strokeLineWidth = _strokeSlider.value;
    _pieChartView.fillLineWidth = _fillSlider.value;
    _pieChartView.degreesForSplit = _degreeSlider.value;
    
    [self recreatePieWithPizzaValue:_firstEntrySlider.value
                          beerValue:_secondEntrySlider.value
                            fryValue:_thirdEntrySlider.value];
}


@end

