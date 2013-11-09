//
//  Platform.m
//  CaveRun
//
//  Created by tang on 12-6-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Platform.h"
#import "cocos2d.h"
#import "CCAnimate+SequenceLoader.h"
#import "Player.h"
#import "SimpleAudioEngine.h"

#import "GameMain.h"

@implementation Platform

@synthesize widMax,widMin,leftWidth,rightWidth,midWidth,gap,lastWid;

@synthesize pool;
 
@synthesize lastPF;
@synthesize __pf;

@synthesize pfsArr,pfWidthArr;

@synthesize coinsArr;


@synthesize coinsArrsArr;

@synthesize player;

@synthesize obsArr,obsArrsArr,coinsNum,currentLevel,gm;

-(id) init
{
    
    
    
    if( (self=[super init])) {
        self.gap=50;
        self.coinsNum=0;
        self.currentLevel=1;
        self.lastWid=0;
        self.leftWidth=122/2;
        self. rightWidth=122/2;
        self. midWidth=100/2;
        self. widMax=800;
        self.widMin=200;
        
        self.pool=[[NSMutableArray alloc]init];
        self.pfsArr=[[NSMutableArray alloc]init];
        self.pfWidthArr=[[NSMutableArray alloc]init];
        
        self.coinsArrsArr=[[NSMutableArray alloc]init];
        
        self.obsArr=[[NSMutableArray alloc]init];
        
        self.obsArrsArr=[[NSMutableArray alloc]init];
        
      
        
        [self addMidDecalToPool:500];
        
        
        
        
        
        
        self.lastPF=[self create:1000 addOB:NO];
        [self addChild:self.lastPF];
        
        
        
        
    }
    
    
    
    return self;
    
}

//move pf clips

-(void) move:(float) speed {
    // self.position=ccp(self.position.x-speed,self.position.y);
    //CCLOG(@"%i",[pfsArr count]);
    
    id pf=nil;
    
    for(int i=0;i<[self.pfsArr count];i++){
        CCLayer * _pf_=[self.pfsArr objectAtIndex:i];
        _pf_.position=ccp(_pf_.position.x-speed,_pf_.position.y);
        
       
        if(_pf_.position.x+[[self.pfWidthArr objectAtIndex:i] intValue]<0){
            pf=_pf_;
          
        }
    }
    
    //if old pf is out of the stage , create new
    
    if(self.lastPF.position.x+self.lastWid<480){
        int cn=(int)(500+arc4random()%800);
        int _y=(int)(30+arc4random()%200);
        int _x=self.lastPF.position.x+self.lastWid+100+((int) arc4random()%self.gap);
        CCLayer *newPF=[self create:cn addOB:YES];
        newPF.position=ccp( _x,_y);
        self.lastPF=newPF;
        [self addChild:newPF];
    }
    
    //remove pf
    if(pf){
          
         //CCLOG(@"========== Platform removed ============");
         [self removeChild:pf cleanup:YES];
         [self.pfWidthArr removeObjectAtIndex:0];
         [self.pfsArr removeObjectAtIndex:0];
         [self.coinsArrsArr removeObjectAtIndex:0];
         [self.obsArrsArr removeObjectAtIndex:0];
        
    }
    
    [self tryRemoveCoin];
    
}

//remove all platforms

-(void) removeAll{
    for(int i=0;i<[self.pfsArr count];i++){
        [self removeChild:[self.pfsArr objectAtIndex:i] cleanup:NO];
    }
    self.pfsArr=[[NSMutableArray alloc]init];
}

//ready for new game 
-(void) createForNewGame{
    self.currentLevel=1;
    self.coinsNum=0;
    self.gap=50;
    self.lastPF=nil;
    self.obsArrsArr=[[NSMutableArray alloc]init];
    self.pfsArr=[[NSMutableArray alloc]init];
    self.pfWidthArr=[[NSMutableArray alloc]init];
    self.coinsArrsArr=[[NSMutableArray alloc]init];
    self.lastPF=[self create:1000 addOB:NO];
    [self addChild:self.lastPF];
    
}

-(void) initForNewGame{
    
}

//create platforms
-(CCLayer *) create:(int) _width addOB:(BOOL)addob{
    
    
    self.coinsArr=[[NSMutableArray alloc]init];
    self.obsArr=[[NSMutableArray alloc]init];
    
    CCLayer *mc=[CCLayer node];
    
  
    int _wid=_width;
    if(_wid<self.widMin){
        _wid=self.widMin;
    }
    
    
    int _widMid=_wid-(self.leftWidth+self.rightWidth);
    
    
    int numSpriteToCreate=_widMid/100;
    
    int maxNumOfOb=1;
    
    CCSprite * left=[CCSprite spriteWithSpriteFrameName:@"d0.png"];
    left.anchorPoint=ccp(0,1);
    [mc addChild:left];
    for(int i=0;i<numSpriteToCreate;i++){
        
        CCSprite *midMC=[self getDecalFromPool];
        
        
        midMC.anchorPoint=ccp(0,1);
        
        midMC.position=ccp(leftWidth+i*midWidth,0);
        
        [mc addChild:midMC];
        
        if(arc4random()%10>3){
            
            if(maxNumOfOb>0&&arc4random()%10>8&&addob){
                
                NSString *typeStr;
                CCSprite *ob;
                
                int rn=arc4random()%10;
                if(rn>=7&&rn<=9){
                   typeStr =@"stone";
                    ob=[CCSprite spriteWithSpriteFrameName:@"obstacle_small0001.png"];
                } 
                if(rn>=4&&rn<=6){
                    typeStr =@"fire";
                    ob=[CCSprite spriteWithSpriteFrameName:@"obstacle_small0003.png"];
                }
                
                if(rn>=1&&rn<=3){
                    typeStr =@"ice";
                    ob=[CCSprite spriteWithSpriteFrameName:@"obstacle_small0005.png"];
                }
                
                if(rn==0){
                    typeStr =@"no";
                    ob=[CCSprite spriteWithSpriteFrameName:@"obstacle_small0004.png"];
                }
                
                
                
                ob.position=ccp(midMC.position.x+5,midMC.position.y-16);
               
                [mc addChild:ob];
                
                NSMutableArray * objArr=[[NSMutableArray alloc]init];
                
                [objArr addObject:ob];
                
                [objArr addObject:typeStr];
                
                //[objArr addObject:NO];
                
                [self.obsArr addObject:objArr];
                
                maxNumOfOb--;
            }
            else {
                 
            
                id loopCoin= [CCRepeatForever actionWithAction:[CCAnimate actionWithSpriteSequence:@"coin%04d.png"
                                                            
                                                                                     numFrames:36 
                                                                                         delay:0.014f 
                                                                          restoreOriginalFrame:NO]];            
                
                CCSprite *coin=[CCSprite node];
            
                [coin runAction:loopCoin];
            
                coin.position=ccp(midMC.position.x+5,midMC.position.y-10);
                
                [mc addChild:coin];
            
                [self.coinsArr addObject:coin];
                
            }
            
        }
    }
    
    CCSprite * right=[CCSprite spriteWithSpriteFrameName:@"d6.png"];
    right.anchorPoint=ccp(0,1);
    right.position=ccp(leftWidth+numSpriteToCreate*midWidth,0);
    
    [mc addChild:right];
    
   
    
    if(!self.lastPF){
        mc.position=ccp(0,74);
    }
    
    self.lastWid=(numSpriteToCreate*midWidth+self.leftWidth+self.rightWidth);
    [pfWidthArr addObject:[NSNumber numberWithInt:self.lastWid]];
    
    [self.pfsArr addObject:mc];
    
    [self.coinsArrsArr addObject:self.coinsArr];
    [self.obsArrsArr addObject:self.obsArr];
    return mc;
}

//get current coins array

-(NSMutableArray *) getCurrentCoinsArr{
    int idx=0;
    
    int arrCount=[self.coinsArrsArr count];
     
    if(((CCLayer *)([self.pfsArr objectAtIndex:0])).position.x+[[self.pfWidthArr objectAtIndex:0] intValue]<[Player initX]){
        
        idx=1;
        
        
    }
    
    if(arrCount==1&&idx==1){
        return nil;
    }
    
    if(arrCount>=0&&idx==0){
        return [self.coinsArrsArr objectAtIndex:0];
    }
    
    if(arrCount>=2&&idx==1){
        return [self.coinsArrsArr objectAtIndex:1];
    }
    
    return nil;
}

//get current obstructs array

-(NSMutableArray *) getCurrentObsArr{
    int idx=0;
    
    int arrOb=[self.obsArrsArr count];
    
    
    
    if(((CCLayer *)([self.pfsArr objectAtIndex:0])).position.x+[[self.pfWidthArr objectAtIndex:0] intValue]<[Player initX]){
        
        idx=1;
        
        
    }
    
    
    
    if(arrOb==1&&idx==1){
        return nil;
    }
    
    if(arrOb>=0&&idx==0){
        return [self.obsArrsArr objectAtIndex:0];
    }
    
    if(arrOb>=2&&idx==1){
        return [self.obsArrsArr objectAtIndex:1];
    }
    
    return nil;
}

//try remove coin

-(void) tryRemoveCoin{
    NSMutableArray * cca=[self getCurrentCoinsArr];
    
    if(cca){
        
       
        int py=((CCLayer*)(self.player)).position.y;
        for(int i=0;i<[cca count];i++){
            CCSprite *coin=[cca objectAtIndex:i];
            if(abs(coin.position.x+coin.parent.position.x-[Player initX])<6){
                
                 
                if(abs(coin.position.y+coin.parent.position.y-py)<30&&coin.visible&&coin.visible){
                   //coin.visible=NO; 
                   [coin.parent removeChild:coin cleanup:YES];
                   [[SimpleAudioEngine sharedEngine] playEffect:@"coin.wav" pitch:1 pan:0 gain:1];
                    
                    
                    [self.gm updateScore];
                    if((++self.coinsNum%60==0)){
                        self.currentLevel++;
                        ((Player*)[self player ]).maxSpeed+=20;
                        //NSLog(@"%i",self.currentLevel);
                        
                        //NSLog(@"%f",((Player*)[self player ]).maxSpeed);
                        
                        if(self.gap<90){
                            self.gap+=10;
                        }
                        
                        ((GameMain*)[self gm ]).levelUp.visible=YES;
                        
                        ((GameMain*)[self gm ]).levelUp.opacity=255;
                        
                        id delay = [CCDelayTime actionWithDuration:0.5];
                        id fadeAlphaTo0=[CCFadeTo actionWithDuration:0.5 opacity:0];
                        id func=[CCCallFunc actionWithTarget:self selector:@selector(hideLevelUp)];
                        id action = [CCSequence actions:delay,fadeAlphaTo0,func,nil]; 
                         [((GameMain*)[self gm ]).levelUp runAction:action];
                        
                         [[SimpleAudioEngine sharedEngine] playEffect:@"levelUp.wav" pitch:1 pan:0 gain:1];
                        
                         [((GameMain*)[self gm ]).bg setColorWithRBG];
                    }
                }
                
                
            }
        }
       
        
    }

     
    [self hitTestOB];
}

//check obstruct if player hittest it

-(void)hitTestOB{
    NSMutableArray * oba=[self getCurrentObsArr];
    
    if(oba){
        
        
        int py=((CCLayer*)(self.player)).position.y;
        
        
        for(int i=0;i<[oba count];i++){
            CCSprite *ob=[((NSMutableArray*)([oba objectAtIndex:i])) objectAtIndex:0];
            NSString *type=[((NSMutableArray*)([oba objectAtIndex:i])) objectAtIndex:1];
            if(abs(ob.position.x+(ob.parent.position.x+20)-[Player initX])<30){
                
                
                if(abs(ob.position.y+ob.parent.position.y-py)<20&&ob.visible&&ob.opacity==255){
                    
                    
                    ob.opacity=254;
                    
                    
                    
                    if(type==@"fire"){
                        
                        
                        if(((Player *)self.player).state==2||((Player *)self.player).state==0
                           ||((Player *)self.player).state==-3||((Player *)self.player).state==-4){
                            
                            [[SimpleAudioEngine sharedEngine] playEffect:@"ouch.wav" pitch:1 pan:0 gain:1];
                            
                            [self.player fireUp];                            
                        }
                    }
                    
                    else if(type==@"stone"){
                        
                        if(((Player *)self.player).state==0){
                            [[SimpleAudioEngine sharedEngine] playEffect:@"hit.wav" pitch:1 pan:0 gain:1];
                            
                            [self.player gotoAndStop:@"hit"];
                            
                            ((Player *)self.player).state=-2;
                        }
                        
                        
                    }
                    
                    else if(type==@"ice"){
                        
                        if(((Player *)self.player).state==0){
                            [[SimpleAudioEngine sharedEngine] playEffect:@"slip.wav" pitch:1 pan:0 gain:1];
                            
                            [self.player gotoAndStop:@"ice"];
                            
                            ((Player *)self.player).state=-4;
                        }
                        
                        
                    }
                    
                    
                }
                
                
                
            }
            
        }
        
    }

}

//hide levelUP image of GameMain

-(void) hideLevelUp{
    ((GameMain*)[self gm ]).levelUp.visible=NO;
}


//get current platform under player
-(CCLayer*) getCurrentPFUnderPlayer{
    CCLayer* repf=nil;
    int bordureX=-14;
    
    for(int i =0; i<[self.pfsArr count]; i++){
        
        CCLayer *pf=[self.pfsArr objectAtIndex:i];
        
        if(pf.position.x+[[self.pfWidthArr objectAtIndex:i]intValue]>Player.initX+bordureX&&pf.position.x<Player.initX-bordureX){
            repf=pf;
        }
        
    }
    
return repf;
    
}


-(void) addMidDecalToPool:(int)cnt{
    CCSprite *tempPF;
    NSString *fn;
    
    for(int i=0;i<cnt;i++){
        
        fn=[NSString stringWithFormat:@"d%i.png",(i%5)+1];
        tempPF=[CCSprite spriteWithSpriteFrameName:fn];
       
        [self.pool addObject:[CCSprite spriteWithSpriteFrameName:fn]];
    }
         
}

-(CCSprite *) getDecalFromPool{
     
    
    if([self.pool count]==0){
        [self addMidDecalToPool:5];
    }
    self.__pf=[self.pool objectAtIndex:0];
    
    [self.pool removeObjectAtIndex:0];
    
    return self.__pf;
}

-(int) getSafeY{
    int bordureY=30;
    CCLayer *pf=[self getCurrentPFUnderPlayer];
    if(pf!=nil){
        return pf.position.y-bordureY;
    }
                
    return -300;
}


-(void) dealloc{
    self.lastWid=0;
    self.lastPF=nil;
    self.__pf=nil;
    self.pool=nil;
    [super dealloc];
}


@end
