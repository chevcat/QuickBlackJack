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
@synthesize totalDealerPointsLabel = _totalDealerPointsLabel;
@synthesize gameStatusLabel = _gameStatusLabel;
@synthesize playerFundLabel = _playerFundLabel;
@synthesize betPot = _betPot;
@synthesize betPotLabel = _betPotLabel;
@synthesize hitButton = _hitButton;
@synthesize standButton = _standButton;
@synthesize nextGameButton = _nextGameButton;

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
        
        
        
        //initiate bet pot
        self.betPot = 0;
        
        //create a player
        self.player = [[Player alloc] initWithLayer:self];
        
        //create a dealer
        self.dealer = [[Dealer alloc] initWithLayer:self];
        
        //create a hit button
        self.hitButton = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"hitbutton.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"hitbutton.png"] target:self selector:@selector(hitButtonPressed:)];
        self.hitButton.position = ccp(self.hitButton.contentSize.width / 2, self.hitButton.contentSize.height / 2);
        
        
        //create a stand button
        self.standButton = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"standbutton.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"standbutton.png"] target:self selector:@selector(dealerTurn:)];
        self.standButton.position = ccp(self.standButton.contentSize.width / 2, self.hitButton.contentSize.height * 1.4);
        
        //create a nextGame button
        self.nextGameButton = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"replaybutton.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"replaybutton.png"] target:self selector:@selector(nextGame:)];
        self.nextGameButton.position = ccp(self.standButton.position.x, self.hitButton.contentSize.height * 2.5);
        
        //create a fiveDollar button
        CCMenuItem *fiveDollarButton = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"5dollar.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"5dollar.png"] target:self selector:@selector(fiveDollarPressed:)];
        fiveDollarButton.position = ccp(size.width / 2.3, size.height / 2);
        
        //create a twentyFiveDollar button
        CCMenuItem *twentyFiveDollarButton = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"25dollar.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"25dollar.png"] target:self selector:@selector(twentyFiveDollarPressed:)];
        twentyFiveDollarButton.position = ccp(fiveDollarButton.position.x + twentyFiveDollarButton.contentSize.width + 10, fiveDollarButton.position.y);
        
        //create a oneHundredDollar button
        CCMenuItem *oneHundredDollarButton = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"100dollar.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"100dollar.png"] target:self selector:@selector(oneHundredDollarPressed:)];
        oneHundredDollarButton.position = ccp(twentyFiveDollarButton.position.x + oneHundredDollarButton.contentSize.width + 10, fiveDollarButton.position.y);
        
        //create a fiveHundredDollar button
        CCMenuItem *fiveHundredDollarButton = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"500dollar.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"500dollar.png"] target:self selector:@selector(fiveHundredDollarPressed:)];
        fiveHundredDollarButton.position = ccp(oneHundredDollarButton.position.x + fiveHundredDollarButton.contentSize.width + 10, fiveDollarButton.position.y);
        
        //add buttons to menu
        CCMenu *menu = [CCMenu menuWithItems: self.hitButton, self.standButton, self.nextGameButton, fiveDollarButton, twentyFiveDollarButton, oneHundredDollarButton, fiveHundredDollarButton, nil];
        menu.position = CGPointZero;
        
        //add menu to main layer
        [self addChild:menu];
        
        //begin the game
        [self performSelector:@selector(nextGame:) withObject:nil];
        
        //create totalPoints label
        self.totalPointsLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", self.player.totalPoints]
                                        fontName:@"Arial"
                                        fontSize:20
                                      dimensions:CGSizeMake(40, 40)
                                      hAlignment:UITextAlignmentCenter];
        self.totalPointsLabel.position = ccp(self.totalPointsLabel.contentSize.width / 2, size.height / 2 - (self.totalPointsLabel.contentSize.height / 2) * 0.7);
        [self addChild:self.totalPointsLabel];
        
        //create playerFund label
        self.playerFundLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Fund: %d", self.player.fund]
                                                   fontName:@"Arial"
                                                   fontSize:20
                                                 dimensions:CGSizeMake(120, 40)
                                                 hAlignment:UITextAlignmentCenter];
        self.playerFundLabel.position = ccp(size.width - self.playerFundLabel.contentSize.width / 2, self.playerFundLabel.contentSize.height / 2);
        [self addChild:self.playerFundLabel];
        
        //create playerFund label
        self.betPotLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Bet: %d", self.betPot]
                                                  fontName:@"Arial"
                                                  fontSize:20
                                                dimensions:CGSizeMake(120, 40)
                                                hAlignment:UITextAlignmentCenter];
        self.betPotLabel.position = ccp(size.width - self.betPotLabel.contentSize.width / 2, self.playerFundLabel.position.y + self.betPotLabel.contentSize.height / 2 + 10);
        [self addChild:self.betPotLabel];
        
        //create totalDealerPoints label
        self.totalDealerPointsLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", self.dealer.totalPoints]
                                                   fontName:@"Arial"
                                                   fontSize:20
                                                 dimensions:CGSizeMake(40, 40)
                                                 hAlignment:UITextAlignmentCenter];
        self.totalDealerPointsLabel.position = ccp(size.width - self.totalDealerPointsLabel.contentSize.width / 2, size.height / 2 - (self.totalDealerPointsLabel.contentSize.height / 2) * 0.7);
        [self addChild:self.totalDealerPointsLabel];
        
        //create gameStatusLabel
        self.gameStatusLabel = [CCLabelTTF labelWithString:@"Hit or Stand?"
                                                   fontName:@"Arial"
                                                   fontSize:20
                                                 dimensions:CGSizeMake(200, 40)
                                                 hAlignment:UITextAlignmentCenter];
        self.gameStatusLabel.position = ccp(self.gameStatusLabel.contentSize.width / 2, size.height / 2);
        [self addChild:self.gameStatusLabel];
        
       
        
       
        //test with a card
//        CardObject *card = [self.cardDeck objectAtIndex:26];
//        NSLog(@"%f", card.sprite.position.x);
//        [self.spriteBatchNode addChild:card.sprite];
        [self scheduleUpdate];
    }
    return self;
}

- (void)fiveDollarPressed:(id)sender {
    if (self.player.fund >= 5) {
        self.player.fund -= 5;
        self.betPot +=5;
    }
    
}

- (void)twentyFiveDollarPressed:(id)sender {
    if (self.player.fund >= 25) {
        self.player.fund -= 25;
        self.betPot +=25;
    }
}

- (void)oneHundredDollarPressed:(id)sender {
    if (self.player.fund >= 100) {
        self.player.fund -= 100;
        self.betPot += 100;
    }
}

- (void)fiveHundredDollarPressed:(id)sender {
    if (self.player.fund >= 500) {
        self.player.fund -= 500;
        self.betPot += 500;
    }
}

- (void)nextGame:(id)sender {
        [self.spriteBatchNode removeAllChildrenWithCleanup:YES];
        self.player.turnFinished = NO;
        self.player.busted = NO;
        self.dealer.turnFinished = NO;
        self.dealer.busted = NO;
        self.dealer.containsAce = NO;
        [self.nextGameButton setIsEnabled:NO];
        [self.player.cardHands removeAllObjects];
        [self.dealer.cardHands removeAllObjects];
        [self resetCardDeck];
        [self.player drawCard];
        [self.dealer drawCard];
        [self.player drawCard];
        [self.dealer drawCard];
   
}

- (void) update:(ccTime)delta {
    if (self.player.turnFinished && self.dealer.turnFinished) {
        [self.nextGameButton setIsEnabled:YES];
    }
    
    self.playerFundLabel.string = [NSString stringWithFormat:@"Fund: %d", self.player.fund];
    self.betPotLabel.string = [NSString stringWithFormat:@"Bet: %d", self.betPot];
    
    BOOL playerFinished = self.player.turnFinished;
    BOOL dealerFinished = self.dealer.turnFinished;
    BOOL playerBusted = self.player.busted;
    BOOL dealerBusted = self.dealer.busted;
    
//determine current status of game
    if (playerFinished && dealerFinished) {
        if ((playerBusted && dealerBusted)) {
            self.gameStatusLabel.string = @"Tie!";
            self.player.fund += self.betPot;
            self.betPot = 0;
        } else if (playerBusted ) {
            self.gameStatusLabel.string = @"Player Lost...";
            self.betPot = 0;
        } else if (dealerBusted) {
            self.gameStatusLabel.string = @"Player Won!";
            self.player.fund += self.betPot * 2;
            self.betPot = 0;
        } else if (self.player.totalPoints == self.dealer.totalPoints) {
            self.gameStatusLabel.string = @"Tie!";
            self.player.fund += self.betPot;
            self.betPot = 0;
        } else if (self.player.totalPoints > self.dealer.totalPoints) {
            self.gameStatusLabel.string = @"Player Won!";
            self.player.fund += self.betPot * 2;
            self.betPot = 0;
        } else if (self.player.totalPoints < self.dealer.totalPoints) {
            self.gameStatusLabel.string = @"Player Lost...";
            self.betPot = 0;
        }
    
    } else self.gameStatusLabel.string = @"Hit or Stand?";
}

- (void) hitButtonPressed: (id)sender {
    [self.player drawCard];
}



- (void) dealerTurn: (id)sender {
    //set player's turnFinished to YES
    self.player.turnFinished = YES;
    //dealer has to hit until 16
    
    while (self.dealer.totalPoints < 16 || (self.dealer.totalPoints == 17 && self.dealer.containsAce == YES)) {
        [self.dealer drawCard];
    }
    //chances
    if (!self.dealer.turnFinished) {
        if (self.dealer.totalPoints < 22) {
            int probability = arc4random() % 100;
            
            BOOL a = (probability < 20) && (probability >=10);
            BOOL b = probability < 3;
            
            if (self.dealer.totalPoints == 17) {
                if (a == YES) {
                    [self.dealer drawCard];
                }
            }
            if (self.dealer.totalPoints <= 20) {
                if (b == YES) {
                    [self.dealer drawCard];
                }
                
            }
        }
        if (self.dealer.totalPoints > 21) {
            self.dealer.turnFinished = YES;
            self.dealer.busted = YES;
        } else self.dealer.turnFinished = YES;
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
