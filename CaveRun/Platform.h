//
//  Platform.h
//  CaveRun
//
//  Created by tang on 12-6-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"
 
@interface Platform : CCLayer{
    int widMax,widMin,leftWidth,rightWidth,midWidth,gap;
   
    CCLayer *currentPF;
    CCLayer *lastPF;
    CCSprite *__pf;
    NSMutableArray *pool,*pfsArr,*pfWidthArr,*coinsArr,*coinsArrsArr,*obsArr,*obsArrsArr;
    int lastWid,coinsNum,currentLevel;
    
    
    id player;
    
    id gm;
    
    
}
-(void) hideLevelUp;
-(void) createForNewGame;
-(void) initForNewGame;
-(void) move:(float) speed ;
-(void)hitTestOB;
-(CCLayer *) create:(int) _width addOB:(BOOL)addob;
-(void) addMidDecalToPool:(int)cnt;
-(CCSprite *) getDecalFromPool;
-(int) getSafeY;
-(void) removeAll;
-(NSMutableArray *) getCurrentCoinsArr;
-(NSMutableArray *) getCurrentObsArr;
-(CCLayer*) getCurrentPFUnderPlayer;
-(void) tryRemoveCoin;
@property(nonatomic,assign) int widMax, widMin,leftWidth,rightWidth,midWidth,gap,lastWid,coinsNum,currentLevel;
@property(nonatomic,retain) CCSprite *__pf;
@property(nonatomic,retain) CCLayer *lastPF;
 
@property(nonatomic,retain) id player,gm;
@property(nonatomic,retain) NSMutableArray *pool,*pfsArr,*pfWidthArr,*coinsArr,*coinsArrsArr,*obsArr,*obsArrsArr;

@end
