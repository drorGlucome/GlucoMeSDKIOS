//
//  HelpDialogView.m
//  GlucoMe - Mobile
//
//  Created by dovi winberger on 8/24/15.
//  Copyright (c) 2015 Yiftah Ben Aharon. All rights reserved.
//

#import "HelpDialogView.h"

@implementation HelpDialogView


- (IBAction)CloseDialog:(id)sender
{
    [self Close];
}
-(void)Close
{
    [self removeFromSuperview];
}
@end
