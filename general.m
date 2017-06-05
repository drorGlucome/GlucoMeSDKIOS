#include <stdio.h>
#include "general.h"

glucose_type glucoseToType(int glucose, int tag)//always mg/dl   //0-low, 1-normal, 2-high, 3-very high
{
    int value = glucose;
    int upperLimit = 120;
    int lowerLimit = 70;
    
    NSString* target_key = @"";
    if(tag < 0 || tag % 2 == 0) //before x
        target_key = profile_pre_meal_target;
    else
        target_key = profile_post_meal_target;
    
    NSString* upperStr = [[NSUserDefaults standardUserDefaults] objectForKey:target_key];
    if(upperStr != nil) {
        upperLimit = [upperStr intValue];
    }
    NSString* lowerStr = [[NSUserDefaults standardUserDefaults] objectForKey:profile_hypo_threshold];
    if(lowerStr != nil) {
        lowerLimit = [lowerStr intValue];
    }
    
    if(value == 0) {
        return 2;
    }
    int ranges[5] = {0,lowerLimit,upperLimit, upperLimit*MAX_TOLERANCE, 10000};
    for(int i = 0; i < 4; i++) {
        if(value >= ranges[i] && value < ranges[i+1]) {
            return i;
        }
    }
    return 2;
    
}

UIColor* glucoseToColor(int glucose, int tag) //always mg/dl
{
    UIColor* colors[4] = {BLUE, GREEN, YELLOW, RED};
    
    return colors[glucoseToType(glucose, tag)];
}


NSInteger binarySearchForFontSizeForLabel(UILabel * label, NSInteger minFontSize, NSInteger maxFontSize)
{
    CGSize constraintSize = CGSizeMake(label.frame.size.width, MAXFLOAT);
    do {
        // Set current font size
        UIFont* font = [UIFont fontWithName:label.font.fontName size:maxFontSize];
        
        // Find label size for current font size
        CGRect textRect = [[label text] boundingRectWithSize:constraintSize
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:@{NSFontAttributeName:font}
                                                     context:nil];
        
        CGSize labelSize = textRect.size;
        
        // Done, if created label is within target size
        if( labelSize.height <= label.frame.size.height )
            break;
        
        // Decrease the font size and try again
        maxFontSize -= 2;
        
    } while (maxFontSize > minFontSize);
    
    return maxFontSize;
}

