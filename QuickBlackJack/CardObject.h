//
//  GameObject.h
//  QuickBlackJack
//
//  Created by Kayden Bui on 2/28/13.
//  Copyright (c) 2013 Kayden Bui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameLayer.h"

@interface CardObject : NSObject

@property (nonatomic, assign) NSInteger cardValue;
@property (nonatomic, assign) NSInteger cardNumber;
@property (nonatomic, unsafe_unretained) GameLayer *gameLayer;
@property (nonatomic) CGPoint position;
@property (nonatomic, strong) CCSprite *sprite;
@property (nonatomic, strong) NSString *cardKind;
//designated initializer
- (id) initWithLayer:(GameLayer *)layer;
- (NSInteger)cardKindLookUp:(NSString *)string;

@end
