//
//  ViewController.h
//  Chess
//
//  Created by Morten Hedengran on 28/10/14.
//  Copyright (c) 2014 Morten Hedengran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameState.h"
#import "Evaluation.h"
#import "MoveGenerator.h"

@interface MainViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *boardView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *FieldButtons;
@property (weak, nonatomic) IBOutlet UISegmentedControl *whiteOrBlackSegmentedControl;
@property (weak, nonatomic) IBOutlet UITextField *maxPlyTextField;
@property (weak, nonatomic) IBOutlet UITextField *maxTimeTextField;

@property (strong, nonatomic) GameState* currentState;
@property (strong, nonatomic) GameState* prevState;
@property (strong, nonatomic) GameState* currentBestState;
@property (strong, nonatomic) Evaluation* evaluation;
@property (strong, nonatomic) MoveGenerator* moveGenerator;
@property bool computerIsBlack;
@property (atomic) bool stopSearching;

@end

