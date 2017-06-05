//
//  general.h
//  audioGraph
//
//  Created by Yiftah Ben Aharon on 9/11/12.
//  Updated by Dror Zohar on 28/05/17.
//

#import <UIKit/UIKit.h>

#define GREEN [UIColor colorWithRed:24/255.0 green:182/255.0 blue:61/255.0 alpha:1]
#define BLUE [UIColor colorWithRed:52/255.0 green:127/255.0 blue:174/255.0 alpha:1]
#define RED [UIColor colorWithRed:255/255.0 green:86/255.0 blue:105/255.0 alpha:1]
#define YELLOW [UIColor colorWithRed:246/255.0 green:166/255.0 blue:28/255.0 alpha:1]
#define GRAY [UIColor colorWithRed:113.0/255.0 green:113.0/255.0 blue:113.0/255.0 alpha:1]
#define TRANSPARENT [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0]
#define AZURE [UIColor colorWithRed:204.0/255.0 green:229.0/255.0 blue:238.0/255.0 alpha:1]
#define PURPLE [UIColor colorWithRed:153.0/255.0 green:102.0/255.0 blue:255.0/255.0 alpha:1]
#define BROWN [UIColor colorWithRed:179.0/255.0 green:50.0/255.0 blue:6.0/255.0 alpha:1]
#define LIGHT_GREEN [UIColor colorWithRed:163/255.0 green:211/255.0 blue:123/255.0 alpha:1]
#define WHITE [UIColor whiteColor]

#define loc(key) [[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil]

#define profile_pre_meal_target                 @"profile_pre_meal_target"
#define profile_post_meal_target                @"profile_post_meal_target"
#define profile_hypo_threshold                 @"profile_hypo_threshold"
#define profile_suspected_hypo_threshold       @"profile_suspected_hypo_threshold"
#define profile_sever_hypo_threshold           @"profile_sever_hypo_threshold"
#define default_profile_pre_meal_target             130
#define default_profile_post_meal_target            160
#define default_profile_hypo_threshold             60
#define default_profile_suspected_hypo_threshold   90
#define default_profile_sever_hypo_threshold       40
#define default_profile_lower_limit 70
#define default_profile_upper_limit 130
#define default_profile_strips 50

#define MIN_TOLERANCE  0.8
#define MAX_TOLERANCE  1.2

typedef enum glucose_type {glucose_low, glucose_normal, glucose_high, glucose_very_high} glucose_type;
typedef enum MeasurementType {glucoseMeasurementType, medicineMeasurementType, foodMeasurementType, activityMeasurementType, weightMeasurementType} MeasurementType;

NSInteger binarySearchForFontSizeForLabel(UILabel * label, NSInteger minFontSize, NSInteger maxFontSize);

UIColor* glucoseToColor(int glucose, int tag);





