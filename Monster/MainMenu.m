//
//  Ham.m
//  Monster
//
//  Created by tang on 12-6-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MainMenu.h"
#import "cocos2d.h"
#import "Player.h"
#import "GameMain.h"
#import "SimpleAudioEngine.h"
@implementation MainMenu

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MainMenu *layer = [MainMenu node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        
        
                
        [CDSoundEngine setMixerSampleRate:CD_SAMPLE_RATE_MID];
                                
        //[[SimpleAudioEngine sharedEngine] preloadEffect:@"coin.wav" ];
                            
           
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"f.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"decalnew-hd.plist"];
        
        
        self.isTouchEnabled = YES;
    
        CGFloat width = [[UIScreen mainScreen] bounds].size.height;
        CCSprite *sp=[CCSprite spriteWithFile:(width > 480)?@"MainMenu-568.png":@"MainMenu.png"];
        
        sp.anchorPoint=ccp(0,0);
        [self addChild:sp];
        
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"bgm.mp3" loop:YES];
        
         
        
        
    }
    
    return self;
    
}

//replaceScene to GameMain
-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
        [[CCDirector sharedDirector]replaceScene:[CCTransitionFadeBL transitionWithDuration:0.6 scene:[GameMain node]] ];
    
    
}

-(void) dealloc{
    
    [super dealloc];
}



@end
