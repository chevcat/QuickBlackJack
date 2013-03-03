//
//  GameLayer.m
//  QuickBlackJack
//
//  Created by Kayden Bui on 2/28/13.
//  Copyright 2013 Kayden Bui. All rights reserved.
//

#import "GameLayer.h"
#import "CardObject.h"
#import "Player.h"
#import "Dealer.h"

@implementation GameLayer

@synthesize spriteBatchNode = _spriteBatchNode;
@synthesize cardDeck = _cardDeck;
@synthesize player = _player;
@synthesize dealer = _dealer;
@synthesize totalPointsLabel = _totalPointsLabel;
@synthesize gameStatusLabel = _gameStatusLabel;
+ (CCScene *) scene {
    CCScene *scene = [CCScene node];
    GameLayer *layer = [GameLayer node];
    [scene addChild:layer];
    return scene;
}

- (id) init {
    if ((self = [super init])) {
        
        [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGB565];
        CGSize size = [[CCDirector sharedDirector] winSize];
        //add spriteBatchNode
        self.spriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"cards.png"];
        [self addChild:self.spriteBatchNode];
        
        //add sprites to frame cache
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"cards.plist"];
        
        //add background
        CCSprite *background = [CCSprite spriteWithSpriteFrameName:@"surface.png"];
        background.anchorPoint = ccp(0, 0);
        [self addChild:background z:-1];
        
        [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_Default];

        //create and randomize deck
        [self resetCardDeck];
        
        
        
        //create a player
        self.player = [[Player alloc] initWithLayer:self];
        
        //create totalPoints label
        self.totalPointsLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", self.player.totalPoints]
                                        fontName:@"Arial"
                                        fontSize:20
                                      dimensions:CGSizeMake(40, 40)
                                      hAlignment:UITextAlignmentCenter];
        self.totalPointsLabel.position = ccp(self.totalPointsLabel.contentSize.width / 2, size.height / 2 - (self.totalPointsLabel.contentSize.width / 2) * 0.7);
        [self addChild:self.totalPointsLabel];
        
        //create gameStatusLabel
        self.gameStatusLabel = [CCLabelTTF labelWithString:@"Hit or Stand?"
                                                   fontName:@"Arial"
                                                   fontSize:20
                                                 dimensions:CGSizeMake(200, 40)
                                                 hAlignment:UITextAlignmentCenter];
        self.gameStatusLabel.position = ccp(self.gameStatusLabel.contentSize.width / 2, size.height / 2);
        [self addChild:self.gameStatusLabel];
        
        //create a dealer
        self.dealer = [[Dealer alloc] initWithLayer:self];
        [self drawCardToDealer];
        
        //draw a card when beginning game
        [self drawCardToPlayer];
        
        //create a hit button
        CCMenuItem *hitButton = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"hitbutton.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"hitbutton.png"] target:self selector:@selector(drawCardFromButton:)];
        hitButton.position = ccp(hitButton.contentSize.width / 2, hitButton.contentSize.height / 2);
        
        //create a stand button
        CCMenuItem *standButton = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"standbutton.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"standbutton.png"] target:self selector:@selector(dealerTurn:)];
        standButton.position = ccp(standButton.contentSize.width / 2, hitButton.contentSize.height * 1.4);
        
        //create a nextGame button
        CCMenuItem *nextGameButton = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"replaybutton.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"replaybutton.png"] target:self selector:@selector(nextGame:)];
        nextGameButton.position = ccp(standButton.position.x, hitButton.contentSize.height * 2.5);
        
        //add buttons to menu
        CCMenu *menu = [CCMenu menuWithItems: hitButton, standButton, nextGameButton, nil];
        menu.position = CGPointZero;
        
        //add menu to main layer
        [self addChild:menu];
        
       
        //test with a card
//        CardObject *card = [self.cardDeck objectAtIndex:26];
//        NSLog(@"%f", card.sprite.position.x);
//        [self.spriteBatchNode addChild:card.sprite];
        [self scheduleUpdate];
    }
    return self;
}

- (void) nextGame: (id) sender {
    if (self.player.turnFinished && self.dealer.turnFinished) {
        [self.spriteBatchNode removeAllChildrenWithCleanup:YES];
        self.player.turnFinished = NO;
        self.player.busted = NO;
        self.dealer.turnFinished = NO;
        self.dealer.busted = NO;
        self.totalPointsLabel.string = @"0";
        [self.player.cardHands removeAllObjects];
        [self.dealer.cardHands removeAllObjects];
        [self resetCardDeck];
        [self drawCardToDealer];
        [self drawCardToPlayer];
    }
   
}

- (void) update:(ccTime)delta {
    
    BOOL playerFinished = self.player.turnFinished;
    BOOL dealerFinished = self.dealer.turnFinished;
    BOOL playerBusted = self.player.busted;
    BOOL dealerBusted = self.dealer.busted;
    
//determine current status of game
    if (playerFinished && dealerFinished) {
        if ((playerBusted && dealerBusted)) {
            self.gameStatusLabel.string = @"Tie!";
        } else if (playerBusted ) {
            self.gameStatusLabel.string = @"Player Lost...";
        } else if (dealerBusted) {
            self.gameStatusLabel.string = @"Player Won!";
        } else if (self.player.totalPoints == self.dealer.totalPoints) {
            self.gameStatusLabel.string = @"Tie!";
        } else if (self.player.totalPoints > self.dealer.totalPoints) {
            self.gameStatusLabel.string = @"Player Won!";
        } else if (self.player.totalPoints < self.dealer.totalPoints) {
            self.gameStatusLabel.string = @"Player Lost...";
        }
    
    } else self.gameStatusLabel.string = @"Hit or Stand?";
}

- (void) drawCardFromButton: (id)sender {
    [self drawCardToPlayer];
}

- (void) drawCardToDealer {
    //add card from deck to player's hand and remove it from deck
    if (self.dealer) {
        if ([self.dealer.cardHands count] < 5) {
            
            CardObject *card = [self.cardDeck lastObject];
            NSInteger x = card.position.x;
            NSInteger y = card.position.y * 3;
            [self.dealer.cardHands addObject:card];
            [self.cardDeck removeLastObject];
            NSInteger count = [self.dealer.cardHands count];
            
            
            if (count == 1) {
                card.position = ccp(x, y);
            }
            
            if (count > 1) {
                for (int i = 1; i < count; i++) {
                    NSInteger previousX = [[self.dealer.cardHands objectAtIndex:(count -2)] position].x;
                    if ([[self.dealer.cardHands objectAtIndex:i] position].x == previousX) {
                        previousX += card.sprite.contentSize.width * 1.1;
                        card.position = ccp(previousX, y);
                    }
                }
            }
            
            [self.spriteBatchNode addChild:card.sprite];
        }
    }
}

- (void) dealerTurn: (id)sender {
    //set player's turnFinished to YES
    self.player.turnFinished = YES;
    //dealer has to hit until 17
    while (self.dealer.totalPoints < 17) {
        [self drawCardToDealer];
    }
    //chances
    if (!self.dealer.turnFinished) {
        if (self.dealer.totalPoints < 22) {
            int probability = arc4random() % 100;
            BOOL a = probability < 10;
            BOOL b = probability < 3;
            if (self.dealer.totalPoints == 17) {
                if (a == YES) {
                    [self drawCardToDealer];
                }
            }
            if (self.dealer.totalPoints <= 20) {
                if (b == YES) {
                    [self drawCardToDealer];
                }
                
            }
        }
        if (self.dealer.totalPoints > 21) {
            self.dealer.turnFinished = YES;
            self.dealer.busted = YES;
        } else self.dealer.turnFinished = YES;
    }
}
    

- (void) drawCardToPlayer {
    //add card from deck to player's hand and remove it from deck
    if (self.cardDeck) {
        if (self.player) {
            
            NSInteger cardCount = [self.player.cardHands count];

            if ((cardCount < 8) && !(self.player.busted) && !(self.player.turnFinished) ) {
                
                CardObject *card = [self.cardDeck lastObject];
                [self.player.cardHands addObject:card];
                [self.cardDeck removeLastObject];
                NSInteger count = [self.player.cardHands count];
                
                //arrange cards
                for (int i = 0; i < count; i++) {
                    if (i == 0) {
                        card.position = ccp(card.position.x, card.position.y);
                    } else {
                        CGFloat x = [[self.player.cardHands objectAtIndex:(i - 1)] position].x;
                        if (card.position.x == x) {
                            card.position = ccp(card.position.x + card.sprite.contentSize.width * 1.1, card.position.y);
                        }
                    }
                }
                
                //self.player.totalPoints += card.cardValue;
                self.totalPointsLabel.string = [NSString stringWithFormat:@"%d", self.player.totalPoints];
                if (self.player.totalPoints > 21) {
                    
                    self.player.turnFinished = YES;
                    self.player.busted = YES;
                    [self performSelector:@selector(dealerTurn:) withObject:nil];
                }
                int cardSpriteTag = 99;
                
                [self.spriteBatchNode addChild:card.sprite z:0 tag:cardSpriteTag];
            }
        }
    }
}


- (void) resetCardDeck {
    if (self.cardDeck) {
        [self.cardDeck removeAllObjects];
    }
    self.cardDeck = [[NSMutableArray alloc] init];
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    //default card position for all cards in deck
    CGPoint cardPosition = ccp(size.width / 5, size.height / 4);
    
    //add clubs cards to cardDeck[0] - cardDeck[12]
    for (int i = 0; i < 13; i++) {
        CardObject *card = [[CardObject alloc] initWithLayer:self];
        card.cardNumber = i + 1;
        card.cardKind = @"Clubs";
        card.position = cardPosition;
        [self.cardDeck addObject:card];

    }
    //add hearts cards to cardDeck[13] - cardDeck[25]
    for (int i = 0; i < 13; i++) {
        CardObject *card = [[CardObject alloc] initWithLayer:self];
        card.cardNumber = i + 1;
        card.cardKind = @"Hearts";
        card.position = cardPosition;
        [self.cardDeck addObject:card];
    }
    //add diamonds cards to cardDeck[26] - cardDeck[38]
    for (int i = 0; i < 13; i++) {
        CardObject *card = [[CardObject alloc] initWithLayer:self];
        card.cardNumber = i + 1;
        card.cardKind = @"Diamonds";
        card.position = cardPosition;
        [self.cardDeck addObject:card];
    }
    //add spades cards to cardDeck[39] - cardDeck[51]
    for (int i = 0; i < 13; i++) {
        CardObject *card = [[CardObject alloc] initWithLayer:self];
        card.cardNumber = i + 1;
        card.cardKind = @"Spades";
        card.position = cardPosition;
        [self.cardDeck addObject:card];
    }
    //randomize the cardDeck
    NSUInteger cardCount = [self.cardDeck count];
    for (int i = 0; i < cardCount; i++) {
        NSInteger nElement = cardCount - i;
        NSInteger n = (arc4random() % nElement) + i;
        [self.cardDeck exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    
}

@end
