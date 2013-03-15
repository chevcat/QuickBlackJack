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
@synthesize okButton = _okButton;
@synthesize doubleButton = _doubleButton;
@synthesize splitButton = _splitButton;
@synthesize betMenu = _betMenu;

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
        
        //create a deal button
        self.dealButton = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"dealbutton.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"dealbutton.png"] target:self selector:@selector(dealButtonPressed:)];
        self.dealButton.position = ccp(self.dealButton.contentSize.width / 2, self.dealButton.contentSize.height / 2);
        
        
        
        //create a hit button
        self.hitButton = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"hitbutton.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"hitbutton.png"] target:self selector:@selector(hitButtonPressed:)];
        self.hitButton.position = ccp(self.hitButton.contentSize.width / 2, self.hitButton.contentSize.height / 2);
        self.hitButton.tag = 
        
        //create a stand button
        self.standButton = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"standbutton.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"standbutton.png"] target:self selector:@selector(dealerTurn:)];
        self.standButton.position = ccp(self.standButton.contentSize.width / 2, self.hitButton.position.y + self.standButton.contentSize.height + 5);
        
        //create a double button
        self.doubleButton = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"doublebutton.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"doublebutton.png"] target:self selector:@selector(doubleButtonPressed:)];
        self.doubleButton.position = ccp(self.doubleButton.contentSize.width / 2, self.standButton.position.y + self.doubleButton.contentSize.height + 5);
        
        //create a nextGame button
        self.okButton = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"replaybutton.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"replaybutton.png"] target:self selector:@selector(okButtonPressed:)];
        self.okButton.position = ccp(self.okButton.contentSize.width / 2, self.doubleButton.position.y + self.okButton.contentSize.height + 5);
        
        //
        self.splitButton = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"splitbutton.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"splitbutton.png"] target:self selector:@selector(splitButtonPressed:)];
        self.splitButton.position = ccp(self.okButton.position.x, self.okButton.position.y);
        
        //create a fiveDollar button
        CCMenuItem *fiveDollarButton = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"5dollar.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"5dollar.png"] target:self selector:@selector(bettingButtonPressed:)];
        fiveDollarButton.position = ccp(size.width - fiveDollarButton.contentSize.width / 2, size.height - fiveDollarButton.contentSize.height * 4);
        fiveDollarButton.tag = kFiveDollarTag;
        
        //create a twentyFiveDollar button
        CCMenuItem *twentyFiveDollarButton = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"25dollar.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"25dollar.png"] target:self selector:@selector(bettingButtonPressed:)];
        twentyFiveDollarButton.position = ccp(fiveDollarButton.position.x, fiveDollarButton.position.y - twentyFiveDollarButton.contentSize.height - 5);
        twentyFiveDollarButton.tag = kTwentyFiveDollarTag;
        
        //create a oneHundredDollar button
        CCMenuItem *oneHundredDollarButton = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"100dollar.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"100dollar.png"] target:self selector:@selector(bettingButtonPressed:)];
        oneHundredDollarButton.position = ccp(twentyFiveDollarButton.position.x, twentyFiveDollarButton.position.y - oneHundredDollarButton.contentSize.height - 5);
        oneHundredDollarButton.tag = kOneHunredDollarTag;
        
        //create a fiveHundredDollar button
        CCMenuItem *fiveHundredDollarButton = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"500dollar.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"500dollar.png"] target:self selector:@selector(bettingButtonPressed:)];
        fiveHundredDollarButton.position = ccp(oneHundredDollarButton.position.x, oneHundredDollarButton.position.y - fiveHundredDollarButton.contentSize.height - 5);
        fiveHundredDollarButton.tag = kFiveHundredDollarTag;
        
        //add buttons to menu
        CCMenu *menu = [CCMenu menuWithItems: self.dealButton, self.hitButton, self.standButton, self.okButton, self.doubleButton, self.splitButton,  nil];
        menu.position = CGPointZero;
        self.betMenu = [CCMenu menuWithItems:fiveDollarButton, twentyFiveDollarButton, oneHundredDollarButton, fiveHundredDollarButton, nil];
        self.betMenu.position = CGPointZero;
        
        
        //add menu to main layer
        [self addChild:menu];
        [self addChild:self.betMenu];
        
        [self resetCardDeck];
        
        [self disableButton:self.hitButton];
        [self disableButton:self.standButton];
        [self disableButton:self.okButton];
        [self disableButton:self.dealButton];
        [self disableButton:self.doubleButton];
        [self disableButton:self.splitButton];
        
        //create totalPoints label
        self.totalPointsLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", self.player.totalPoints]
                                                   fontName:@"Arial"
                                                   fontSize:20
                                                 dimensions:CGSizeMake(40, 40)
                                                 hAlignment:UITextAlignmentCenter];
        self.totalPointsLabel.position = ccp(self.okButton.contentSize.width / 2, self.okButton.position.y + self.okButton.contentSize.height * 2);
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
        self.totalDealerPointsLabel.position = ccp(size.width - 50, size.height - 50);
        [self addChild:self.totalDealerPointsLabel];
        
        //create gameStatusLabel
        self.gameStatusLabel = [CCLabelTTF labelWithString:@"Hit or Stand?"
                                                  fontName:@"Arial"
                                                  fontSize:20
                                                dimensions:CGSizeMake(200, 40)
                                                hAlignment:UITextAlignmentCenter];
        self.gameStatusLabel.position = ccp(self.totalPointsLabel.position.x + 100, self.totalPointsLabel.position.y);
        [self addChild:self.gameStatusLabel];
        
        [self scheduleUpdate];
    }
    return self;
}

- (void)splitButtonPressed:(id)sender {
    
}

- (void)disableButton:(CCMenuItem *)button {
    [button setIsEnabled:NO];
    [button setVisible:NO];
}

- (void)enableButton:(CCMenuItem *)button {
    [button setIsEnabled:YES];
    [button setVisible:YES];
}

- (void)bettingButtonPressed:(id)sender {
    CCMenuItem *betButton = (CCMenuItem *)sender;
    NSInteger tag = betButton.tag;
    if (tag == kFiveDollarTag) {
        if (self.player.fund >= 5) {
            self.player.fund -= 5;
            self.betPot +=5;
            [self enableButton:self.dealButton];
        }
    }
    if (tag == kTwentyFiveDollarTag) {
        if (self.player.fund >= 25) {
            self.player.fund -= 25;
            self.betPot +=25;
            [self enableButton:self.dealButton];
        }
    }
    if (tag == kOneHunredDollarTag) {
        if (self.player.fund >= 100) {
            self.player.fund -= 100;
            self.betPot += 100;
            [self enableButton:self.dealButton];
        }
    }
    if (tag == kFiveHundredDollarTag) {
        if (self.player.fund >= 500) {
            self.player.fund -= 500;
            self.betPot += 500;
            [self enableButton:self.dealButton];
        }
    }
}

- (void)dealButtonPressed:(id)sender {
    [self.betMenu setEnabled:NO];
    [self disableButton:self.dealButton];
    [self enableButton:self.hitButton];
    [self enableButton:self.standButton];
    [self enableButton:self.doubleButton];
    [self inGame];
}

- (void)inGame {
    [self.player drawCard];
    [self.dealer drawCard];
    [self.player drawCard];
    [self.dealer drawCard];
    if (self.dealer.totalPoints == 21 || self.player.totalPoints == 21) {
            self.player.turnFinished = YES;
            self.dealer.turnFinished = YES;
            [self endGame];
    }
    CardObject *card1 = [self.player.cardHands objectAtIndex:0];
    CardObject *card2 = [self.player.cardHands objectAtIndex:1];
    if (card1.cardValue == card2.cardValue || card1.cardNumber == card2.cardNumber) {
        [self enableButton:self.splitButton];
    }
}

- (void) hitButtonPressed: (id)sender {
    [self.player drawCard];
    
}

- (void) doubleButtonPressed: (id)sender {
    if (self.player.fund >= self.betPot) {
        [self.doubleButton setIsEnabled:NO];
        self.player.fund -= self.betPot;
        self.betPot = self.betPot * 2;
        [self performSelector:@selector(hitButtonPressed:) withObject:nil];
        [self performSelector:@selector(dealerTurn:) withObject:nil];
    }
}

- (void) dealerTurn: (id)sender {
    //set player's turnFinished to YES
    self.player.turnFinished = YES;
    
    if (self.player.busted) {
        self.dealer.turnFinished = YES;
    }
    //dealer has to hit until 16
    
    else {
        
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
    [self endGame];
}

- (void) endGame {
    [self enableButton:self.okButton];
    [self disableButton:self.hitButton];
    [self disableButton:self.standButton];
    [self disableButton:self.doubleButton];
}



- (void)okButtonPressed:(id)sender {
    self.player.turnFinished = NO;
    self.player.busted = NO;
    self.dealer.turnFinished = NO;
    self.dealer.busted = NO;
    self.dealer.containsAce = NO;
    [self disableButton:self.okButton];
    [self.spriteBatchNode removeAllChildrenWithCleanup:YES];
    [self.player.cardHands removeAllObjects];
    [self.dealer.cardHands removeAllObjects];
    self.totalPointsLabel.string = @"0";
    self.totalDealerPointsLabel.string = @"0";
    [self resetCardDeck];
    [self.betMenu setEnabled:YES];
    if (self.player.fund < 5 && self.betPot == 0) {
        [self extendFund];
    }
}

- (void)extendFund {
    UIAlertView *alert = [[UIAlertView alloc] init];
    [alert setDelegate:self];
    [alert setTitle:@"Good news"];
    [alert setMessage:@"The casino decided to give you an extra $5000 to play. Have fun :)"];
    [alert addButtonWithTitle:@"Thanks"];
    [alert show];
}

-(void) alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        self.player.fund = 5000;
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    }
}

- (void) update:(ccTime)delta {
    self.playerFundLabel.string = [NSString stringWithFormat:@"Fund: %d", self.player.fund];
    self.betPotLabel.string = [NSString stringWithFormat:@"Bet: %d", self.betPot];
    
    BOOL playerFinished = self.player.turnFinished;
    BOOL dealerFinished = self.dealer.turnFinished;
    BOOL playerBusted = self.player.busted;
    BOOL dealerBusted = self.dealer.busted;
    
    //determine current status of game
    if (playerFinished && dealerFinished) {
        if (playerBusted) {
            self.gameStatusLabel.string = @"Player Lost...";
            self.betPot = 0;
        } else if (dealerBusted) {
            self.gameStatusLabel.string = @"Player Won!";
            self.player.fund += self.betPot * 2;
            self.betPot = 0;
        } else if (self.player.totalPoints == self.dealer.totalPoints) {
            self.gameStatusLabel.string = @"Push";
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

- (void) resetCardDeck {
    if (self.cardDeck) {
        [self.cardDeck removeAllObjects];
    }
    self.cardDeck = [[NSMutableArray alloc] init];
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    //default card position for all cards in deck
    CGPoint cardPosition = ccp(size.width / 3, size.height / 4);
    
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