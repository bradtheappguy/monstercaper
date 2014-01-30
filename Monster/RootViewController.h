//
//  RootViewController.h
//  Monster
//
//  Created by tang on 12-6-4.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TFTTapForTap.h"

@interface RootViewController : UIViewController {
  
}

@property (nonatomic, retain) TFTInterstitial *interstitial;

- (void) showInterstitial;

@end
