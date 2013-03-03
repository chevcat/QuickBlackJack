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
        if ([[self.cardHands objectAtIndex:i] isKindOfClass:[CardObject class]]) {
            CardObject *card = [self.cardHands objectAtIndex:i];
            if (card.cardNumber == 1) {
                if (sum + card.cardValue < 12) {
                    card.cardValue = 11;
                }
            }
            sum += card.cardValue;
        }
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






@end
