//
//  Player.h
//  Monster
//
//  Created by tang on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"
#import "Platform.h"

@interface Player : CCLayer{
    
    CCSprite *mc;
    
    id loopStand,loopRun,loopJump,jumFall,loopFire,oneTimeHit,oneTimeIce;
    
    int state;
    
    float _playerJump,_playerJumpPower;
    
    int minY,currentLevel;
    
    float acceleration,initSpeed,currentSpeed;
    
    Platform *platformAcc;
    
    Boolean isDead;
    
    id gm;
    
    
    float speed,maxSpeed;
    
  
}
-(void) fireUp;
-(void) goStand;
-(void) callSnd;
-(int) currentY;
+(int) initX;
+(int) initY;
-(void) readyForNewGame;
-(void) gotoAndStop:(NSString *) frame;
-(void) update:(ccTime)de;
-(void) jump;
@property(nonatomic,retain) CCSprite *mc;

@property(nonatomic,retain) id gm,loopStand,loopRun,loopJump,loopFall,loopFire,oneTimeHit,oneTimeIce;
@property(nonatomic,retain) Platform *platformAcc;
 

@property(nonatomic,assign) int state,minY,currentLevel;

@property(nonatomic,assign) float _playerJump,_playerJumpPower,acceleration,initSpeed,speed,currentSpeed,maxSpeed;

 

@property(nonatomic,assign) Boolean isDead;


 
@end
