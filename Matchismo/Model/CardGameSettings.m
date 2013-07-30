//
//  CardGameSettings.m
//  Matchismo
//
//  Created by Scott Rogers on 30/07/13.
//  Copyright (c) 2013 opensoda. All rights reserved.
//

#import "CardGameSettings.h"

@implementation CardGameSettings

// Match Card Game default values
#define MATCHCARDGAME_DEFAULT_MATCHBONUS 4
#define MATCHCARDGAME_DEFAULT_MISMATCHPENALTY 2
#define MATCHCARDGAME_DEFAULT_FLIPCOST 1

// Set Card Game default values
#define SETCARDGAME_DEFAULT_MATCHBONUS 8
#define SETCARDGAME_DEFAULT_MISMATCHPENALTY 4
#define SETCARDGAME_DEFAULT_FLIPCOST 0

#define ALL_CARDGAMESETTINGS_KEY @"CardGameSettings_All"

+ (NSMutableDictionary *)allSettings {
    static NSMutableDictionary *allSettings = nil;
    if (!allSettings) {
        allSettings = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_CARDGAMESETTINGS_KEY] mutableCopy];
        if (!allSettings) {
            allSettings = [[NSMutableDictionary alloc] init];
        }
    }
    return allSettings;
}

+ (void)restoreDefaultSettings {
    [self allSettings][MATCHCARDGAME_MATCHBONUS_KEY] = @(MATCHCARDGAME_DEFAULT_MATCHBONUS);
    [self allSettings][MATCHCARDGAME_MISMATCHPENALTY_KEY] = @(MATCHCARDGAME_DEFAULT_MISMATCHPENALTY);
    [self allSettings][MATCHCARDGAME_FLIPCOST_KEY] = @(MATCHCARDGAME_DEFAULT_FLIPCOST);
    
    [self allSettings][SETCARDGAME_MATCHBONUS_KEY] = @(SETCARDGAME_DEFAULT_MATCHBONUS);
    [self allSettings][SETCARDGAME_MISMATCHPENALTY_KEY] = @(SETCARDGAME_DEFAULT_MISMATCHPENALTY);
    [self allSettings][SETCARDGAME_FLIPCOST_KEY] = @(SETCARDGAME_DEFAULT_FLIPCOST);
    
    [self synchronize];
}

+ (id)valueForKey:(NSString *)key {
    return [[self allSettings] valueForKey:key];
}

+ (int)integerValueForKey:(NSString *)key {
    int integerValue = 0;
    id value = [self valueForKey:key];
    if ([value isKindOfClass:[NSNumber class]]) {
        integerValue = [(NSNumber *)value intValue];
    }
    
    return integerValue;
}

+ (void)setValue:(id)value forKey:(NSString *)key {
    [self allSettings][key] = value;
    [self synchronize];
}

+ (void)synchronize {
    [[NSUserDefaults standardUserDefaults] setObject:[self allSettings] forKey:ALL_CARDGAMESETTINGS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}




@end
