//
//  LogDetailedViewController.m
//  GlucoMe - Mobile
//
//  Created by Yiftah Ben Aharon on 8/14/14.
//  Copyright (c) 2014 Yiftah Ben Aharon. All rights reserved.
//


#import "SingleMeasurementViewController.h"
#import "general.h"

#define ARE_YOU_SURE_TAG 502

@interface SingleMeasurementViewController () <TagsViewDelegateProtocol>
@property (nonatomic) float resultValueLabelFontSize;
@end


@implementation SingleMeasurementViewController
@synthesize delegate;


- (NSTimeInterval)timeDifferenceSinceLastOpen {
    
    if (!self.previousTime) self.previousTime = [NSDate date];
    NSDate *currentTime = [NSDate date];
    NSTimeInterval timeDifference =  [currentTime timeIntervalSinceDate:self.previousTime];
    self.previousTime = currentTime;
    return timeDifference;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if ([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft) {
        [self.saveButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    }
    
    self.notesTitleLabel.text = [NSString stringWithFormat:@" %@",loc(@"Notes")];
    [self.notesTitleLabel setTextAlignment:NSTextAlignmentNatural];
    
    self.tagResultTitleLabel.text = [NSString stringWithFormat:@" %@",loc(@"Tag your result")];
    [self.tagResultTitleLabel setTextAlignment:NSTextAlignmentNatural];
    
    
    self.noteTextView.text = loc(@"add some notes...");
    [self.noteTextView setTextAlignment:NSTextAlignmentNatural];
    
    self.resultValueLabelFontSize = self.resultValueLabel.font.pointSize;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self UpdateUI];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self SetTagsUI];
    
}


-(void)UpdateUI
{
    
    //title
    switch (type) {
        case glucoseMeasurementType:
            self.navigationItem.title = loc(@"Glucose");
            
            if(newMeasurement && tagsView.GetSelectedTags.count > 0)
            {
            }
            
            break;
        default:
            break;
    }
    
    
    //notes
    if(comment != nil && ![comment isEqualToString:@""])
    {
        //tempComment = comment;
        self.noteTextView.text = comment;
        [self.noteTextView setTextAlignment:NSTextAlignmentNatural];
    }

    
    //value
    self.resultValueLabel.text = @"";
    self.resultValueUnitsLabel.text = @"";
    
    UIColor* color = GREEN;
    
    switch (type) {
        case glucoseMeasurementType:
            self.resultValueUnitsLabel.text = @"mg/dl";
            
            if(value > -1)
            {
                self.resultValueLabel.text = [NSString stringWithFormat:@"%d", value];
                NSArray* tagsArray = [tagsView GetSelectedTags];
                if(tagsArray.count == 0)
                    color = glucoseToColor(value, -1);
                else{
                    color = glucoseToColor(value, [tagsArray[0] intValue]);
                }
            }
            else
            {
                self.resultValueLabel.text = loc(@"--");
            }
            break;
        default:
            break;
    }
    
    if([color isEqual:GRAY])
        self.resultBackgroundImageView.image = [UIImage imageNamed:@"glucoseBackgroundGray" inBundle:[self getBundle] compatibleWithTraitCollection:nil];
    if([color isEqual:GREEN])
        self.resultBackgroundImageView.image = [UIImage imageNamed:@"glucoseBackgroundGreen" inBundle:[self getBundle] compatibleWithTraitCollection:nil];
    if([color isEqual:RED])
        self.resultBackgroundImageView.image = [UIImage imageNamed:@"glucoseBackgroundRed" inBundle:[self getBundle] compatibleWithTraitCollection:nil];
    if([color isEqual:YELLOW])
        self.resultBackgroundImageView.image = [UIImage imageNamed:@"glucoseBackgroundOrange" inBundle:[self getBundle] compatibleWithTraitCollection:nil];
    if([color isEqual:BLUE])
        self.resultBackgroundImageView.image = [UIImage imageNamed:@"glucoseBackgroundBlue" inBundle:[self getBundle] compatibleWithTraitCollection:nil];
    
    
    //date
    if (date == nil)
    {
        date = [[NSDate alloc] init];;
    }
    
    NSDateFormatter* timeFormatter = [[NSDateFormatter alloc] init];
    timeFormatter.timeStyle = NSDateFormatterShortStyle;
    self.resultTimeLabel.text = [timeFormatter stringFromDate:date];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    self.resultDateLabel.text = [dateFormatter stringFromDate:date];
    
    
    NSInteger maxFontSize = binarySearchForFontSizeForLabel(self.resultDateLabel, 10, 22)-1;
    [self.resultDateLabel setFont:[UIFont fontWithName:self.resultDateLabel.font.fontName size:maxFontSize]];
    [self.resultTimeLabel setFont:[UIFont fontWithName:self.resultTimeLabel.font.fontName size:maxFontSize]];
}

-(void)SetMeasurement:(GlucoMeResult*)glucoMeResult withTagResult:(GlucoMeTagResult*)glucoMeTagResult
{
    newMeasurement = NO;
    
    value = (int)glucoMeResult.value;
    date = [glucoMeTagResult.date copy];
    comment = [glucoMeTagResult.comment copy];
    tags = (int)glucoMeTagResult.tags;

    
    [self UpdateUI];
    [self SetTagsUI];
}

-(void)SetTagsUI
{
    //tags
    if (tagsView) {
        [tagsView removeFromSuperview];
    }
    
    NSString* tagsViewName = @"";
    switch (type) {
        case glucoseMeasurementType:
            tagsViewName = @"TagsView";
            break;
        default:
            break;
    }
    if([tagsViewName isEqualToString:@""]) return;
    
    tagsView = (TagsView*)[[[self getBundle] loadNibNamed:tagsViewName owner:nil options:nil ] objectAtIndex:0];
    tagsView.delegate = self;
    tagsView.singleSelection = YES;
    tagsView.showNotTagged = NO;
    [tagsView setFrame:[UIScreen mainScreen].bounds];
    [self.tagsContainer addSubview:tagsView];
    
    [self.view layoutIfNeeded];
    [self.tagsContainer layoutIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        self.tagsContainerHeightConstraint.constant = tagsView.frame.size.height;
        [self.view layoutIfNeeded];
        [self.tagsContainer layoutIfNeeded];
    }];
    
    [tagsView SetActiveTags:@[@(tags)]];
}

- (IBAction)Close:(id)sender
{
    if(value > 0)
    {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:loc(@"Cancel")
                                      message:loc(@"Are you sure?")
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"Go back"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 [self closeAfterInputCheck];
                                 
                             }];
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"Stay here"
                                 style:UIAlertActionStyleCancel
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        
        [alert addAction:ok];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        [self closeAfterInputCheck];
    }
    

}
-(void)closeAfterInputCheck
{
    if(self == self.navigationController.viewControllers[0])
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)Save:(id)sender
{

    [self SaveWithCompletionBlock:^{
        [self closeAfterInputCheck];
    }];
    
}

-(void)SaveWithCompletionBlock:(void(^)(void))completionBlock
{
    
    if (value < 0) {
        return;
    }
    
    if(type == glucoseMeasurementType && (value < 30 || value > 500) )
    {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:loc(@"Info")
                                      message:loc(@"This value seems unusual. Are you sure it is correct ?")
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"Correct"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 [self SaveAfterInputCheckWithCompletionBlock:completionBlock];
                                 
                             }];
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"Cancel"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        
        [alert addAction:ok];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    [self SaveAfterInputCheckWithCompletionBlock:completionBlock];
}

-(void)SaveAfterInputCheckWithCompletionBlock:(void(^)(void))completionBlock
{
    GlucoMeTagResult *localGlucoMeTagResult = [[GlucoMeTagResult alloc] init];
    localGlucoMeTagResult.comment = comment;
    NSArray* tagsArray = [tagsView GetSelectedTags];
    if(tagsArray.count > 0)
        tags = [tagsArray[0] intValue];
    
    localGlucoMeTagResult.tags = tags;
    localGlucoMeTagResult.date = date;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(singleMeasurementTagResult:)]) {
        [self.delegate singleMeasurementTagResult:localGlucoMeTagResult];
    }
    if(completionBlock) completionBlock();
}

-(IBAction)AddNote:(id)sender
{
    NSString* prompt = loc(@"Enter note");
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Add note" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                {
                                    UITextField *notes = alertController.textFields.firstObject;
                                    NSString *s = [notes text];
                                    if([s isEqualToString:@""])
                                    {
                                        self.noteTextView.text = loc(@"add some notes...");
                                    }
                                    else
                                    {
                                        self.noteTextView.text = s;
                                    }
                                    comment = s;
                                    
                                }]];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = NSLocalizedString(@"NotesTextField", @"Login");
     }];
    [[self topMostController] presentViewController:alertController animated:YES completion:nil];
}

/**
 tagsview delegate methods*/
-(void)tagSelectionChanged:(TagsView*)tagsView
{
    [self UpdateUI];
}

- (NSBundle *)getBundle {
    NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:@"GlucoMe" withExtension:@"bundle"];
    NSBundle* bundle = [NSBundle bundleWithURL:bundleURL];
    
    return bundle;
}

- (UIViewController*) topMostController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    return topController;
}

@end
