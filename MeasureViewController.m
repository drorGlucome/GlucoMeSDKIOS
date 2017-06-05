//
//  FirstViewController.m
//  GlucoMe - Mobile
//
//  Created by Yiftah Ben Aharon on 1/9/14.
//  Copyright (c) 2014 Yiftah Ben Aharon. All rights reserved.
//

#import "MeasureViewController.h"

#import <QuartzCore/QuartzCore.h>
#import "HelpDialogManager.h"
#import "general.h"
#define ManualInput_UID 9999

static NSString *const menuCellIdentifier = @"rotationCell";

@interface MeasureViewController ()



@property (nonatomic, strong) NSArray *menuTitles;
@property (nonatomic, strong) NSArray *menuIcons;
@end

@implementation MeasureViewController
@synthesize baseView;
@synthesize topView;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initScanAnimation];
    inScan = false;

    UISwipeGestureRecognizer* swipeleft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(SwipeLeftGestureRecognizer)];
    swipeleft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeleft];
}

-(void)SwipeLeftGestureRecognizer
{
    self.tabBarController.selectedIndex++;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    isOnTutorial = NO;
    
    [self.startButton setHidden:YES];
    
    self.waitingForMeasurementLabel.text = loc(@"Place a blood drop onto the strip");
    
    [self SetTitle];
    
}

-(void)AnimateTutorialImageView
{
    [self.tutorialImageView startAnimating];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if(isOnTutorial == NO)
        [self stop:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self start:self.startButton];
    
    //if had not seen tutorial: show it
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults boolForKey:@"didSeeTutorial"] == NO)
    {
        [self showTutorial:nil];
        
        [defaults setBool:YES forKey:@"didSeeTutorial"];
        [defaults synchronize];
    }
     
}

-(void)SetTitle
{
    self.titleLabel.text = [NSString stringWithFormat:@"%@", loc(@"Welcome")];

}

- (IBAction)showTutorial:(id)sender
{
    isOnTutorial = YES;
    UIViewController* vc =  [[UIStoryboard storyboardWithName:@"IntroStoryboard" bundle:[self getBundle]] instantiateInitialViewController];
    [self presentViewController:vc animated:NO completion:nil];
}

- (IBAction)stop:(id)sender {
}

- (void)start:(id)sender
{
    [self.topView.layer removeAllAnimations];

    UIButton* button = (UIButton*)sender;

    [self.view bringSubviewToFront:button];
    
    [self.baseView startAnimating];
    
    [self rotateImageView];
    
    inScan = true;
    
}

- (void)rotateImageView
{
    CGFloat direction = 1.0f;  // -1.0f to rotate other way
    self.topView.transform = CGAffineTransformIdentity;
    [UIView animateKeyframesWithDuration:4 delay:0.0
                                 options:UIViewKeyframeAnimationOptionCalculationModeLinear | UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveLinear
                              animations:^{
                                  [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.33 animations:^{
                                      self.topView.transform = CGAffineTransformMakeRotation(M_PI * 2.0f / 3.0f * direction);
                                  }];
                                  [UIView addKeyframeWithRelativeStartTime:0.33 relativeDuration:0.33 animations:^{
                                      self.topView.transform = CGAffineTransformMakeRotation(M_PI * 4.0f / 3.0f * direction);
                                  }];
                                  [UIView addKeyframeWithRelativeStartTime:0.66 relativeDuration:0.33 animations:^{
                                      self.topView.transform = CGAffineTransformIdentity;
                                  }];
                              }
                              completion:^(BOOL finished) {}];
}

- (void) initScanAnimation {
    NSMutableArray* images = [[NSMutableArray alloc] init];
    for(int i=1;i<=5;i++) {
        NSString* tmp = [[NSString alloc] initWithFormat:@"radar_%d.png", i ];
        [images addObject:[UIImage imageNamed:tmp inBundle:[self getBundle] compatibleWithTraitCollection:nil]];
    }
    self.baseView.animationImages = images;
    self.baseView.animationRepeatCount = 10000;
    self.baseView.animationDuration = 3;
    
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(WaitingForMeasurementAnimation) userInfo:nil repeats:YES];
}

-(void)WaitingForMeasurementAnimation
{
    static int numberOfDots = 2;

    NSString* t = [NSString stringWithFormat:@"%@...",loc(@"Place a blood drop onto the strip")];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:t];
    [text addAttribute:NSForegroundColorAttributeName
                 value:[UIColor clearColor]
                 range:NSMakeRange(t.length-numberOfDots, numberOfDots)];
    
    [self.waitingForMeasurementLabel setAttributedText:text];
    
    numberOfDots = (numberOfDots - 1) % 3;
    numberOfDots = (numberOfDots < 0) ? 3 + numberOfDots : numberOfDots;
}

- (IBAction)dismissButton:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (NSTimeInterval)timeDifferenceSinceLastOpen {
    
    if (!self.previousTime) self.previousTime = [NSDate date];
    NSDate *currentTime = [NSDate date];
    NSTimeInterval timeDifference =  [currentTime timeIntervalSinceDate:self.previousTime];
    self.previousTime = currentTime;
    return timeDifference;
}

- (NSBundle *)getBundle {
    NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:@"GlucoMe" withExtension:@"bundle"];
    NSBundle* bundle = [NSBundle bundleWithURL:bundleURL];
    
    return bundle;
}


-(void)becomeActive:(NSNotification *)notification {
    [self start:self.startButton];
}


@end
