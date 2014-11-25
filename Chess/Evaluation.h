//
//  Evaluation.h
//  Chess
//
//  Created by Morten Hedengran on 20/11/14.
//  Copyright (c) 2014 Morten Hedengran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <stdio.h>
#import "GameState.h"

typedef enum {
	PAWN = 100,
	KNIGHT = 300,
	KING = 10000,
	ROOK = 520,
	BISHOP = 330,
	QUEEN = 900
} value;

@interface Evaluation : NSObject {	
	int whitePawnSquareValues[128];
	int whiteKnightSquareValues[128];
	int whiteBishopSquareValues[128];
	int whiteRookSquareValues[128];
	int whiteQueenSquareValues[128];
	int whiteKingSquareValuesMidGame[128];
	int whiteKingSquareValuesEndGame[128];
	int whiteKingSquareValuesLosingGame[128];
	
	int blackPawnSquareValues[128];
	int blackKnightSquareValues[128];
	int blackBishopSquareValues[128];
	int blackRookSquareValues[128];
	int blackQueenSquareValues[128];
	int blackKingSquareValuesMidGame[128];
	int blackKingSquareValuesEndGame[128];
	int blackKingSquareValuesLosingGame[128];
}

@property int isEndGame;
@property int currentRookValue;
@property int currentKnightValue;
@property int movesToMate;

+ (Evaluation*)init;

- (int)evaluateState:(GameState*)state forColorBlack:(bool)black;

@end
