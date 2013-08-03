//
//  SettingsViewController.m
//  Matchismo
//
//  Created by Scott Rogers on 18/07/13.
//  Copyright (c) 2013 opensoda. All rights reserved.
//

#import "SettingsViewController.h"
#import "CardGameResult.h"
#import "CardGameSettings.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *matchMatchingModeLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchMatchBonusLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchMismatchPenaltyLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchFlipCostLabel;
@property (weak, nonatomic) IBOutlet UILabel *setMatchBonusLabel;
@property (weak, nonatomic) IBOutlet UILabel *setMismatchPenaltyLabel;
@property (weak, nonatomic) IBOutlet UILabel *setFlipCostLabel;  // not in UI

@property (weak, nonatomic) IBOutlet UIStepper *matchMatchingMode;
@property (weak, nonatomic) IBOutlet UIStepper *matchMatchBonus;
@property (weak, nonatomic) IBOutlet UIStepper *matchMismatchPenalty;
@property (weak, nonatomic) IBOutlet UIStepper *matchFlipCost;
@property (weak, nonatomic) IBOutlet UIStepper *setMatchBonus;
@property (weak, nonatomic) IBOutlet UIStepper *setMismatchPenalty;
@property (weak, nonatomic) IBOutlet UIStepper *setFlipCost; // not in UI

- (IBAction)matchMatchingMode:(UIStepper *)sender;
- (IBAction)matchMatchBonus:(UIStepper *)sender;
- (IBAction)matchMismatchPenalty:(UIStepper *)sender;
- (IBAction)matchFlipCost:(UIStepper *)sender;
- (IBAction)setMatchBonus:(UIStepper *)sender;
- (IBAction)setMismatchPenalty:(UIStepper *)sender;
- (IBAction)setFlipCost:(UIStepper *)sender;  // not in UI

- (IBAction)deleteAllScores:(UIButton *)sender;
- (IBAction)restoreDefaultSettings:(UIButton *)sender;

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateUI];
}

- (void)updateUI {
    
     // update stepper values and labels
    self.matchMatchingMode.value = [CardGameSettings integerValueForKey:MATCHCARDGAME_MATCHINGMODE_KEY];
    self.matchMatchBonus.value = [CardGameSettings integerValueForKey:MATCHCARDGAME_MATCHBONUS_KEY];
    self.matchMismatchPenalty.value = [CardGameSettings integerValueForKey:MATCHCARDGAME_MISMATCHPENALTY_KEY];
    self.matchFlipCost.value = [CardGameSettings integerValueForKey:MATCHCARDGAME_FLIPCOST_KEY];
    
    self.matchMatchingModeLabel.text = [NSString stringWithFormat:@"%@", @(self.matchMatchingMode.value)];
    self.matchMatchBonusLabel.text = [NSString stringWithFormat:@"%@", @(self.matchMatchBonus.value)];
    self.matchMismatchPenaltyLabel.text = [NSString stringWithFormat:@"%@", @(self.matchMismatchPenalty.value)];
    self.matchFlipCostLabel.text = [NSString stringWithFormat:@"%@",  @(self.matchFlipCost.value)];
    
    self.setMatchBonus.value = [CardGameSettings integerValueForKey:SETCARDGAME_MATCHBONUS_KEY];
    self.setMismatchPenalty.value = [CardGameSettings integerValueForKey:SETCARDGAME_MISMATCHPENALTY_KEY];
    self.setFlipCost.value = [CardGameSettings integerValueForKey:SETCARDGAME_FLIPCOST_KEY];
    
    self.setMatchBonusLabel.text = [NSString stringWithFormat:@"%@",  @(self.setMatchBonus.value)];
    self.setMismatchPenaltyLabel.text = [NSString stringWithFormat:@"%@", @(self.setMismatchPenalty.value)];
    self.setFlipCostLabel.text = [NSString stringWithFormat:@"%@", @(self.setFlipCost.value)];
}

- (IBAction)matchMatchingMode:(UIStepper *)sender {
    [CardGameSettings setValue:@(sender.value) forKey:MATCHCARDGAME_MATCHINGMODE_KEY];
    [self updateUI];
}

- (IBAction)matchMatchBonus:(UIStepper *)sender {
    [CardGameSettings setValue:@(sender.value) forKey:MATCHCARDGAME_MATCHBONUS_KEY];
    [self updateUI];
}

- (IBAction)matchMismatchPenalty:(UIStepper *)sender {
    [CardGameSettings setValue:@(sender.value) forKey:MATCHCARDGAME_MISMATCHPENALTY_KEY];
    [self updateUI];
}

- (IBAction)matchFlipCost:(UIStepper *)sender {
    [CardGameSettings setValue:@(sender.value) forKey:MATCHCARDGAME_FLIPCOST_KEY];
    [self updateUI];
}

- (IBAction)setMatchBonus:(UIStepper *)sender {
    [CardGameSettings setValue:@(sender.value) forKey:SETCARDGAME_MATCHBONUS_KEY];
    [self updateUI];
}

- (IBAction)setMismatchPenalty:(UIStepper *)sender {
    [CardGameSettings setValue:@(sender.value) forKey:SETCARDGAME_MISMATCHPENALTY_KEY];
    [self updateUI];
}

- (IBAction)setFlipCost:(UIStepper *)sender {
    [CardGameSettings setValue:@(sender.value) forKey:SETCARDGAME_FLIPCOST_KEY];
    [self updateUI];
}

- (IBAction)deleteAllScores:(UIButton *)sender {
    [CardGameResult deleteCardGameResults];
}

- (IBAction)restoreDefaultSettings:(UIButton *)sender {
    [CardGameSettings restoreDefaultSettings];
    [self updateUI];
}


@end
