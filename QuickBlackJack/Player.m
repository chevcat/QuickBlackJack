//
//  Player.m
//  QuickBlackJack
//
//  Created by Kayden Bui on 3/1/13.
//  Copyright (c) 2013 Kayden Bui. All rights reserved.
//

#import "Player.h"
#import "CardObject.h"

@implementation Player
@synthesize fund = _fund;
@synthesize cardHands = _cardHands;
@synthesize layer = _layer;
@synthesize totalPoints = _totalPoints;
@synthesize busted = _busted;
@synthesize turnFinished = _turnFinished;

- (id) initWithLayer:(GameLayer *)layer {
    if ((self = [super init])) {
        self.layer = layer;
        self.cardHands = [[NSMutableArray alloc] init];
        self.fund = 5000;
        self.totalPoints = 0;
        self.busted = NO;
        self.turnFinished = NO;
    }
    return self;
}

- (NSInteger) totalPoints {
    //calculate player's totalPoints based on the values of their cards
    NSInteger sum = 0;
    for (int i = 0; i < [self.cardHands count]; i++) {
        CardObject *card = [self.cardHands objectAtIndex:i];
        if (card.cardNumber == 1) {
            if (sum + card.cardValue < 12) {
                card.cardValue = 11;
            }
        }
        sum += card.cardValue;
    }
    if (sum > 21) {
        for (int i = 0; i < [self.cardHands count]; i++) {
            CardObject *card = [self.cardHands objectAtIndex:i];
            if (card.cardValue == 11) {
                card.cardValue = 1;
                sum = sum - 10;
                break;
            }
        }
    }
    return sum;
}

- (void) drawCard:(float)delay{
    //add card from deck to player's hand and remove it from deck
   // NSInteger cardCount = [self.cardHands count];
    
    
        //transfer card from deck to player's hand
        CardObject *card = [self.layer.cardDeck lastObject];
        [self.cardHands addObject:card];
        [self.layer.cardDeck removeLastObject];
        
        NSInteger count = [self.cardHands count];
        CGFloat x = 100;
        CGFloat y = 140;
        
        if (count == 1) {
            if (!delay) {
                id move = [CCMoveTo actionWithDuration:0.4 position:ccp(x, y)];
                [card.sprite runAction:move];
            } else {
                id delayTime    = [CCDelayTime actionWithDuration:delay];
                id move     = [CCMoveTo actionWithDuration:0.4 position:ccp(x, y)];
                id sequence = [CCSequence actions:delayTime, move, nil];
                [card.sprite runAction:sequence];
            }
            [card setPlainPosition:ccp(x, y)];
            //card.position = ccp(x, y);
        }
        
        if (count > 1) {
            CGFloat previousX = [[self.cardHands objectAtIndex:(count - 2)] position].x;
            if (!delay) {
                CCMoveTo *move = [CCMoveTo actionWithDuration:0.4 position:ccp(previousX + 10, y)];
                [card.sprite runAction:move];
            } else {
                id delayTime    = [CCDelayTime actionWithDuration:delay];
                id move     = [CCMoveTo actionWithDuration:0.4 position:ccp(previousX + 10, y)];
                id sequence = [CCSequence actions:delayTime, move, nil];
                [card.sprite runAction:sequence];
            }
            
            [card setPlainPosition:ccp(previousX +10, y)];
            //card.position = ccp(previousX + 10, y);
        }
        //arrange cards in player's hand
        
        
        //self.player.totalPoints += card.cardValue;
        self.layer.totalPointsLabel.string = [NSString stringWithFormat:@"%d", self.totalPoints];
        if (self.totalPoints > 21) {
            self.busted = YES;
            [self.layer performSelector:@selector(dealerTurn:) withObject:nil];
        }
        [self.layer.spriteBatchNode addChild:card.sprite];
}




@end