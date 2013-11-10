//
//  Background.m
//  Monster
//
//  Created by tang on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Background.h"
#import "cocos2d.h"
@implementation Background
@synthesize bgb;
@synthesize bgf;
@synthesize staticBG;

@synthesize bgbLayer;
@synthesize bgfLayer;

@synthesize daylight;
@synthesize bgImgs;

static CGFloat width = 0;

-(id) init
{
    if( (self=[super init])) {
        
        width = [[UIScreen mainScreen] bounds].size.height;
        
        bgImgs=[[NSMutableArray alloc]init];
        staticBG=[CCSprite spriteWithFile:@"background.jpg"];
        
        [self.bgImgs addObject:staticBG];
        bgbLayer=[CCLayer node];
        bgfLayer=[CCLayer node];
        
        bgb=[CCSprite spriteWithFile:@"bgb.png"];
        bgb.anchorPoint=ccp(0,0);
        [bgbLayer addChild:bgb];
        [self.bgImgs addObject:bgb];
        bgb=[CCSprite spriteWithFile:@"bgb.png"];
        bgb.anchorPoint=ccp(0,0);
        bgb.position=ccp(width-1,0);
        [bgbLayer addChild:bgb];
        [self.bgImgs addObject:bgb];
        
        
        
        daylight=[CCSprite spriteWithFile:@"daylight.png"];
        daylight.anchorPoint=ccp(0,0);
        daylight.position=ccp(width-180,-80);
        
        
        bgf=[CCSprite spriteWithFile:@"bgf.png"];
        bgf.anchorPoint=ccp(0,0);
        [bgfLayer addChild:bgf];
        [self.bgImgs addObject:bgf];
        bgf=[CCSprite spriteWithFile:@"bgf.png"];
        bgf.anchorPoint=ccp(0,0);
        bgf.position=ccp(width-1,0);
        
        [self.bgImgs addObject:bgf];
        [bgfLayer addChild:bgf];
        
        
        
        
        staticBG.anchorPoint=ccp(0,0);
        
        bgbLayer.position=ccp(-(width-180),0);
        
        [self addChild:staticBG];
        [self addChild:daylight];
        [self addChild:bgbLayer];
        
        [self addChild:bgfLayer];
        
        
      [self setColorWithRBG];
    }
    return self;
}

//set it's color to random color

-(void)setColorWithRBG{
  return;
  int rrr=(int)(1+arc4random()%255/2+255/2);
  int ggg=(int)(1+arc4random()%255/2+255/2);
  int bbb=(int)(1+arc4random()%255/2+255/2);
          
    for(int i=0;i<[self.bgImgs count];i++){
        CCSprite * toChangeColor=[self.bgImgs objectAtIndex:i];
        
       toChangeColor.color=ccc3(rrr,ggg,bbb);
    }
    
    //((CCSprite*) self).color=ccc3(rrr,ggg,bbb);
}
-(void) moveWithSpeed:(float) speed{
    bgbLayer.position=ccp(bgbLayer.position.x-speed,bgbLayer.position.y);
    
    bgfLayer.position=ccp(bgfLayer.position.x-speed*2,bgfLayer.position.y);
    
    if(bgbLayer.position.x<-width){
        bgbLayer.position=ccp(0,0);
    }
    
    if(bgfLayer.position.x<-width){
        bgfLayer.position=ccp(0,0);
    }
}
- (void) dealloc
{
    self.bgb=nil;
    self.bgf=nil;
    self.staticBG=nil;
    
    self.bgbLayer=nil;
    self.bgfLayer=nil;
    self.bgImgs=nil;
    [super dealloc];
}
@end
