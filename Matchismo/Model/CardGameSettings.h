//
//  CardGameSettings.h
//  Matchismo
//
//  Created by Scott Rogers on 30/07/13.
//  Copyright (c) 2013 opensoda. All rights reserved.
//

#import <Foundation/Foundation.h>


#define MATCHCARDGAME_MATCHINGMODE_KEY @"Match_MatchingMode"
#define MATCHCARDGAME_MATCHBONUS_KEY @"Match_MatchBonus"
#define MATCHCARDGAME_MISMATCHPENALTY_KEY @"Match_MismatchPenalty"
#define MATCHCARDGAME_FLIPCOST_KEY @"Match_FlipCost"

#define SETCARDGAME_MATCHBONUS_KEY @"Set_MatchBonus"
#define SETCARDGAME_MISMATCHPENALTY_KEY @"Set_MismatchPenalty"
#define SETCARDGAME_FLIPCOST_KEY @"Set_FlipCost"

@interface CardGameSettings : NSObject

+ (void)restoreDefaultSettings;

+ (id)valueForKey:(NSString *)key;

+ (int)integerValueForKey:(NSString *)key;

+ (void)setValue:(id)value forKey:(NSString *)key;



@end
