//
//  GlucoMeSDK.h
//  GP Spectrogram
//
//  Created by dovi winberger on 12/29/14.
//  Copyright (c) 2014 Yiftah Ben Aharon. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol GlucoMeSDKDelegateProtocol <NSObject>

-(void)GlucoMeSDKFinishedWith_uid:(int)uid firmewareVersion:(int)firmewareVersion error:(int)error battery:(int)battery glucose:(int)glucose;

@end

@interface GlucoMeSDK : NSObject
{
    BOOL didStart;
}

@property (nonatomic, weak) id<GlucoMeSDKDelegateProtocol> delegate;

-(NSString*)SDKVersion;

- (void)startWithAudioPermissionDenidedBlock:(void(^)())audioDeniedBlock;
-(void)stop;

@end
