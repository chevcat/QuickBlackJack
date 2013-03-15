//
//  Dealer.m
//  QuickBlackJack
//
//  Created by Kayden Bui on 3/1/13.
//  Copyright (c) 2013 Kayden Bui. All rights reserved.
//

#import "Dealer.h"
#import "CardObject.h"

@implementation Dealer
@synthesize cardHands = _cardHands;
@synthesize layer = _layer;
@synthesize totalPoints = _totalPoints;
@synthesize busted = _busted;
@synthesize turnFinished = _turnFinished;
@synthesize containsAce = _containsAce;

- (id) initWithLayer:(GameLayer *)layer {
    if ((self = [super init])) {
        self.layer = layer;
        self.cardHands = [[NSMutableArray alloc] init];
        self.totalPoints = 0;
        self.busted = NO;
        self.turnFinished = NO;
        self.containsAce = NO;
    }
    return self;
}

- (NSInteger) totalPoints {
    //calculate player's totalPoints based on the values of their cards
    NSInteger sum = 0;
    for (int i = 0; i < [self.cardHands count]; i++) {
        if ([[self.cardHands objectAtIndex:i] isKindOfClass:[CardObject class]]) {
            CardObject *card = [self.cardHands objectAtIndex:i];
            //Ace case
            if (card.cardNumber == 1) {
                self.containsAce = YES;
                if (sum + card.cardValue < 12) {
                    card.cardValue = 11;
                }
            }
            sum += card.cardValue;
        }
    }
    
    //Check to see if there's aces when sum > 21
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

- (void) drawCard {
    //add card from deck to player's hand and remove it from deck
        if ([self.cardHands count] < 8) {
            //transfer card from deck to dealer's hand
            CardObject *card = [self.layer.cardDeck lastObject];
            [self.cardHands addObject:card];
            [self.layer.cardDeck removeLastObject];
            
            //position of dealer's first card
            CGFloat x = card.position.x;
            CGFloat y = card.position.y * 3;
            
            NSInteger count = [self.cardHands count];
            if (count == 1) {
                card.position = ccp(x, y);
            }
            
            if (count > 1) {
                CGFloat previousX = [[self.cardHands objectAtIndex:(count - 2)] position].x;
                previousX += 10;
                card.position = ccp(previousX, y);
            }
            self.layer.totalDealerPointsLabel.string = [NSString stringWithFormat:@"%d", self.totalPoints];
            [self.layer.spriteBatchNode addChild:card.sprite];
        }
}
@end
