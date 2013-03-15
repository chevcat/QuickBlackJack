//
//  AppDelegate.h
//  QuickBlackJack
//
//  Created by Kayden Bui on 2/28/13.
//  Copyright Kayden Bui 2013. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

#define kFiveDollarTag 0
#define kTwentyFiveDollarTag 1
#define kOneHunredDollarTag 2
#define kFiveHundredDollarTag 3
#define kDealButtonTag 4
#define kHitButtonTag 5
#define kStandButtonTag 6
#define kDoubleButtonTag 7
#define kOKButtonTag 8

// Added only for iOS 6 support
@interface MyNavigationController : UINavigationController <CCDirectorDelegate>
@end

@interface AppController : NSObject <UIApplicationDelegate>
{
	UIWindow *window_;
	MyNavigationController *navController_;
    
	CCDirectorIOS	*director_;							// weak ref
}

@property (nonatomic, retain) UIWindow *window;
@property (readonly) MyNavigationController *navController;
@property (readonly) CCDirectorIOS *director;

@end
