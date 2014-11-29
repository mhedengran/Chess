//
//  ViewController.m
//  Chess
//
//  Created by Morten Hedengran on 28/10/14.
//  Copyright (c) 2014 Morten Hedengran. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@property (strong, nonatomic) UIButton* tempButton;

@end

@implementation MainViewController

//lav så hvis kongen er væk så returnerer den +/- uendelig alt efter hvis
//lav rokade
//spørg bjørn hvordan man "seeder" en iterativ deepening med den bedste fra sidste?
//lave alle tests undtagen test 3 late om, husk at notere ved iterativ deepening, hvis bedste move ændrer sig undervejs
//lad vær med at generere bedste state (transpositions table)
//optimer //spiller ikke ret godt til sidst

- (void)viewDidLoad {
	[super viewDidLoad];
	self.currentState = [GameState init];
	self.evaluation = [Evaluation init];
	self.moveGenerator = [MoveGenerator init];
	for (UIButton *field in self.FieldButtons) {
		[field addTarget:self action:@selector(fieldPressed:) forControlEvents:UIControlEventTouchUpInside];
	}
}

- (IBAction)fieldPressed:(id)sender {
	[self.view endEditing:YES];
	if (self.tempButton == nil) {
		self.tempButton = sender;
		[self.tempButton.layer setBorderWidth:3.0];
		[self.tempButton.layer setBorderColor:[[UIColor greenColor] CGColor]];
	} else if (self.tempButton == sender) {
		[self.tempButton.layer setBorderWidth:0.0];
		[self.tempButton.layer setBorderColor:[[UIColor clearColor] CGColor]];
		self.tempButton = nil;
	} else {
		[self.tempButton.layer setBorderWidth:0.0];
		[self.tempButton.layer setBorderColor:[[UIColor clearColor] CGColor]];
		int from = (int)self.tempButton.tag-1;
		int to = (int)((UIButton*)sender).tag-1;
		self.tempButton = nil;
		self.prevState = self.currentState;
		self.currentState = [GameState initWithMoveFrom:from To:to and:self.prevState];
		[self updateGui];
	}
}

- (IBAction)startPressed:(id)sender {
	[self.view endEditing:YES];
	if ([((UIButton*)sender).titleLabel.text isEqualToString:@"Start"]) {
		if (self.whiteOrBlackSegmentedControl.selectedSegmentIndex == 1) {
			self.prevState = self.currentState;
			self.currentState = [GameState initWithMoveFrom:0x12 To:0x32 and:self.currentState];
			self.computerIsBlack = NO;
		} else {
			self.computerIsBlack = YES;
		}
		self.whiteOrBlackSegmentedControl.enabled = NO;
		[((UIButton*)sender) setTitle:@"Restart" forState:UIControlStateNormal];
		[self updateGui];
	} else {
		self.prevState = nil;
		self.currentState = [GameState init];
		self.evaluation = [Evaluation init];
		[self updateGui];
		[((UIButton*)sender) setTitle:@"Start" forState:UIControlStateNormal];
		self.whiteOrBlackSegmentedControl.enabled = YES;
	}
}

- (IBAction)undoPressed:(id)sender {
	[self.view endEditing:YES];
	self.currentState = self.prevState;
	[self updateGui];
}

- (IBAction)removePressed:(id)sender {
	[self.view endEditing:YES];
	[self.tempButton setBackgroundImage:nil forState:UIControlStateNormal];
	[self.tempButton.layer setBorderWidth:0.0];
	[self.tempButton.layer setBorderColor:[[UIColor clearColor] CGColor]];
	int pos = (int)self.tempButton.tag-1;
	self.tempButton = nil;
	self.prevState = self.currentState;
	self.currentState = [GameState initWithDeletedPos:pos and:self.prevState];
}

- (IBAction)donePressed:(id)sender {
	[self.view endEditing:YES];
	self.stopSearching = NO;
	if (self.maxTimeTextField.text != nil && ![self.maxTimeTextField.text isEqualToString:@""]) {
		int delayInSeconds = [self.maxTimeTextField.text intValue];
		dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)); // 1
		dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
			self.stopSearching = YES;
		});
		int i = 1;
		while (!self.stopSearching) {
			if (i == 1) {
				[self alphaBetaWithState:self.currentState alpha:-INT16_MAX beta:INT16_MAX depth:i totalDepth:i computer:YES isComputerBlack:self.computerIsBlack];
			} else {
				[self alphaBetaWithState:self.currentState alpha:-INT16_MAX beta:INT16_MAX depth:i totalDepth:i computer:YES isComputerBlack:self.computerIsBlack];
			}
			i++;
			if (!self.stopSearching) {
				self.chosenBestState = self.currentBestState;
			}
		}
	} else if (self.maxPlyTextField.text != nil && ![self.maxPlyTextField.text isEqualToString:@""]) {
		for (int i = 1; i <= [self.maxPlyTextField.text intValue]; i ++) {
			if (i == 1) {
				[self alphaBetaWithState:self.currentState alpha:-INT16_MAX beta:INT16_MAX depth:i totalDepth:i computer:YES isComputerBlack:self.computerIsBlack];
			} else {
				[self alphaBetaWithState:self.currentState alpha:-INT16_MAX beta:INT16_MAX depth:i totalDepth:i computer:YES isComputerBlack:self.computerIsBlack];
			}
			self.chosenBestState = self.currentBestState;
		}
	}
	self.prevState = self.currentState;
	self.currentState = self.chosenBestState;
	self.chosenBestState = nil;
	[self updateGui];
	if (self.evaluation.isEndGame < self.currentState.isEndGame) {
		self.evaluation.isEndGame = self.currentState.isEndGame;
	}
	if (self.evaluation.movesToMate > 0) {
		self.evaluation.movesToMate--;
	}
}

- (IBAction)whiteOrBlackChosen:(id)sender {
	[self.view endEditing:YES];
	CGAffineTransform transform = CGAffineTransformRotate(self.boardView.transform, -M_PI);
	self.boardView.transform = transform;
	for (UIButton *field in self.FieldButtons) {
		transform = CGAffineTransformRotate(field.transform, -M_PI);
		field.transform = transform;
	}
}

- (NSArray*)generateNewStatesFrom:(GameState*)state isComputerBlack:(bool)black isCurrentBlack:(bool)currentBlack {
	NSMutableArray* legalMoves = [[NSMutableArray alloc] init];
	for (int i = 7; i >= 0; i--) {
		for (int j = 0; j <= 7; j++) {
			int pos = i*16+j;
			type type = [state getTypeForPos:pos];
			if (type != 0) {
				if ((currentBlack && type > 0x08) || (!currentBlack && type < 0x08)) {
					int *moves = [self.moveGenerator getMovesFor:type];
					int size = [self.moveGenerator getSizeOfMovesArrayFor:type];
					if (type & 0x04) {
						for (int k = 0; k < size; k++) {
							int tempPos = pos;
							GameState* tempState = state;
							while ([self.moveGenerator isValidMoveForBlack:currentBlack andState:tempState withMoveFrom:tempPos andMove:*(moves+k)]) {
								tempPos += (*(moves+k));
								
								tempState = [GameState initWithMoveFrom:pos To:tempPos and:state];
								tempState.value = [self.evaluation evaluateState:tempState forColorBlack:black];
								[legalMoves addObject:tempState];
								int isOpponentPiece = [state getTypeForPos:tempPos];
								if ((isOpponentPiece > 0x08 && !currentBlack) || (isOpponentPiece < 0x08 && currentBlack && isOpponentPiece)) {
									break;
								}
							}
						}
					} else {
						for (int k = 0; k < size; k++) {
							if ([self.moveGenerator isValidMoveForBlack:currentBlack andState:state withMoveFrom:pos andMove:*(moves+k)]) {
								GameState* tempState = [GameState initWithMoveFrom:pos To:pos+*(moves+k) and:state];
								tempState.value = [self.evaluation evaluateState:tempState forColorBlack:black];
								[legalMoves addObject:tempState];
							}
						}
					}
				}
			}
		}
	}
	return [legalMoves sortedArrayUsingComparator:^NSComparisonResult(GameState* a, GameState* b) {
		if (black == currentBlack) {
			if (a.value > b.value) {
				return NSOrderedAscending;
			} else if (a.value < b.value) {
				return NSOrderedDescending;
			} else {
				return NSOrderedSame;
			}
		} else {
			if (a.value > b.value) {
				return NSOrderedDescending;
			} else if (a.value < b.value) {
				return NSOrderedAscending;
			} else {
				return NSOrderedSame;
			}
		}
	}];
}

- (int)alphaBetaWithState:(GameState*)state alpha:(int)alpha beta:(int)beta depth:(int)currentDepth totalDepth:(int)depth computer:(bool)computer isComputerBlack:(bool)black {
	
	if (currentDepth == 0 || state.value == -INT16_MAX || state.value == INT16_MAX || self.stopSearching) {
		return state.value;
	}
	
	int i = 0;
	if (computer) {
		NSMutableArray* states = [[NSMutableArray alloc] initWithArray:[self generateNewStatesFrom:state isComputerBlack:black isCurrentBlack:black]];
		if (currentDepth == depth && self.chosenBestState != nil) {
			[states insertObject:self.chosenBestState atIndex:0];
		}
		while ((beta > alpha) && (i < states.count)) {
			int score = [self alphaBetaWithState:states[i] alpha:alpha beta:beta depth:currentDepth-1 totalDepth:depth computer:NO isComputerBlack:black];
			if (score > alpha) {
				alpha = score;
				if (currentDepth == depth && state != self.currentBestState) {
					self.currentBestState = states[i];
				}
			}
			i++;
		}
		states = nil;
		return alpha;
	} else {
		NSArray* states = [self generateNewStatesFrom:state isComputerBlack:black isCurrentBlack:!black];
		while ((beta > alpha) && (i < states.count)) {
			int score = [self alphaBetaWithState:states[i] alpha:alpha beta:beta depth:currentDepth-1 totalDepth:depth computer:YES isComputerBlack:black];
			if (score < beta) {
				beta = score;
			}
			i++;
		}
		states = nil;
		return beta;
	}
}

- (void)updateGui {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:2];
	for (int i = 0; i <= 7; i++) {
		for (int j = 0; j <= 7; j++) {
			int pos = i*16+j;
			type type = [self.currentState getTypeForPos:pos];
			if (type != 0) {
				[((UIButton*)[self.view viewWithTag:pos+1]) setBackgroundImage:[UIImage imageNamed:[self getImageString:type]] forState:UIControlStateNormal];
			} else {
				[((UIButton*)[self.view viewWithTag:pos+1]) setBackgroundImage:nil forState:UIControlStateNormal];
			}
		}
	}
	[UIView commitAnimations];
}

- (NSString*)getImageString:(type)type {
	switch (type) {
		case WHITE_PAWN:
			return @"WhitePawn";
			break;
		case WHITE_ROOK:
			return @"WhiteRook";
			break;
		case WHITE_KNIGHT:
			return @"WhiteKnight";
			break;
		case WHITE_BISHOP:
			return @"WhiteBishop";
			break;
		case WHITE_QUEEN:
			return @"WhiteQueen";
			break;
		case WHITE_KING:
			return @"WhiteKing";
			break;
		case BLACK_PAWN:
			return @"BlackPawn";
			break;
		case BLACK_ROOK:
			return @"BlackRook";
			break;
		case BLACK_KNIGHT:
			return @"BlackKnight";
			break;
		case BLACK_BISHOP:
			return @"BlackBishop";
			break;
		case BLACK_QUEEN:
			return @"BlackQueen";
			break;
		case BLACK_KING:
			return @"BlackKing";
			break;
		default:
			return @"";
			break;
	}
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	[self.view endEditing:YES];
}

@end
