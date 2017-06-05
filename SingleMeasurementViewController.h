//
//  LogDetailedViewController.h
//  GlucoMe - Mobile
//
//  Created by Yiftah Ben Aharon on 8/14/14.
//  Copyright (c) 2014 Yiftah Ben Aharon. All rights reserved.
//  Updated by Dror Zohar on 28/05/17.
// this is the a single measurement view, where you can tag and add comment

#import <UIKit/UIKit.h>
#import "TagsView.h"
#import "GlucoMeSDKUI.h"


@class SingleMeasurementViewController;
@protocol SingleMeasurementViewControllerDelegateProtocol <NSObject>

-(void)singleMeasurementTagResult:(GlucoMeTagResult*)glucoMeTagResult;

@end

@interface SingleMeasurementViewController : UIViewController
{
    TagsView* tagsView;
    
    BOOL newMeasurement;
    NSString* source;
    NSString* uuid;
    int type;
    int value;
    int originalValue;
    NSDate* originalDate;
    NSDate* date;
    NSString* comment;
    int tags;
    
}


@property(nonatomic, retain) NSDate *previousTime;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) id<SingleMeasurementViewControllerDelegateProtocol> delegate;

@property (weak, nonatomic) IBOutlet UIView *tagsContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagsContainerHeightConstraint;

@property (weak, nonatomic) IBOutlet UITextView *noteTextView;

@property (weak, nonatomic) IBOutlet UILabel *tagResultTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *notesTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultValueUnitsLabel;

@property (weak, nonatomic) IBOutlet UIImageView *resultBackgroundImageView;


-(void)SetMeasurement:(GlucoMeResult*)glucoMeResult withTagResult:(GlucoMeTagResult*)glucoMeTagResult; //use to update an existing measurement


@end
