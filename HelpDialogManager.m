//
//  HelpDialogManager.m
//  GlucoMe - Mobile
//
//  Created by dovi winberger on 8/24/15.
//  Copyright (c) 2015 Yiftah Ben Aharon. All rights reserved.
//

#import "HelpDialogManager.h"



@implementation HelpDialogManager

+(HelpDialogManager*)getInstance
{
    static HelpDialogManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[HelpDialogManager alloc] init];
        // Do any other initialisation stuff here
        
        NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:@"GlucoMe" withExtension:@"bundle"];
        NSBundle* bundle = [NSBundle bundleWithURL:bundleURL];
        sharedInstance->dialogView = [[bundle loadNibNamed:@"HelpDialogView" owner:self options:nil] objectAtIndex:0];

    });
    return sharedInstance;
}

-(void)ShowOnView:(UIView*)view
{
    [dialogView Close];
    dialogView.frame = view.window.frame;
    [view.window addSubview:dialogView];
}

-(void)Close
{
    [dialogView Close];
}

-(void)SetWithTitle:(NSString*)title andMessage:(NSString*)message
{
    dialogView.titleLabel.text = title;
    dialogView.mainLabel.text = message;
    dialogView.imageView.image = nil;
}

-(void)SetWithError:(int)error_code
{
    NSString* msg = [self getErrorMessage:error_code];
    if(msg == nil) msg = @"";
    
    NSString* title = @"Error";
    dialogView.titleLabel.text = title;
    
    UIFont *titleFont = [UIFont boldSystemFontOfSize:16];
    NSDictionary *boldAttributes = [NSDictionary dictionaryWithObject: titleFont forKey:NSFontAttributeName];
    
    UIFont *messageFont = [UIFont systemFontOfSize:14];
    NSDictionary *messageAttributes = [NSDictionary dictionaryWithObject:messageFont forKey:NSFontAttributeName];
    
    NSDictionary *boldRedAttributes = @{NSFontAttributeName : titleFont, NSForegroundColorAttributeName : [UIColor redColor]};
    
    
    NSMutableAttributedString *attrMessage = [[NSMutableAttributedString alloc] initWithString:msg attributes: boldAttributes];
    dialogView.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"error%d",error_code] inBundle:[self getBundle] compatibleWithTraitCollection:nil];
    
    

    switch (error_code) {
        case ERR_TEMPERATURE:		//1 out of range 10~40 degrees
        {
            NSString* text = @"\n\nMake sure the device is within the appropriate temperature range (see manual).";
            [attrMessage appendAttributedString:[[NSMutableAttributedString alloc] initWithString:text attributes:messageAttributes]];
            break;
        }
        case ERR_INVALID_STRIP:		//2 reused strip
        {
            NSString* text = @"\n\nDo not use the same test strip. Please use a new one.";
            [attrMessage appendAttributedString:[[NSMutableAttributedString alloc] initWithString:text attributes:boldRedAttributes]];
            break;
        }
        case ERR_REMOVE_STRIP:		//3 removed strip during measurement
        {
            NSString* text = @"\n\nDont remove the strip before the glucose has been measured.";
            [attrMessage appendAttributedString:[[NSMutableAttributedString alloc] initWithString:text attributes:messageAttributes]];
            
            text = @"\n\nPlease measure again using a new test strip. Do not use the same test strip.";
            [attrMessage appendAttributedString:[[NSMutableAttributedString alloc] initWithString:text attributes:boldRedAttributes]];
            break;
        }
        case ERR_MEASUREMENT:		//4 out of range DC 310mV +/- 6mV?
        {
            NSString* text = @"\n\nPlease measure again using a new test strip. Do not use the same test strip.";
            [attrMessage appendAttributedString:[[NSMutableAttributedString alloc] initWithString:text attributes:boldRedAttributes]];
            
            break;
        }
        case ERR_SYSTEM:			//5 abnormal temperature & battery voltage
        {
            NSString* text = @"\n\nPlease measure again using a new test strip. Do not use the same test strip.";
            [attrMessage appendAttributedString:[[NSMutableAttributedString alloc] initWithString:text attributes:boldRedAttributes]];
            
            text = @"\n\nIf the error reoccurs, please replace the battery of the device.";
            [attrMessage appendAttributedString:[[NSMutableAttributedString alloc] initWithString:text attributes:messageAttributes]];
            
            break;
        }
        case ERR_LOWEST:			//6 glucose is under 3 3mg/dL
        {
            NSString* text = @"\n\nPlease measure again using a new test strip. Do not use the same test strip.";
            [attrMessage appendAttributedString:[[NSMutableAttributedString alloc] initWithString:text attributes:boldRedAttributes]];
            
            text = @"\n\nIf the error reoccurs, please replace the battery of the device.";
            [attrMessage appendAttributedString:[[NSMutableAttributedString alloc] initWithString:text attributes:messageAttributes]];
            
            break;
        }
        case ERR_STRIIP_ERROR:    //7       Check strip error            damaged check strip
        {
            NSString* text = @"\n\nPlease measure again using a new test strip. Do not use the same test strip.";
            [attrMessage appendAttributedString:[[NSMutableAttributedString alloc] initWithString:text attributes:boldRedAttributes]];

            break;
        }
        case ERR_INSUFFICIENT_BLOOD:		//8 blood check once, but not detect blood
        {
            NSString* text = @"\n\nPlease measure again using a new test strip. Do not use the same test strip.";
            [attrMessage appendAttributedString:[[NSMutableAttributedString alloc] initWithString:text attributes:boldRedAttributes]];
            
            text = [NSString stringWithFormat:@" \
                                          \n\nGently squeeze your fingertip until a round drop of blood forms on your fingertip. \
                                          \n\nApply the blood drop to the edge of the strip and wait for the green light to blink. \
                                             "]; // \n\nDo not smear the blood on the test strip. \
            
            [attrMessage appendAttributedString:[[NSMutableAttributedString alloc] initWithString:text attributes:messageAttributes]];
            break;
        }
        case ERR_WRONG_BLOOD_DIRECTION:	//9 blood direction error
        {
            NSString* text = @"\n\nPlease measure again using a new test strip. Do not use the same test strip.";
            [attrMessage appendAttributedString:[[NSMutableAttributedString alloc] initWithString:text attributes:boldRedAttributes]];
            
            text = @"\n\nMake sure to apply blood on the edge of the half circle.";
            [attrMessage appendAttributedString:[[NSMutableAttributedString alloc] initWithString:text attributes:messageAttributes]];

            break;
        }
        case ERR_BLOOD_INSERTION_TIMEOUT:	//10   time out 60sec of input blood
        {
            NSString* text = @"\n\nPlease measure again using a new test strip. Do not use the same test strip.";
            [attrMessage appendAttributedString:[[NSMutableAttributedString alloc] initWithString:text attributes:boldRedAttributes]];
            
            break;
        }
        case ERR_BATTERY:             //11     Battery error
        {
            
            NSString* text = @"\n\nBattery is about to drain. please replace the battery \
            \n\n1. Remove the battery cover. \
            \n\n2. Replace the battery. \
            \n\n3. Close the battery cover.";
            [attrMessage appendAttributedString:[[NSMutableAttributedString alloc] initWithString:text attributes:messageAttributes]];
         
            break;
        }
            
        default:
            break;
    }
    
    dialogView.mainLabel.attributedText = attrMessage;
    
    
}

-(void)SetWithLancetTutorial
{
    dialogView.titleLabel.text = @"Assemble the lancing device";
    dialogView.mainLabel.text =     @"1. Remove the cap by rotating the cap counter-clockwise. \
    \n\n2.a. Insert the lancet to the lancing holder. \
    \n\n2.b. Remove the round blue tip to expose the needle. \
    \n\n3. Replace the cap by rotating it clockwise.";
    
    dialogView.imageView.image = [UIImage imageNamed:@"lancet_help.jpg" inBundle:[self getBundle] compatibleWithTraitCollection:nil];
    
}
-(void)SetWithInsertTestStripTutorial
{
    dialogView.titleLabel.text = @"Insert a test strip";
    dialogView.mainLabel.text =     @"1. Note the strip's golden plates and the device's black arrow are on the same side. \
                                    \n\n2. Push until you hear a beep. \
                                    \n\n3. Make sure the green light is on.";
    
    dialogView.imageView.image = [UIImage imageNamed:@"insert_strip_help.jpg" inBundle:[self getBundle] compatibleWithTraitCollection:nil];

}

-(void)SetWithPrickFingerTutorial
{
    dialogView.titleLabel.text = @"Prick your finger";
    dialogView.mainLabel.text =     @"1. Adjust the lancing device to between one to five. \
                                    \n\n2. Cock the device by pulling the bottom part. \
                                    \n\n3. Place it carefully on the tip of your finger. \
                                    \n\n4. Press the trigger button. \
                                    \n\n5. Squeeze your finger for three seconds. \
                                    \n\n6. Make sure you have a sufficient blood drop ready as shown in the picture.";

    dialogView.imageView.image = [UIImage imageNamed:@"prick_help.jpg" inBundle:[self getBundle] compatibleWithTraitCollection:nil];
}

-(void)SetWIthPlaceBloodTutorial
{
    dialogView.titleLabel.text = @"Place a blood drop";
    dialogView.mainLabel.text =     @"1. Do not smear the blood on the golden strip. Place it close to the edge of the strip and let the blood flow in. \
                                    \n\n2. Make sure that the blood flows and fills the entire strip." ;
    
    dialogView.imageView.image = [UIImage imageNamed:@"place_blood_help.jpg" inBundle:[self getBundle] compatibleWithTraitCollection:nil];
}





- (NSString*)getErrorMessage:(int)errorId {
    
    /*
     10     Insertion timeout            blood insertion time is over 60sec
     11     Battery error                  battery level is out of voltage 2.6V ~ 3.45V
     */
    
    
    
    
    
    NSMutableArray* messages = [[NSMutableArray alloc] initWithObjects:
                                @"General Error", //      0  ERR_NONE,
                                @"The meter is too hot or cold.", // 1 ERR_TEMPERATURE
                                @"Used test strip was inserted into the test port.", // 2 ERR_INVALID_STRIP
                                @"Test strip is damaged or was removed too soon.", // 3 ERR_REMOVE_STRIP
                                @"The sample was improperly applied or there was electronic interference during the test.", //4 ERR_MEASUREMENT
                                @"Internal error – cannot read test strip.", // 5 ERR_SYSTEM
                                @"Internal error – cannot read test strip.", // 6 ERR_LOWEST
                                @"Strip is damaged", // 7 ERR_STRIIP_ERROR
                                @"Blood drop was not big enough or blood smears on the strip.", // 8 ERR_INSUFFICIENT_BLOOD
                                @"Blood was applied to the wrong part of the test strip.", // 9 ERR_WRONG_BLOOD_DIRECTION
                                @"Blood was not applied on the test strip.", // 10 ERR_BLOOD_INSERTION_TIMEOUT
                                @"Battery is damaged", //11 ERR_BATTERY
                                nil];
    
    if(errorId < messages.count) {
        return (NSString*)[messages objectAtIndex:errorId];
    }
    return nil;
}

- (NSBundle *)getBundle {
    NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:@"GlucoMe" withExtension:@"bundle"];
    NSBundle* bundle = [NSBundle bundleWithURL:bundleURL];
    
    return bundle;
}

@end
