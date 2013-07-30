//
//  GameResultViewController.m
//  Matchismo
//
//  Created by Scott Rogers on 15/07/13.
//  Copyright (c) 2013 opensoda. All rights reserved.
//

#import "GameResultViewController.h"
#import "CardGameResult.h"

@interface GameResultViewController ()
@property (weak, nonatomic) IBOutlet UITextView *display;
@property (strong, nonatomic) NSArray *sortedGameResults;

- (IBAction)date:(UIButton *)sender;
- (IBAction)score:(UIButton *)sender;
- (IBAction)duration:(id)sender;
@end

@implementation GameResultViewController

- (NSArray *)sortedGameResults {
    if (!_sortedGameResults) _sortedGameResults = [[CardGameResult cardGameResults]sortedArrayUsingSelector:@selector(compareByDate:)];
    return _sortedGameResults;
}

- (void)setup {
    // initialization that can't wait until viewDidLoad
}

- (void)awakeFromNib {
    [self setup];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    [self setup];
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.sortedGameResults = nil;
    [self updateUI];
}


#define DATE_FORMAT @"dd-MM-yy h:mma"

- (void)updateUI {
    NSString *displayText = @"";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:DATE_FORMAT];
    
    for (CardGameResult *gameResult in self.sortedGameResults) {
        displayText = [displayText stringByAppendingFormat:@"Score: %d (%@, %@, %0gs)\n", gameResult.score, gameResult.gameType,[dateFormatter stringFromDate:gameResult.end], round(gameResult.duration)];
    }
    self.display.text = displayText;
}


- (IBAction)date:(UIButton *)sender {
    self.sortedGameResults = [[CardGameResult cardGameResults]sortedArrayUsingSelector:@selector(compareByDate:)];
    [self updateUI];
}

- (IBAction)score:(UIButton *)sender {
    self.sortedGameResults = [[CardGameResult cardGameResults]sortedArrayUsingSelector:@selector(compareByScore:)];
    [self updateUI];
}

- (IBAction)duration:(id)sender {
    self.sortedGameResults = [[CardGameResult cardGameResults]sortedArrayUsingSelector:@selector(compareByDuration:)];
    [self updateUI];
}


@end
