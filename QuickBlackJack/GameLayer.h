//
//  GameLayer.h
//  QuickBlackJack
//
//  Created by Kayden Bui on 2/28/13.
//  Copyright 2013 Kayden Bui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
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
@property (nonatomic, strong) CCLabelTTF *totalDealerPointsLabel;
@property (nonatomic, strong) CCLabelTTF *gameStatusLabel;
@property (nonatomic, strong) CCLabelTTF *playerFundLabel;
@property (nonatomic, strong) CCLabelTTF *betPotLabel;

@property (nonatomic, strong) CCMenuItem *hitButton;
@property (nonatomic, strong) CCMenuItem *standButton;
@property (nonatomic, strong) CCMenuItem *okButton;
@property (nonatomic, strong) CCMenuItem *dealButton;
@property (nonatomic, strong) CCMenu *betMenu;

@property (nonatomic, assign) NSInteger betPot;


@end
