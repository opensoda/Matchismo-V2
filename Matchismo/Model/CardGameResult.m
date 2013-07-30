//
//  CardGameResult.m
//  Matchismo
//
//  Created by Scott Rogers on 15/07/13.
//  Copyright (c) 2013 opensoda. All rights reserved.
//

#import "CardGameResult.h"

@interface CardGameResult()
@property (readwrite, nonatomic) NSDate *start;
@property (readwrite, nonatomic) NSDate *end;
@end

@implementation CardGameResult

#define ALL_RESULTS_KEY @"GameResults_All"
#define START_KEY @"StartDate"
#define END_KEY @"EndDate"
#define SCORE_KEY @"Score"
#define GAME_TYPE_KEY @"GameType"

+ (NSArray *)cardGameResults {
    NSMutableArray *cardGameResults = [[NSMutableArray alloc] init];
    
    for (id plist in [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY] allValues]) {
        CardGameResult  *cardGameResult = [[CardGameResult alloc] initFromPropertyList:plist];
        [cardGameResults addObject:cardGameResult];
    }
    
    return cardGameResults;
}

+ (void)deleteCardGameResults
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:ALL_RESULTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


// convenience initializer
- (id)initFromPropertyList:(id)plist {
    self = [self init];
    if (self) {
        if ([plist isKindOfClass:[NSDictionary class]]) {
            NSDictionary *cardGameResultDictionary = (NSDictionary *)plist;
            _start = cardGameResultDictionary[START_KEY];
            _end = cardGameResultDictionary[END_KEY];
            _score = [cardGameResultDictionary[SCORE_KEY] intValue];
            _gameType = cardGameResultDictionary[GAME_TYPE_KEY];
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
    NSMutableDictionary *mutableCardGameResultsFromUserDefaults = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY] mutableCopy];
    if (!mutableCardGameResultsFromUserDefaults) mutableCardGameResultsFromUserDefaults = [[NSMutableDictionary alloc] init];
    
    mutableCardGameResultsFromUserDefaults[[self.start description]] = [self asPropertyList];
    
    [[NSUserDefaults standardUserDefaults] setObject:mutableCardGameResultsFromUserDefaults forKey:ALL_RESULTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (id)asPropertyList {
    return @{ START_KEY : self.start, END_KEY : self.end, SCORE_KEY : @(self.score), GAME_TYPE_KEY : self.gameType };
}

- (NSComparisonResult)compareByDate:(CardGameResult *)otherCardGameResult {
    return [otherCardGameResult.end compare:self.end]; // reverse chronological order
}
- (NSComparisonResult)compareByScore:(CardGameResult *)otherCardGameResult {
    return [@(otherCardGameResult.score) compare:@(self.score)]; // descending order
}
- (NSComparisonResult)compareByDuration:(CardGameResult *)otherCardGameResult {
    return [@(self.duration) compare:@(otherCardGameResult.duration)]; // ascending order
}


@end
