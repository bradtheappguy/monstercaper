//
//  Player.m
//  CaveRun
//
//  Created by tang on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Player.h"
#import "CCAnimate+SequenceLoader.h"
#import "Platform.h"
#import "GameMain.h"
#import "cocos2d.h"
#import "SimpleAudioEngine.h"
//#import "CDAudioManager.h"
@implementation Player
@synthesize mc,gm;
@synthesize loopStand, loopJump,loopRun,loopFall,loopFire,oneTimeHit,oneTimeIce;;
@synthesize state,_playerJump,_playerJumpPower;

@synthesize acceleration;

@synthesize minY;

@synthesize platformAcc;

@synthesize isDead;

 

 
@synthesize initSpeed,currentSpeed,speed,maxSpeed,currentLevel;



-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        
        
          
        self.isDead=NO;
        self.initSpeed=200.0f;
        self.maxSpeed=400.0f;
        self.speed=self.initSpeed;
        self.state=0;
        self._playerJump=0;
        self._playerJumpPower=11;
        
        self.minY=50;
        
        self.currentLevel=1;
        
       
        
        self.acceleration=1;
        
        
        
        self.loopStand=[CCRepeatForever actionWithAction:[CCAnimate actionWithSpriteSequence:@"idle%04d.png"
                                                    
                                                                             numFrames:16 
                                                                             delay:0.03f 
                                                                             restoreOriginalFrame:NO]];
        

        self.loopJump= [CCAnimate actionWithSpriteSequence:@"jump%04d.png"     
                                                 numFrames:8 
                                                 delay:0.05f 
                                                 restoreOriginalFrame:NO];
        
        
        self.loopRun=[CCRepeatForever actionWithAction:[CCAnimate actionWithSpriteSequence:@"run%04d.png"
                                                   
                                                                            numFrames:36 
                                                                            delay:0.014f 
                                                                            restoreOriginalFrame:NO]];
        
        
       
        
        self.loopFall=[CCRepeatForever actionWithAction:[CCSequence actions:[CCAnimate actionWithSpriteSequence:@"fall%04d.png"
                                                        
                                                                                 numFrames:6 
                                                                                     delay:0.03f 
                                                                       restoreOriginalFrame:NO],
                       [CCCallFunc actionWithTarget:self selector:@selector(callSnd)],nil]];
        
        
        self.loopFire=[CCRepeatForever actionWithAction:[CCAnimate actionWithSpriteSequence:@"hitFire%04d.png"
                                                         
                                                                                  numFrames:7 
                                                                                      delay:0.05f 
                                                                       restoreOriginalFrame:NO]];
        
        
        self.oneTimeHit=[CCSequence actions:[CCAnimate actionWithSpriteSequence:@"hit%04d.png"
                                                                             
                                                                                                      numFrames:24 
                                                                                                          delay:0.03f 
                                                                                           restoreOriginalFrame:NO],
                                                         [CCCallFunc actionWithTarget:self selector:@selector(goStand)],nil];
        
        self.oneTimeIce=[CCSequence actions:[CCAnimate actionWithSpriteSequence:@"hitIce%04d.png"
                                             
                                                                      numFrames:16 
                                                                          delay:0.03f 
                                                           restoreOriginalFrame:NO],
                         [CCCallFunc actionWithTarget:self selector:@selector(goStand)],nil];


        self.mc=[CCSprite node];
       
        self.mc.anchorPoint=ccp(0.5,0);
        
        [self addChild:self.mc];
        
        
    }
	return self;
}

//0:run
//1:jump
//2:fall
//-1:stand
//-2:hit
//-3:fire
//-4:ice
-(void) callSnd{
    //CCLOG(@"SSSSSSSSSSSSSSSSSSSSSSSSSSS");
    [[SimpleAudioEngine sharedEngine] playEffect:@"fall.wav" pitch:1 pan:0 gain:1];
}
//selector for hits
-(void) goStand{
    
    if(self.isDead){
        [self gotoAndStop:@"fall"];
        self.state=2;
    }
    else {
        [self gotoAndStop:@"run"];
        self.state=0;
    }
    
}

//switch animations
-(void) gotoAndStop:(NSString *) frame{
    
    if([frame isEqualToString: @"stand"]){
         
        [self.mc stopAllActions];
        
        [self.mc runAction:self.loopStand];
    }
    else if([frame isEqualToString: @"run"]){
         
         [self.mc stopAllActions];
               [self.mc runAction:self.loopRun];
    }
    else if([frame isEqualToString: @"jump"]){
        
         [self.mc stopAllActions];
        
        [self.mc runAction:self.loopJump];
    }
    
    else if([frame isEqualToString: @"fall"]){
        [self.mc stopAllActions];
        //id ccf=[CCCallFunc actionWithTarget:self selector:@selector(callSnd)];
       
        [self.mc runAction:self.loopFall]; 
       
    }
    
    else if([frame isEqualToString: @"fire"]){
        [self.mc stopAllActions];
        
        [self.mc runAction:self.loopFire]; 
        
    }
    
    else if([frame isEqualToString: @"hit"]){
        [self.mc stopAllActions];
        [self.mc runAction:self.oneTimeHit];
    }
    
    else if([frame isEqualToString: @"ice"]){
        [self.mc stopAllActions];
        [self.mc runAction:self.oneTimeIce];
    }
}
//update state and position

-(void) update:(ccTime) de{
    
    float de60=1;//de*60;
    
    int safeY=[self.platformAcc getSafeY];
    
    
    if(self.speed<self.maxSpeed&&!self.isDead){
        self.speed+=self.acceleration;
    }
    
    if(self.state==-2&&self.speed>0&&!self.isDead){
        self.speed-=self.acceleration*5;
    }
    
    
    
    if((self.state==0||self.state==-2||self.state==-4)&&safeY==-300){
        
        self._playerJump=0;
        self.state=2;
        //self.isDead=YES;
        [self gotoAndStop:@"fall"];  
        
        CCLOG(@"------------fall  ,when state is 0 (idle) -----------------");
    }
    
    if(self.state==1||self.state==2||self.state==-3){
       
        
        if(self.state==2&&self._playerJump>0){
            self._playerJump*=0.6*de60;
        }
        else if(self.state==1||self.state==-3){
            if(self._playerJump<=0){
                
                             
                self.state=2;
                
                [self gotoAndStop:@"fall"]; 
                
               
            }
            
        }
      
        if(self.state==2&&(self.position.y+self._playerJump<=safeY&&self.position.y>=safeY&&self.isDead==NO)){
            
            
            self.position=ccp(self.position.x,safeY);
            [self gotoAndStop:@"run"];
           
            self.state=0;
            
            [((GameMain*)[self gm]).pf hitTestOB];
        }
        else{
            
            
            self.position=ccp(self.position.x,self.position.y+self._playerJump);
          
            if(self.isDead){
                if(self.position.y<-300){
                    
                    
                    if(self.speed>0){
                        self.speed*=0.8;
                        if(self.speed<=0.2){
                            self.speed=0;
                        }
                    }else{
                        if([self.gm stopGame]==NO){
                            GameMain *gameMain=(GameMain*)self.gm;
                            
                            
                            [gameMain showGameOver];
                            
                            gameMain.stopGame=YES;
                            
                            [self.mc stopAllActions];
                            [[SimpleAudioEngine sharedEngine] playEffect:@"crash.wav" pitch:1 pan:0 gain:1];
                            CCLOG(@"=========Player Dead ,Game Over !===========");
                        }
                    }
                }
            }  
            if((safeY!=300&&self.position.y<safeY&&self.state!=1)){
                self.isDead=YES;
            }
        }
        
        
               
        self._playerJump-=0.25*de60;
        
    }
}

-(int) currentY{
    return mc.position.y;
}

-(void) readyForNewGame{
    self.isDead=NO;
    self._playerJump=_playerJumpPower;
    self.speed=self.initSpeed;
    self.maxSpeed=400.0f;
    self.state=-1;
    [self gotoAndStop:@"stand"];
    self.position=ccp([Player initX],[Player initY]);
     
}

//jump
-(void) jump{
    [self gotoAndStop:@"jump"];
    self._playerJump=self._playerJumpPower;
    self.state=1;
}
//spray up by fire
-(void) fireUp{
    [self gotoAndStop:@"fire"];
    self._playerJump=self._playerJumpPower*.65;
    self.state=-3;
    
}

 
- (void) dealloc
{
    
    self.mc = nil;
    self.loopStand = nil;
    self.loopJump = nil;
    self.loopRun = nil;
    self.platformAcc=nil;
    self.loopFall=nil;
    self.loopFire=nil;
    [super dealloc];
}

+(int) initX{
    return 100;
}
+(int) initY{
    return 40;
}
@end
