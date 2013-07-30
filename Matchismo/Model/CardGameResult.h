//
//  CardGameResult.h
//  Matchismo
//
//  Created by Scott Rogers on 15/07/13.
//  Copyright (c) 2013 opensoda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardGameResult : NSObject

+ (NSArray *)cardGameResults;
+ (void)deleteCardGameResults;

@property (readonly, nonatomic) NSDate *start;
@property (readonly, nonatomic) NSDate *end;
@property (readonly, nonatomic) NSTimeInterval duration;
@property (nonatomic) int score;
@property (nonatomic) NSString *gameType;

- (NSComparisonResult)compareByDate:(CardGameResult *)otherCardGameResult;
- (NSComparisonResult)compareByScore:(CardGameResult *)otherCardGameResult;
- (NSComparisonResult)compareByDuration:(CardGameResult *)otherCardGameResult;

@end

