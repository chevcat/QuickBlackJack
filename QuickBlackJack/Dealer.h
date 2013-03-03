//
//  Dealer.h
//  QuickBlackJack
//
//  Created by Kayden Bui on 3/1/13.
//  Copyright (c) 2013 Kayden Bui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameLayer.h"
@interface Dealer : NSObject

@property (nonatomic, strong) NSMutableArray *cardHands;
@property (nonatomic, weak) GameLayer *layer;
@property (nonatomic, assign) NSInteger totalPoints;
@property (nonatomic, assign) BOOL busted;
@property (nonatomic, assign) BOOL turnFinished;
//designated initializer
- (id) initWithLayer:(GameLayer *)layer;
- (void) drawCard;

@end
