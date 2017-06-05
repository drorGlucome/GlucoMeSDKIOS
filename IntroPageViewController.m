//
//  IntroPageViewController.m
//  GlucoMe - Mobile
//
//  Created by dovi winberger on 5/7/15.
//  Copyright (c) 2015 Yiftah Ben Aharon. All rights reserved.
//

#import "IntroPageViewController.h"
#import "IntroGenericViewController.h"
#import "UIImage+animatedGIF.h"

@interface IntroPageViewController () <IntroGenericViewControllerDelegateProtocol, UIPageViewControllerDelegate,UIPageViewControllerDataSource>

@end

@implementation IntroPageViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.delegate = self;
    self.dataSource = self;

    myViewControllers = [[NSMutableArray alloc] init];
    
    IntroGenericViewController* welcome = (IntroGenericViewController*)[[UIStoryboard storyboardWithName:@"IntroStoryboard" bundle:[self getBundle]] instantiateViewControllerWithIdentifier:@"IntroGenericViewControllerID"];
    welcome.view.backgroundColor = [UIColor whiteColor];
    welcome.pageIndex = WelcomePage;
    welcome.mainLabel.text = @"Welcome to GlucoMe";
    welcome.secondLabel.text = @"We will guide you";
    welcome.secondLabelSecondLine.text = @"how to use the device";
    welcome.delegate = self;
    welcome.doneButton = self.doneButton;
    welcome.prevButton = self.prevButton;
    welcome.nextButton = self.nextButton;
    welcome.moreHelpButton.hidden = YES;
    
    IntroGenericViewController* lancet = (IntroGenericViewController*)[[UIStoryboard storyboardWithName:@"IntroStoryboard" bundle:[self getBundle]] instantiateViewControllerWithIdentifier:@"IntroGenericViewControllerID"];
    lancet.view.backgroundColor = [UIColor whiteColor];
    lancet.pageIndex = LancetPage;
    lancet.mainLabel.text = @"Lancing device";
    lancet.secondLabel.text = @"Assemble the lancing device";
    lancet.secondLabelSecondLine.text = @"and press Next";
    lancet.delegate = self;
    lancet.mainImage.animationImages = [self ImageForPage:lancet.pageIndex];
    lancet.doneButton = self.doneButton;
    lancet.prevButton = self.prevButton;
    lancet.nextButton = self.nextButton;
    
    
    IntroGenericViewController* takeCapOff = (IntroGenericViewController*)[[UIStoryboard storyboardWithName:@"IntroStoryboard" bundle:[self getBundle]] instantiateViewControllerWithIdentifier:@"IntroGenericViewControllerID"];
    takeCapOff.view.backgroundColor = [UIColor whiteColor];
    takeCapOff.pageIndex = TakeCapOffPage;
    takeCapOff.mainLabel.text = @"Take the cap off";
    takeCapOff.secondLabel.text = @"Remove the cap";
    takeCapOff.secondLabelSecondLine.text = @"and press Next";
    takeCapOff.delegate = self;
    takeCapOff.mainImage.animationImages = [self ImageForPage:takeCapOff.pageIndex];
    takeCapOff.doneButton = self.doneButton;
    takeCapOff.prevButton = self.prevButton;
    takeCapOff.nextButton = self.nextButton;
    takeCapOff.moreHelpButton.hidden = YES;
    
    IntroGenericViewController* testStrip = (IntroGenericViewController*)[[UIStoryboard storyboardWithName:@"IntroStoryboard" bundle:[self getBundle]] instantiateViewControllerWithIdentifier:@"IntroGenericViewControllerID"];
    testStrip.view.backgroundColor = [UIColor whiteColor];
    testStrip.pageIndex = InsertStripPage;
    testStrip.mainLabel.text = @"Insert a test strip";
    testStrip.secondLabel.text = @"Make sure the green light is on,";
    testStrip.secondLabelSecondLine.text = @"and press Next";
    testStrip.delegate = self;
    testStrip.mainImage.animationImages = [self ImageForPage:testStrip.pageIndex];
    //testStrip.secondImage.image = [UIImage imageNamed:@"insertstrip_zoom.png"];
    testStrip.doneButton = self.doneButton;
    testStrip.prevButton = self.prevButton;
    testStrip.nextButton = self.nextButton;
    
    IntroGenericViewController* prickFinger = (IntroGenericViewController*)[[UIStoryboard storyboardWithName:@"IntroStoryboard" bundle:[self getBundle]] instantiateViewControllerWithIdentifier:@"IntroGenericViewControllerID"];
    prickFinger.view.backgroundColor = [UIColor whiteColor];
    prickFinger.pageIndex = PrickFingerPage;
    prickFinger.mainLabel.text = @"Prick your finger";
    prickFinger.secondLabel.text = @"Make sure you have a sufficient";
    prickFinger.secondLabelSecondLine.text = @"blood drop ready and press Next";
    prickFinger.delegate = self;
    prickFinger.mainImage.animationImages = [self ImageForPage:prickFinger.pageIndex];
    prickFinger.doneButton = self.doneButton;
    prickFinger.prevButton = self.prevButton;
    prickFinger.nextButton = self.nextButton;
    
    IntroGenericViewController* placeBlood = (IntroGenericViewController*)[[UIStoryboard storyboardWithName:@"IntroStoryboard" bundle:[self getBundle]] instantiateViewControllerWithIdentifier:@"IntroGenericViewControllerID"];
    placeBlood.view.backgroundColor = [UIColor whiteColor];
    placeBlood.pageIndex = PlaceBloodPage;
    placeBlood.mainLabel.text = @"Place a blood drop";
    placeBlood.secondLabel.text = @"Apply the edge of the strip to the blood";
    placeBlood.secondLabelSecondLine.text = @"drop and wait for the green light to blink";
    placeBlood.delegate = self;
    placeBlood.mainImage.animationImages = [self ImageForPage:placeBlood.pageIndex];
    //placeBlood.secondImage.image = [UIImage imageNamed:@"place_zoom.png"];
    placeBlood.doneButton = self.doneButton;
    placeBlood.prevButton = self.prevButton;
    placeBlood.nextButton = self.nextButton;
    
    [myViewControllers addObjectsFromArray:@[welcome, lancet, takeCapOff, testStrip, prickFinger, placeBlood]];
    
    
    [self setViewControllers:@[welcome] direction:UIPageViewControllerNavigationDirectionForward animated:false completion:nil];
    
    [UIPageControl appearance].pageIndicatorTintColor = [UIColor lightGrayColor];
    [UIPageControl appearance].currentPageIndicatorTintColor = [UIColor darkGrayColor];
}


-(void)GoToPageAfter:(UIViewController *)me
{
    UIViewController* vc = [self pageViewController:self viewControllerAfterViewController:me];
    if(vc != nil)
        [self setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionForward animated:true completion:nil];
    else
        [self.containerVC onDone:nil];
    
}
-(void)GoToPageBefore:(UIViewController *)me
{
    UIViewController* vc = [self pageViewController:self viewControllerBeforeViewController:me];
    if(vc != nil)
        [self setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionReverse animated:true completion:nil];
    
}

-(int)AnimationDurationForPage:(int)pageIndex
{
    switch (pageIndex) {
        case LancetPage:
            return 20;
            break;
        case TakeCapOffPage:
            return 2;
            break;
        case InsertStripPage:
            return 4;
            break;
        case PrickFingerPage:
            return 8;
            break;
        case PlaceBloodPage:
            return 4;
            break;
        default:
            break;
    }

    return 0;
}

-(NSArray*)ImageForPage:(int)pageIndex
{
    if (pageIndex > 0)
    {
        int count = 0;
        NSString* seq = @"";
        NSString* extension = @""; //not needed for png
        switch (pageIndex) {
            case LancetPage:
                count = 10;
                seq = @"Prepare";
                break;
            case TakeCapOffPage:
                count = 6;
                seq = @"capoff";
                break;
            case InsertStripPage:
                count = 8;
                seq = @"insert_strip";
                break;
            case PrickFingerPage:
                count = 9;
                seq = @"prick_cock";
                break;
            case PlaceBloodPage:
                count = 9;
                seq = @"place";
                extension = @".jpg";
                break;
            default:
                break;
        }
        
        
        
        NSMutableArray* images = [[NSMutableArray alloc] init];
        for (int i = 0; i < count; i++)
        {
            NSString* num = [NSString stringWithFormat:@"%d", i];
            if(num.length == 1)
                num = [NSString stringWithFormat:@"000%@", num];
            else if(num.length == 2)
                num = [NSString stringWithFormat:@"00%@", num];
            else if(num.length == 3)
                num = [NSString stringWithFormat:@"0%@", num];
            
            UIImage* im = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@%@",seq,num,extension] inBundle:[self getBundle] compatibleWithTraitCollection:nil];
            [images addObject:im];
        }
        return images;
    }
    return nil;

    
    /*NSURL *url;
    NSArray* image = nil;
    switch (pageIndex) {
        case 0:
            url  = [[NSBundle mainBundle] URLForResource:@"welcome" withExtension:@"gif"];
            image = [UIImage animatedImageWithAnimatedGIFURL:url];
            break;
        case 1:
            url = [[NSBundle mainBundle] URLForResource:@"place_10fps" withExtension:@"gif"];
            image = [UIImage animatedImageWithAnimatedGIFURL:url];
            break;
        case 2:
            url = [[NSBundle mainBundle] URLForResource:@"place_10fps" withExtension:@"gif"];
            image = [UIImage animatedImageWithAnimatedGIFURL:url];
            break;
        case 3:
            url = [[NSBundle mainBundle] URLForResource:@"place_10fps" withExtension:@"gif"];
            image = [UIImage animatedImageWithAnimatedGIFURL:url];
            break;
        case 4:
            url = [[NSBundle mainBundle] URLForResource:@"place_10fps" withExtension:@"gif"];
            image = [UIImage animatedImageWithAnimatedGIFURL:url];
            break;
        default:
            break;
    }
    return image;*/
}



-(UIViewController*)viewControllerAtIndex:(NSInteger)index
{
    return myViewControllers[index];
}

-(UIViewController*)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    int currentIndex = (int)[myViewControllers indexOfObject:viewController];
    
    --currentIndex;
    if(currentIndex > myViewControllers.count-1) {return nil;}
    if(currentIndex < 0) {return nil;}
    return myViewControllers[currentIndex];
}


-(UIViewController*)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    int currentIndex  = (int)[myViewControllers indexOfObject:viewController];
    
    ++currentIndex;
    //currentIndex = currentIndex % (myViewControllers.count);
    if(currentIndex > myViewControllers.count-1)
    {
        //dismissViewControllerAnimated(true, completion: nil);
        //return UIViewController();
        return nil;
    }
    if(currentIndex < 0) {return nil;}
    return myViewControllers[currentIndex];
}

-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return myViewControllers.count;
}

-(NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return [myViewControllers indexOfObject:self.viewControllers[0]];
}

- (NSBundle *)getBundle {
    NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:@"GlucoMe" withExtension:@"bundle"];
    NSBundle* bundle = [NSBundle bundleWithURL:bundleURL];
    
    return bundle;
}

@end
