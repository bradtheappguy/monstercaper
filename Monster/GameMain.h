//
//  HelloWorldLayer.h
//  Monster
//
//  Created by tang on 12-6-4.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
 
#import "Background.h"
#import "Player.h"
#import "Platform.h"
// HelloWorldLayer
@interface GameMain : CCLayer
{
    Player *player;
    
    Background *bg;
    
    Platform *pf;
    
    float speed;
    
    int dis;
    
    Boolean stopGame,readyGoClipIsFinished;
    
    CCSprite *gameOverSprite,*disCMC;
    
    CCSprite *readyGoClip;
    CCSprite *coinBigClip;
    
    id readyGoClipAction;
    id loopCoinBig;
    
    CCLabelTTF *disText,*coinText,*levelText,*totalScoreText,*runTimeDisText,*runTimeCoinText;
    
    CCSprite *levelUp;
    
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
-(void) moveStage:(float)sp delta:(ccTime)de;

-(void) showGameOver;
-(void) newGame;
-(void) onEnterTransitionDidFinish;
-(void) startGame;
-(void) updateScore;
 
 
 
@property(nonatomic,retain) Player *player;
@property(nonatomic,retain) Background *bg;
@property(nonatomic,retain) Platform *pf;
@property(nonatomic,assign) Boolean stopGame,readyGoClipIsFinished;

@property(nonatomic,assign) int dis;

@property(nonatomic,retain) CCSprite *gameOverSprite,*readyGoClip,*coinBigClip,*disCMC,*levelUp;
@property(nonatomic,retain) id readyGoClipAction,loopStand,loopCoinBig;

@property(nonatomic,retain) CCLabelTTF *disText,*coinText,*levelText,*totalScoreText,*runTimeDisText,*runTimeCoinText;;


@end
