//
//  GameLayer.h
//  QuickBlackJack
//
//  Created by Kayden Bui on 2/28/13.
//  Copyright 2013 Kayden Bui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
@class Player;
@class Dealer;

@interface GameLayer : CCLayer {
    
}

+ (CCScene *) scene;
@property (nonatomic, strong) CCSpriteBatchNode *spriteBatchNode;

@property (nonatomic, strong) NSMutableArray *cardDeck;

@property (nonatomic, strong) Player *player;
@property (nonatomic, strong) Dealer *dealer;

@property (nonatomic, strong) CCLabelTTF *totalPointsLabel;
@property (nonatomic, strong) CCLabelTTF *gameStatusLabel;


@end
