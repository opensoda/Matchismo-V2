//
//  CardMatchingGameResult.m
//  Matchismo
//
//  Created by Scott Rogers on 15/07/13.
//  Copyright (c) 2013 opensoda. All rights reserved.
//

#import "CardMatchingGameResult.h"

@interface CardMatchingGameResult()
@property (readwrite, nonatomic) NSDate *start;
@property (readwrite, nonatomic) NSDate *end;
@end

@implementation CardMatchingGameResult

#define ALL_RESULTS_KEY @"GameResults_All"
#define START_KEY @"StartDate"
#define END_KEY @"EndDate"
#define SCORE_KEY @"Score"
#define GAME_TYPE_KEY @"GameType"

+ (NSArray *)allGameResults {
    NSMutableArray *allGameResults = [[NSMutableArray alloc] init];
    
    for (id plist in [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY] allValues]) {
        CardMatchingGameResult  *gameResult = [[CardMatchingGameResult alloc] initFromPropertyList:plist];
        [allGameResults addObject:gameResult];
    }
    
    return allGameResults;
}

// convenience initializer
- (id)initFromPropertyList:(id)plist {
    self = [self init];
    if (self) {
        if ([plist isKindOfClass:[NSDictionary class]]) {
            NSDictionary *gameResultDictionary = (NSDictionary *)plist;
            _start = gameResultDictionary[START_KEY];
            _end = gameResultDictionary[END_KEY];
            _score = [gameResultDictionary[SCORE_KEY] intValue];
            _gameType = gameResultDictionary[GAME_TYPE_KEY];
            if (!_start || !_end) self = nil;
        }
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        _start = [NSDate date];
        _end = _start;
    }
    return self;
}

- (NSTimeInterval)duration {
    return [self.end timeIntervalSinceDate:self.start];
}

- (void)setScore:(int)score {
    _score = score;
    self.end = [NSDate date];
    [self synchronize];
}

- (void)synchronize {
    NSMutableDictionary *mutableGameResultsFromUserDefaults = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY] mutableCopy];
    if (!mutableGameResultsFromUserDefaults) mutableGameResultsFromUserDefaults = [[NSMutableDictionary alloc] init];
    
    mutableGameResultsFromUserDefaults[[self.start description]] = [self asPropertyList];
    
    [[NSUserDefaults standardUserDefaults] setObject:mutableGameResultsFromUserDefaults forKey:ALL_RESULTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (id)asPropertyList {
    return @{ START_KEY : self.start, END_KEY : self.end, SCORE_KEY : @(self.score), GAME_TYPE_KEY : self.gameType };
}

- (NSComparisonResult)compareByDate:(CardMatchingGameResult *)otherGameResult {
    return [otherGameResult.end compare:self.end]; // reverse chronological order
}
- (NSComparisonResult)compareByScore:(CardMatchingGameResult *)otherGameResult {
    return [@(otherGameResult.score) compare:@(self.score)]; // descending order
}
- (NSComparisonResult)compareByDuration:(CardMatchingGameResult *)otherGameResult {
    return [@(self.duration) compare:@(otherGameResult.duration)]; // ascending order
}


@end
