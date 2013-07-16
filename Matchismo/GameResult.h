//
//  GameResult.h
//  Matchismo
//
//  Created by Scott Rogers on 15/07/13.
//  Copyright (c) 2013 opensoda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameResult : NSObject

+ (NSArray *)allGameResults; // of GameResult

@property (readonly, nonatomic) NSDate *start;
@property (readonly, nonatomic) NSDate *end;
@property (readonly, nonatomic) NSTimeInterval duration;
@property (nonatomic) int score;

- (NSComparisonResult)compareByDate:(GameResult *)otherGameResult;
- (NSComparisonResult)compareByScore:(GameResult *)otherGameResult;
- (NSComparisonResult)compareByDuration:(GameResult *)otherGameResult;

@end

