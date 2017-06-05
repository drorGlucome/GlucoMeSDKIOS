//
//  TagsView.m
//  GlucoMe - Mobile
//
//  Created by dovi winberger on 5/31/15.
//  Copyright (c) 2015 Yiftah Ben Aharon. All rights reserved.
//

#import "TagsView.h"
#import "general.h"
@implementation TagsView
@synthesize delegate;

NSArray *tagNames;
NSArray *tagIcons;

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

-(void)setDelegate:(id<TagsViewDelegateProtocol>)_delegate
{
    delegate = _delegate;
    [self setup];
}
-(void)setup
{
    tagNames = @[@"Before breakfast", @"After breakfast", @"Before lunch", @"After lunch", @"Before dinner", @"After dinner", @"Before snack", @"After snack", @"Bedtime", @"Midnight"];
    tagIcons = @[@"beforeBreakfast", @"afterBreakfast", @"beforeLunch", @"afterLunch", @"beforeDinner", @"afterDinner", @"beforeSnack", @"afterSnack", @"bedtime", @"midnight"];
    activeTags = [[NSMutableSet alloc] init];
   
    for (UILabel* l in self.titleLabel)
    {
        if(l.textAlignment != NSTextAlignmentCenter)
        {
            if(l.tag != 1000)
                [l setTextAlignment:NSTextAlignmentNatural];
        }
        NSString* label = [self.delegate respondsToSelector:@selector(labelForTag:)] ?
            [self.delegate labelForTag:l.tag] : l.text;
        if(label == nil || [label isEqualToString:@""]) label = l.text;
        
        l.text = loc(label);
    }
    
    
}

-(void)FixFontSize
{
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    UILabel* maxLengthLabel = nil;
    float maxStringLength = 0;
    for (UILabel* l in self.titleLabel)
    {
        if (l.text.length > maxStringLength) {
            maxStringLength = l.text.length;
            maxLengthLabel = l;
        }
    }
    
    NSInteger maxFontSize = binarySearchForFontSizeForLabel(maxLengthLabel, 10, 30)-1;

    for (UILabel* l in self.titleLabel)
    {
        [l setFont:[UIFont fontWithName:l.font.fontName size:maxFontSize]];
    }
}


-(void)setFrame:(CGRect)frame
{
    CGFloat oldWidth = self.frame.size.width;
    CGFloat oldHeight = self.frame.size.height;
    
    float ar = oldWidth/oldHeight;
    
    CGFloat newWidth = frame.size.width;
    CGFloat newHeight =  newWidth / ar;
    
    
    int numberOfRows = 5;//glucose
    if(self.backgroundImageView.count == 6)
        numberOfRows = 6;//medicine
    if(self.backgroundImageView.count == 0)
        numberOfRows = 0;//weight
    if(self.showNotTagged)
        numberOfRows = numberOfRows + 1;
    UIView* element = self.backgroundImageView[0];
    if(element)
    {
        CGFloat elementHeight = element.frame.size.height;
        CGFloat newElementHeight = elementHeight * newHeight / oldHeight ;
        CGFloat totalHeight = newElementHeight*numberOfRows;
        
        [super setFrame:CGRectMake(frame.origin.x, frame.origin.y,
                                   frame.size.width, totalHeight)];
    }
    else
    {
        if(numberOfRows == 0)
            [super setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 2)];
        else
            [super setFrame:frame];
    }
    [self FixFontSize];
}

-(void)setShowNotTagged:(BOOL)showNotTagged
{
    _showNotTagged = showNotTagged;
    self.notTaggesSection.hidden = !showNotTagged;
}

- (IBAction)TagClicked:(UIButton*)sender
{
    if(self.singleSelection == YES)
    {
        BOOL shouldActivate = NO;
        if(![activeTags containsObject:[NSString stringWithFormat:@"%ld",(long)sender.tag]])
            shouldActivate = YES;

        [self DeactivateAllTags];
        
        if(shouldActivate)
            [self SetTagOn:sender.tag];
    }
    else
    {
        if([activeTags containsObject:[NSString stringWithFormat:@"%ld",(long)sender.tag]])
            [self SetTagOff:sender.tag];
        else
            [self SetTagOn:sender.tag];
    }
    
    [self.delegate tagSelectionChanged:self];
}

-(void)SetTagOn:(NSInteger)tagID
{
    UIImageView* iconImageView;
    UIImageView* backgroundImageView;
    UILabel* titleLabel;
    
    for (int i = 0; i < self.backgroundImageView.count; i++)
    {
        UIImageView *v = self.backgroundImageView[i];
        if ([v tag] == tagID)
        {
            backgroundImageView = v;
            break;
        }
    }
    for (int i = 0; i < self.iconImageView.count; i++)
    {
        UIImageView *v = self.iconImageView[i];
        if ([v tag] == tagID)
        {
            iconImageView = v;
            break;
        }
    }
    for (int i = 0; i < self.titleLabel.count; i++)
    {
        UILabel *v = self.titleLabel[i];
        if ([v tag] == tagID)
        {
            titleLabel = v;
            break;
        }
    }
    
    NSString* icon = @"";
    if([self.delegate respondsToSelector:@selector(iconForTag:)])
    {
        icon = [self.delegate iconForTag:tagID];
    }
    else
    {
        icon = tagIcons[tagID];
    }
    
    backgroundImageView.image = [UIImage imageNamed:@"tagButtonBackgroundActive.png" inBundle:[self getBundle] compatibleWithTraitCollection:nil];
    iconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@.png",icon, @"Active"] inBundle:[self getBundle] compatibleWithTraitCollection:nil];
    titleLabel.textColor = [UIColor whiteColor];
    
    [activeTags addObject:[NSString stringWithFormat:@"%ld",(long)tagID]];
}
-(void)SetTagOff:(NSInteger)tagID
{
    UIImageView* iconImageView;
    UIImageView* backgroundImageView;
    UILabel* titleLabel;
    
    for (int i = 0; i < self.backgroundImageView.count; i++)
    {
        UIImageView *v = self.backgroundImageView[i];
        if ([v tag] == tagID)
        {
            backgroundImageView = v;
            break;
        }
    }
    for (int i = 0; i < self.iconImageView.count; i++)
    {
        UIImageView *v = self.iconImageView[i];
        if ([v tag] == tagID)
        {
            iconImageView = v;
            break;
        }
    }
    for (int i = 0; i < self.titleLabel.count; i++)
    {
        UILabel *v = self.titleLabel[i];
        if ([v tag] == tagID)
        {
            titleLabel = v;
            break;
        }
    }
    
    NSString* icon = @"";
    if([self.delegate respondsToSelector:@selector(iconForTag:)])
    {
        icon = [self.delegate iconForTag:tagID];
    }
    else
    {

        icon = tagIcons[tagID];
    }
    backgroundImageView.image = [UIImage imageNamed:@"tagButtonBackgroundNormal.png" inBundle:[self getBundle] compatibleWithTraitCollection:nil];
    iconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@.png",icon, @""] inBundle:[self getBundle] compatibleWithTraitCollection:nil];
    titleLabel.textColor = [UIColor darkGrayColor];
    
    [activeTags removeObject:[NSString stringWithFormat:@"%ld",(long)tagID]];
}

- (NSBundle *)getBundle {
    NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:@"GlucoMe" withExtension:@"bundle"];
    NSBundle* bundle = [NSBundle bundleWithURL:bundleURL];
    
    return bundle;
}

-(void)ActivateAllTags
{
    for (UIView* v in self.backgroundImageView)
    {
        [self SetTagOn:v.tag];
    }
    [self.delegate tagSelectionChanged:self];
}
-(void)DeactivateAllTags
{
    for (UIView* v in self.backgroundImageView)
    {
        [self SetTagOff:v.tag];
    }
    [self.delegate tagSelectionChanged:self];
}

-(void)SetActiveTags:(NSArray*)tags //array of NSNumber
{
    //assuming tags are string integers
   for (NSNumber* tag in tags)
    {
        
        [self SetTagOn:[tag integerValue]];
    }
    
}

-(NSArray*)GetSelectedTags
{
    return [activeTags allObjects];
}

-(BOOL)IsAllTagsSelected
{
    return [activeTags allObjects].count == self.backgroundImageView.count;
}
-(BOOL)IsNoneSelected
{
    return [activeTags allObjects].count == 0;
}
@end
