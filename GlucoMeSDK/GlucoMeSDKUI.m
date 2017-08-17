//
//  GlucoMeSDK.m
//  GlucoMeSDK
//
//  Created by דרור זוהר on 5/17/17.
//  Copyright © 2017 דרור זוהר. All rights reserved.
//

#import "GlucoMeSDKUI.h"
#import "GlucoMeAudioSDK.h"
#import "HelpDialogManager.h"
#import <QuartzCore/QuartzCore.h>
#import "SingleMeasurementViewController.h"

@interface GlucoMeSDKUI ()
<
GlucoMeSDKDelegateProtocol,
SingleMeasurementViewControllerDelegateProtocol
>
@property (nonatomic) GlucoMeSDK *glucoMeAudioSDK;

@end

@implementation GlucoMeResult
@end

@implementation GlucoMeTagResult
@end

@implementation GlucoMeSDKUI

@synthesize glucoMeAudioSDK;
@synthesize delegate;

bool isRadarOn = false;
bool isTutorialOn = false;
SingleMeasurementViewController *singleMeasurementViewController;

-(id)init
{
    if(self) {
        glucoMeAudioSDK =  [[GlucoMeSDK alloc] init];
    
        [glucoMeAudioSDK setDelegate:self];
    }
    
    return self;
}

-(void)start
{
    
    [glucoMeAudioSDK startWithAudioPermissionDenidedBlock:^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Microphone permission denied"
                                                                                 message:@"The app must have microphone permission to communicate with the BGM"
                                                                          preferredStyle:UIAlertControllerStyleAlert]; UIAlertAction *okAction = [UIAlertAction
                                                                                                                                                  actionWithTitle:@"Grant permission" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                                                                                                                                  {
                                                                                                                                NSDictionary *options = @{UIApplicationOpenURLOptionUniversalLinksOnly : @YES};
                                                                                                                                                      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:options completionHandler:nil];
                                                                                                                                                  }];
        UIAlertAction *exitAction = [UIAlertAction
                                     actionWithTitle:@"Exit app" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                         exit(0); }];
        [alertController addAction:okAction];
        [alertController addAction:exitAction];
        [[self topMostController] presentViewController:alertController animated:YES completion:nil];
    }];
}

- (IBAction)showTutorial
{
    isTutorialOn = true;
    UIViewController* vc =  [[UIStoryboard storyboardWithName:@"IntroStoryboard" bundle:[self getBundle]]instantiateInitialViewController];

    [[self topMostController] presentViewController:vc animated:NO completion:nil];

    [self start];
}

- (void)start: (BOOL)withUI
{
    [self start];
    
    if(withUI) {
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"GlucoMeSDK" bundle:[self getBundle]];
        UINavigationController* singleMeasurementNavigationController = [storyboard instantiateViewControllerWithIdentifier:@"MeasureNavigatorControllerID"];

        [[self topMostController] presentViewController:singleMeasurementNavigationController animated:NO completion:nil];

        isRadarOn = true;
    }
}

- (void)showGlucoMeResult:(GlucoMeResult*)gluocoMeResult withTagResult:(GlucoMeTagResult*)glucoMeTagResult
{
    if(isRadarOn || isTutorialOn) {
        [[self topMostController] dismissViewControllerAnimated:NO completion:nil];
        isTutorialOn = false;
        isRadarOn = false;
    }
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"GlucoMeSDK" bundle:[self getBundle]];
     UINavigationController* singleMeasurementNavigationController = [storyboard instantiateViewControllerWithIdentifier:@"SingleMeasurementNavigationControllerID"];
    
    SingleMeasurementViewController* singleMeasurementViewController = singleMeasurementNavigationController.viewControllers[0];

    [singleMeasurementViewController SetMeasurement:gluocoMeResult withTagResult:glucoMeTagResult];
    [singleMeasurementViewController setDelegate:self];
    
    [[self topMostController] presentViewController:singleMeasurementNavigationController animated:NO completion:nil];
    
}

- (void)stop
{
    [glucoMeAudioSDK stop];
    
    if(isRadarOn || isTutorialOn) {
        [[self topMostController] dismissViewControllerAnimated:NO completion:nil];
        isTutorialOn = false;
        isRadarOn = false;
    }
}

-(void)GlucoMeSDKFinishedWith_uid:(int)uid firmewareVersion:(int)firmwareVersion
                            error:(int)error battery:(int)battery glucose:(int)glucose
{
    [glucoMeAudioSDK stop];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self handleRecievedMeasurement:uid firmewareVersion:firmwareVersion error:error battery:battery glucose:glucose];
    });
}

- (void)handleRecievedMeasurement:(int)uid firmewareVersion:(int)firmwareVersion
error:(int)error battery:(int)battery glucose:(int)glucose
{
    NSLog(@"Done123 ! UID %d Glucose: %d, Battery: %d, error %d", uid, glucose, battery, error);
    
    if(error != 0)
    {
        NSLog(@"error in measurement");
        //when error bit is on, the glucose is the error itself (see list below)
        int error_code = glucose;
        
        [[HelpDialogManager getInstance] SetWithError:error_code];
        [[HelpDialogManager getInstance] ShowOnView:[[self topMostController] view]];
        return;
    }
    
    GlucoMeResult *localGlucoMeResult = [[GlucoMeResult alloc] init];
    localGlucoMeResult.value = glucose;
    localGlucoMeResult.firmewareVersion = firmwareVersion;
    localGlucoMeResult.uid = uid;
    if(isRadarOn || isTutorialOn) {
        [[self topMostController] dismissViewControllerAnimated:NO completion:^{
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(glucoMeSDKResult:)]) {
                [self.delegate glucoMeSDKResult:localGlucoMeResult];
            }
            if(battery != 0 )
            {
                [self replaceBatteryAlert];
            }
        }];
        isTutorialOn = false;
        isRadarOn = false;
    }
    else
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(glucoMeSDKResult:)]) {
            [self.delegate glucoMeSDKResult:localGlucoMeResult];
        }
        if(battery != 0 )
        {
            [self replaceBatteryAlert];
        }
    }

    
     //return value to 3rd party
}

- (void)replaceBatteryAlert
{
    NSString* msg = @"Battery level is low. Please replace battery.";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning" message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Replace device battery" style:UIAlertActionStyleCancel handler:nil]];
    
    [[self topMostController] presentViewController:alertController animated:YES completion:nil];
}

-(void)singleMeasurementTagResult:(GlucoMeTagResult*)glucoMeTagResult
{
    NSLog(@"Saved ! Date: %@ Notes: %@ Tags %ld", glucoMeTagResult.date, glucoMeTagResult.comment, (long)glucoMeTagResult.tags);
    GlucoMeTagResult *localGlucoMeTagResult = [[GlucoMeTagResult alloc] init];
    localGlucoMeTagResult.comment = glucoMeTagResult.comment;
    localGlucoMeTagResult.date = glucoMeTagResult.date;
    localGlucoMeTagResult.tags = glucoMeTagResult.tags;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(glucoMeSDKTagResult:)]) {
        [self.delegate glucoMeSDKTagResult:localGlucoMeTagResult];
    }
}

-(NSString*)showSDKVersion {
    NSString* version = [NSString stringWithFormat:@"%s/%@", "SDKVersion: 3.3.5 ", [glucoMeAudioSDK SDKVersion]];
    
    return version;
}

- (UIViewController*) topMostController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    return topController;
}

    
- (NSBundle *)getBundle {
    NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:@"GlucoMe" withExtension:@"bundle"];
    NSBundle* bundle = [NSBundle bundleWithURL:bundleURL];
        
    return bundle;
}
    
@end
