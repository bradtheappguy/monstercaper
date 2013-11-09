//
//  HelloWorldLayer.m
//  CaveRun
//
//  Created by tang on 12-6-4.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//


// Import the interfaces
#import "GameMain.h"
#import "Player.h"
#import "Background.h"
#import "Platform.h"
#import "CCAnimate+SequenceLoader.h"
#import "MainMenu.h"

// Add to top of file
#import "SimpleAudioEngine.h"
// HelloWorldLayer implementation
@implementation GameMain

@synthesize player,bg,pf,stopGame,gameOverSprite,readyGoClip,coinBigClip,readyGoClipAction,readyGoClipIsFinished;
@synthesize disText,coinText,levelText,totalScoreText,runTimeDisText,runTimeCoinText,loopStand,loopCoinBig,disCMC,dis,levelUp;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameMain *layer = [GameMain node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        
        
        //create game over sprite
        self.readyGoClipIsFinished=NO;
        self.gameOverSprite=[CCSprite spriteWithFile:@"GameOver.png"];
        self.gameOverSprite.visible=NO;
        
        
         
        self.disText=[CCLabelTTF labelWithString:@"0" fontName:@"JFRocSol.TTF" fontSize:20];
        [self.gameOverSprite addChild:self.disText];
        self.disText.anchorPoint=ccp(0,0);
        self.disText.position=ccp(340,280);
        
        
        //create text to show total coins collected
        self.coinText=[CCLabelTTF labelWithString:@"0" fontName:@"JFRocSol.TTF" fontSize:20];
        [self.gameOverSprite addChild:self.coinText];
        self.coinText.anchorPoint=ccp(0,0);
        self.coinText.position=ccp(340,250);
        
        //level text
        self.levelText=[CCLabelTTF labelWithString:@"0" fontName:@"JFRocSol.TTF" fontSize:20];
        [self.gameOverSprite addChild:self.levelText];
        self.levelText.anchorPoint=ccp(0,0);
        self.levelText.position=ccp(340,220);
        
       //SCORE TEXT
        self.totalScoreText=[CCLabelTTF labelWithString:@"0" fontName:@"JFRocSol.TTF" fontSize:28];
        [self.gameOverSprite addChild:self.totalScoreText];
       // self.totalScoreText.anchorPoint=ccp(0,0);
        self.totalScoreText.position=ccp(300,150);
        self.totalScoreText.color=ccc3(255,180,0);

        
        // At end of applicationDidFinishLaunching, replace last line with the following 2 lines:
        //[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"ouch.wav" loop:YES];
        
         [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"readyGo.plist"];
        
        
        self.gameOverSprite.anchorPoint=ccp(0,0);
        
        
        
        self.isTouchEnabled = YES;
        
        self.stopGame=NO;
        
        //background
        
        self.bg=[ Background node];
        
        [self.bg setColorWithRBG];
        
        [self addChild:bg];
        
        
        
        self.pf=[Platform node];
        self.pf.gm=self;
        [self addChild:self.pf];
        
        self.player=[Player node];
        
        self.player.platformAcc=self.pf;
        
        self.player.position=ccp([Player initX],[self.pf getSafeY]);
        
        self.player.gm=self;
        
        
        //play idle anination
        
        [self.player gotoAndStop:@"stand"];
         
        self.pf.player=self.player;
        
        [self addChild:self.player];
        
        
        
        [self addChild:self.gameOverSprite];
        
        
        //reday go sequence animation 
        
        self.readyGoClipAction=[CCSequence actions:[CCAnimate actionWithSpriteSequence:@"readyGo%04d.png"
                                         
                                                                  numFrames:55 
                                                                      delay:0.03f 
                                                    restoreOriginalFrame:NO],
                     [CCCallFunc actionWithTarget:self selector:@selector(startGame)],nil];
        
        self.readyGoClip=[CCSprite node];
        
        CGSize winSize = [[CCDirector sharedDirector]winSize];
        
        self.readyGoClip.position=ccp(winSize.width/2,winSize.height/2);
        
        [self addChild:self.readyGoClip];
        
        self.loopCoinBig=[CCRepeatForever actionWithAction:[CCAnimate actionWithSpriteSequence:@"coin_big%04d.png"
                                                            
                                                                                     numFrames:36
                                                                                         delay:0.05f 
                                                                          restoreOriginalFrame:NO]];
        
        self.disCMC=[CCSprite node];
        
        [self addChild:self.disCMC];
        
        self.coinBigClip=[CCSprite node];
        self.coinBigClip.anchorPoint=ccp(0,0);
        self.coinBigClip.position=ccp(450,280);
        [self.disCMC addChild:self.coinBigClip];
        
        [self.coinBigClip runAction:self.loopCoinBig];
        
        
//        self.runTimeDisText=[CCLabelTTF labelWithString:@"0.0" fontName:@"JFRocSol.TTF" fontSize:22];
//        self.runTimeDisText.anchorPoint=ccp(1,0);
//        self.runTimeDisText.position=ccp(470,290);
//        [self.disCMC addChild:self.runTimeDisText];
        
        
        self.runTimeCoinText=[CCLabelTTF labelWithString:@"0" fontName:@"JFRocSol.TTF" fontSize:22];
        
        self.runTimeCoinText.anchorPoint=ccp(1,0);
        
        self.runTimeCoinText.position=ccp(446,290);
        
        [self.disCMC addChild:self.runTimeCoinText];
        
        
        self.levelUp=[CCSprite spriteWithFile:@"flash.png"];
         
         self.levelUp.anchorPoint=ccp(0,0);
         //self.flash.scale=10;
        
        self.levelUp.visible=NO;
        [self addChild:self.levelUp];
    }
	return self;
}
//start run action - readyGoClipAction after replaceScene finished

-(void) onEnterTransitionDidFinish {
     self.readyGoClipIsFinished=NO;
    [super onEnterTransitionDidFinish];
    [self.readyGoClip runAction:self.readyGoClipAction];
     
}
//update runTimeCoinText text
-(void) updateScore{
    [self.runTimeCoinText setString:[NSString stringWithFormat:@"%i",self.pf.coinsNum]];
    
}
//start game
-(void) startGame{
    self.readyGoClipIsFinished=YES;
    self.dis=0;
    self.disCMC.visible=YES;
    self.player.state=0;
    [self.player gotoAndStop:@"run"];
    [self schedule:@selector(loop:)];
    
     
}

//show game over image and update some texts
-(void) showGameOver{
    
    [self.coinText setString:self.runTimeCoinText.string];
    [self.disText setString:[NSString stringWithFormat:@"%i", (int) (self.dis*0.01)]];
   
    [self.levelText setString:[NSString stringWithFormat:@"%i", self.pf.currentLevel]];
    
    self.gameOverSprite.visible=YES;
    self.disCMC.visible=NO;
    
     int score=self.pf.coinsNum*30+self.dis+self.pf.currentLevel*500;
    
    [self.totalScoreText setString:[NSString stringWithFormat:@"%i", score]];
    
    [self unschedule:@selector(loop:)];
    
}

//the main loop

-(void) loop:(ccTime) delta{
    
    //[self unschedule:_cmd];
    if(self.stopGame){
        return;
    }
    if(self.player.state==-1){
        

    }
    else {
        [self.player update:delta];
        
         
        
        
        [self moveStage:self.player.speed delta:delta];
        
            self.dis+=(self.player.speed*0.05);
            //[self.runTimeDisText setString:[NSString stringWithFormat:@"%i",self.dis]];
         
       
        
    }
           
    //CCLOG(@"%f",self.player.speed);
    //CCLOG(@"%i",[self.pf getSafeY]);
}

//move background and Platform

-(void) moveStage:(float)sp delta:(ccTime)de{
    [self.bg moveWithSpeed:sp/60/7];
    [self.pf move:sp/60];
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    
    if(self.player.state==-1){
        
        
        //[self onEnterTransitionDidFinish];
        //[self.player gotoAndStop:@"run"];
        
        return;
        
    }
    
    
    if(self.player.state==0&&self.readyGoClipIsFinished){
        [self.player jump];
    }
    
    //[self.bg setColorWithRBG];
    
  //  [[CCDirector sharedDirector]replaceScene:[CCTransitionZoomFlipX  transitionWithDuration:0.6 scene:[Ham node]] ];
    
         
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if(self.stopGame){
        self.gameOverSprite.visible=NO;
        [self newGame];
       
        [self onEnterTransitionDidFinish];
        
        return;
    }
    
    if(self.stopGame==NO){
     
    if(self.player.state==1){
        self.player.state=2; 
         
        [self.player gotoAndStop:@"fall"];
    }
    
    }
    
}
//ready for a new game
-(void) newGame{
    [self.pf removeAll];
    
    self.stopGame=NO;
    
    [self.pf createForNewGame];
    
    [self.player readyForNewGame];
    
    [self.runTimeCoinText setString:@"0"];
  
    self.player.position=ccp(self.player.position.x,self.pf.getSafeY);
    
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
    
    [self.pf release];
    
    [self.player release];
    [self.readyGoClip release];
    [self.readyGoClipAction release];
	[super dealloc];
}
@end
