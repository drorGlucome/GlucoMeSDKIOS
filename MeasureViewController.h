//
//  FirstViewController.h
//  GlucoMe - Mobile
//
//  Created by Yiftah Ben Aharon on 1/9/14.
//  Copyright (c) 2014 Yiftah Ben Aharon. All rights reserved.
//  Updated by Dror Zohar on 28/05/17.
//  This is the measure page

#import <UIKit/UIKit.h>
#import "SingleMeasurementViewController.h"

@interface MeasureViewController : UIViewController {
    bool inScan;
    BOOL isOnTutorial;
}
@property (retain, nonatomic) IBOutlet UIImageView *baseView;
@property (retain, nonatomic) IBOutlet UIImageView *topView;

@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *waitingForMeasurementLabel;
@property (weak, nonatomic) IBOutlet UIButton *showIntroButton;
@property (weak, nonatomic) IBOutlet UIImageView *tutorialImageView;
@property (weak, nonatomic) IBOutlet UIButton *manualInputButton;
@property (weak, nonatomic) IBOutlet UIView *bubbleMenu;

@property(nonatomic, retain) NSDate *previousTime;

- (void)start:(id)sender;
- (void)stop:(id)sender;
- (void) initScanAnimation;
//- (void) scrollToResults;


@end
