//
//  CardMatchingGameResult.h
//  Matchismo
//
//  Created by Scott Rogers on 15/07/13.
//  Copyright (c) 2013 opensoda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardMatchingGameResult : NSObject

+ (NSArray *)allGameResults; // of GameResult

@property (readonly, nonatomic) NSDate *start;
@property (readonly, nonatomic) NSDate *end;
@property (readonly, nonatomic) NSTimeInterval duration;
@property (nonatomic) int score;
@property (nonatomic) NSString *gameType;

- (NSComparisonResult)compareByDate:(CardMatchingGameResult *)otherGameResult;
- (NSComparisonResult)compareByScore:(CardMatchingGameResult *)otherGameResult;
- (NSComparisonResult)compareByDuration:(CardMatchingGameResult *)otherGameResult;

@end

