# AYPieChart

Configurable pie chart

### Preview

![Preview1](https://raw.githubusercontent.com/andjash/AYPieChart/master/screenshots/screen_1.png)
![Preview2](https://raw.githubusercontent.com/andjash/AYPieChart/master/screenshots/screen_2.png)
![Preview3](https://raw.githubusercontent.com/andjash/AYPieChart/master/screenshots/screen_3.png)
![Preview4](https://raw.githubusercontent.com/andjash/AYPieChart/master/screenshots/screen_4.png)
![Preview5](https://raw.githubusercontent.com/andjash/AYPieChart/master/screenshots/screen_5.png)
![Preview6](https://raw.githubusercontent.com/andjash/AYPieChart/master/screenshots/screen_6.png)
![Preview7](https://raw.githubusercontent.com/andjash/AYPieChart/master/screenshots/screen_7.png)

### Usage

Import required headers

```objc

#import "AYPieChartView.h"
#import "AYPieChartEntry.h"

```

Create instance of AYPieChartView and attach it to another view.
Create instances of AYPieChartEntry according to your data and attach entries to AYPieChartView

```objc

    
    NSArray *chartValues = @[[AYPieChartEntry entryWithValue:firstDataValue
                                                     color:[UIColor redColor]
                                               detailsView:nil],
                             [AYPieChartEntry entryWithValue:secondDataValue
                                                     color:[UIColor brownColor]
                                               detailsView:nil]
                             ];
    self.pieChartView.pieValues = chartValues;

```

Thats all for simple case!

For more interesting cases pls review demo.
