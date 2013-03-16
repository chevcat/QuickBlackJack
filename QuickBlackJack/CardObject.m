//
//  GameObject.m
//  QuickBlackJack
//
//  Created by Kayden Bui on 2/28/13.
//  Copyright (c) 2013 Kayden Bui. All rights reserved.
//

#import "CardObject.h"

@implementation CardObject
@synthesize gameLayer = _gameLayer;
@synthesize position = _position;
@synthesize sprite = _sprite;
@synthesize cardKind = _cardKind;
@synthesize cardValue = _cardValue;
@synthesize cardNumber = _cardNumber;

- (id) initWithLayer:(GameLayer *)layer {
    if ((self = [super init])) {
        self.gameLayer = layer;
    }
    return self;
}

//set CardObject along with its sprite's position
- (void)setPosition:(CGPoint)position {
    _position = position;
    self.sprite.position = position;
}

- (void)setPlainPosition:(CGPoint)position {
    _position = position;
}

- (void)setCardNumber:(NSInteger)cardNumber {
    _cardNumber = cardNumber;
    if (cardNumber <= 10 && cardNumber >0) {
        self.cardValue = cardNumber;
    } else if (cardNumber >10 && cardNumber <14) {
        self.cardValue = 10;
    } else NSLog(@"invalid cardNumber");
}

- (void) setCardKind:(NSString *)cardKind {
    //set cardKind
    _cardKind = cardKind;
    
    //set card sprite based on cardKind
    //convert cardKind to int for switch statement
    int number = [self cardKindLookUp:cardKind];
    switch (number) {
        case 1:
            self.sprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%d-clubs.png", self.cardNumber]];
            break;
        case 2:
            self.sprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%d-diamonds.png", self.cardNumber]];
            break;
        case 3:
            self.sprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%d-hearts.png", self.cardNumber]];
            break;
        case 4:
            self.sprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%d-spades.png", self.cardNumber]];
            break;
        default: NSLog(@"card name invalid");
            break;
    }
}

//helper method
//convert a cardKind to its corresponding int value
- (int)cardKindLookUp:(NSString *)string {
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1], @"Clubs",
                                [NSNumber numberWithInt:2], @"Diamonds",
                                [NSNumber numberWithInt:3], @"Hearts",
                                [NSNumber numberWithInt:4], @"Spades", nil];
    NSNumber *number = [dictionary valueForKey:string];
    return [number intValue];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%d of %@", self.cardNumber, self.cardKind];
}
@end
