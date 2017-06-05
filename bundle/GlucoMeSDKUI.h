//
//  GlucoMeSDK.h
//  GlucoMeSDK
//
//  Created by דרור זוהר on 5/17/17.
//  Copyright © 2017 דרור זוהר. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GlucoMeResult : NSObject
@property NSInteger value;
@property NSInteger firmewareVersion;
@property NSInteger uid;
@end

@interface GlucoMeTagResult : NSObject
@property NSDate *date;
@property NSString *comment;
@property NSInteger tags;
@end

@class GlucoMeSDKUI;
@protocol GlucoMeSDKUIDelegateProtocol <NSObject>

-(void)glucoMeSDKResult:(GlucoMeResult*)glucoMeResult;
-(void)glucoMeSDKTagResult:(GlucoMeTagResult*)glucoMeTagResult;

@end

@interface GlucoMeSDKUI : NSObject 

@property (weak, nonatomic) id<GlucoMeSDKUIDelegateProtocol> delegate;

- (void)start;

- (void)stop;

- (IBAction)showTutorial;

- (void)start:(BOOL)withUI;

- (void)showGlucoMeResult:(GlucoMeResult *)gluocoMeResult withTagResult:(GlucoMeTagResult*)glucoMeTagResult;

-(NSString*)showSDKVersion;

    
@end


