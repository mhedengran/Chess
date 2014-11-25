//
//  Evaluation.m
//  Chess
//
//  Created by Morten Hedengran on 20/11/14.
//  Copyright (c) 2014 Morten Hedengran. All rights reserved.
//

#import "Evaluation.h"

@implementation Evaluation

+ (Evaluation*)init {
	Evaluation* eva = [[Evaluation alloc] init];

	eva.isEndGame = 0;
	eva.currentKnightValue = KNIGHT;
	eva.currentRookValue = ROOK;
	eva.movesToMate = 40;
	
	//init position values
	int whitePawnSquareValues[128] = {
		0,  0,  0,  0,  0,  0,  0,  0,     0,  0,  0,  0,  0,  0,  0,  0,
		5, 10, 10,-20,-20, 10, 10,  5,     0,  0,  0,  0,  0,  0,  0,  0,
		5, -5,-10,  0,  0,-10, -5,  5,     0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0, 20, 20,  0,  0,  0,     0,  0,  0,  0,  0,  0,  0,  0,
		5,  5, 10, 25, 25, 10,  5,  5,     0,  0,  0,  0,  0,  0,  0,  0,
	   10, 10, 20, 30, 30, 20, 10, 10,     0,  0,  0,  0,  0,  0,  0,  0,
	   50, 50, 50, 50, 50, 50, 50, 50,     0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,     0,  0,  0,  0,  0,  0,  0,  0
	};
	memcpy(eva->whitePawnSquareValues, whitePawnSquareValues, 128*sizeof(int));
	
	int whiteKnightSquareValues[128] = {
		-50,-40,-30,-30,-30,-30,-40,-50,     0,  0,  0,  0,  0,  0,  0,  0,
		-40,-20,  0,  5,  5,  0,-20,-40,     0,  0,  0,  0,  0,  0,  0,  0,
		-30,  5, 10, 15, 15, 10,  5,-30,     0,  0,  0,  0,  0,  0,  0,  0,
		-30,  0, 15, 20, 20, 15,  0,-30,     0,  0,  0,  0,  0,  0,  0,  0,
		-30,  5, 15, 20, 20, 15,  5,-30,     0,  0,  0,  0,  0,  0,  0,  0,
		-30,  0, 10, 15, 15, 10,  0,-30,     0,  0,  0,  0,  0,  0,  0,  0,
		-40,-20,  0,  0,  0,  0,-20,-40,     0,  0,  0,  0,  0,  0,  0,  0,
		-50,-40,-30,-30,-30,-30,-40,-50,     0,  0,  0,  0,  0,  0,  0,  0
	};
	memcpy(eva->whiteKnightSquareValues, whiteKnightSquareValues, 128*sizeof(int));
	
	int whiteBishopSquareValues[128] = {
		-20,-10,-10,-10,-10,-10,-10,-20,     0,  0,  0,  0,  0,  0,  0,  0,
		-10,  5,  0,  0,  0,  0,  5,-10,     0,  0,  0,  0,  0,  0,  0,  0,
		-10, 10, 10, 10, 10, 10, 10,-10,     0,  0,  0,  0,  0,  0,  0,  0,
		-10,  0, 10, 10, 10, 10,  0,-10,     0,  0,  0,  0,  0,  0,  0,  0,
		-10,  5,  5, 10, 10,  5,  5,-10,     0,  0,  0,  0,  0,  0,  0,  0,
		-10,  0,  5, 10, 10,  5,  0,-10,     0,  0,  0,  0,  0,  0,  0,  0,
		-10,  0,  0,  0,  0,  0,  0,-10,     0,  0,  0,  0,  0,  0,  0,  0,
		-20,-10,-10,-10,-10,-10,-10,-20,     0,  0,  0,  0,  0,  0,  0,  0
	};
	memcpy(eva->whiteBishopSquareValues, whiteBishopSquareValues, 128*sizeof(int));
	
	int whiteRookSquareValues[128] = {
		0,  0,  0,  5,  5,  0,  0,  0,     0,  0,  0,  0,  0,  0,  0,  0,
	   -5,  0,  0,  0,  0,  0,  0, -5,     0,  0,  0,  0,  0,  0,  0,  0,
	   -5,  0,  0,  0,  0,  0,  0, -5,     0,  0,  0,  0,  0,  0,  0,  0,
	   -5,  0,  0,  0,  0,  0,  0, -5,     0,  0,  0,  0,  0,  0,  0,  0,
	   -5,  0,  0,  0,  0,  0,  0, -5,     0,  0,  0,  0,  0,  0,  0,  0,
	   -5,  0,  0,  0,  0,  0,  0, -5,     0,  0,  0,  0,  0,  0,  0,  0,
		5, 10, 10, 10, 10, 10, 10,  5,     0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,     0,  0,  0,  0,  0,  0,  0,  0
	};
	memcpy(eva->whiteRookSquareValues, whiteRookSquareValues, 128*sizeof(int));
	
	int whiteQueenSquareValues[128] = {
		-20,-10,-10, -5, -5,-10,-10,-20,     0,  0,  0,  0,  0,  0,  0,  0,
		-10,  0,  5,  0,  0,  0,  0,-10,     0,  0,  0,  0,  0,  0,  0,  0,
		-10,  5,  5,  5,  5,  5,  0,-10,     0,  0,  0,  0,  0,  0,  0,  0,
		  0,  0,  5,  5,  5,  5,  0, -5,     0,  0,  0,  0,  0,  0,  0,  0,
		 -5,  0,  5,  5,  5,  5,  0, -5,     0,  0,  0,  0,  0,  0,  0,  0,
		-10,  0,  5,  5,  5,  5,  0,-10,     0,  0,  0,  0,  0,  0,  0,  0,
		-10,  0,  0,  0,  0,  0,  0,-10,     0,  0,  0,  0,  0,  0,  0,  0,
		-20,-10,-10, -5, -5,-10,-10,-20,     0,  0,  0,  0,  0,  0,  0,  0
	};
	memcpy(eva->whiteQueenSquareValues, whiteQueenSquareValues, 128*sizeof(int));
	
	int whiteKingSquareValuesMidGame[128] = {
		 20, 30, 10,  0,  0, 10, 30, 20,     0,  0,  0,  0,  0,  0,  0,  0,
		 20, 20,  0,  0,  0,  0, 20, 20,     0,  0,  0,  0,  0,  0,  0,  0,
	    -10,-20,-20,-20,-20,-20,-20,-10,     0,  0,  0,  0,  0,  0,  0,  0,
		-20,-30,-30,-40,-40,-30,-30,-20,     0,  0,  0,  0,  0,  0,  0,  0,
		-30,-40,-40,-50,-50,-40,-40,-30,     0,  0,  0,  0,  0,  0,  0,  0,
		-30,-40,-40,-50,-50,-40,-40,-30,     0,  0,  0,  0,  0,  0,  0,  0,
		-30,-40,-40,-50,-50,-40,-40,-30,     0,  0,  0,  0,  0,  0,  0,  0,
		-30,-40,-40,-50,-50,-40,-40,-30,     0,  0,  0,  0,  0,  0,  0,  0
	};
	memcpy(eva->whiteKingSquareValuesMidGame, whiteKingSquareValuesMidGame, 128*sizeof(int));
	
	int whiteKingSquareValuesEndGame[128] = {
		-50,-30,-30,-30,-30,-30,-30,-50,     0,  0,  0,  0,  0,  0,  0,  0,
		-30,-30,  0,  0,  0,  0,-30,-30,     0,  0,  0,  0,  0,  0,  0,  0,
		-30,-10, 20, 30, 30, 20,-10,-30,     0,  0,  0,  0,  0,  0,  0,  0,
		-30,-10, 30, 40, 40, 30,-10,-30,     0,  0,  0,  0,  0,  0,  0,  0,
		-30,-10, 30, 40, 40, 30,-10,-30,     0,  0,  0,  0,  0,  0,  0,  0,
		-30,-10, 20, 30, 30, 20,-10,-30,     0,  0,  0,  0,  0,  0,  0,  0,
		-30,-20,-10,  0,  0,-10,-20,-30,     0,  0,  0,  0,  0,  0,  0,  0,
		-50,-40,-30,-20,-20,-30,-40,-50,     0,  0,  0,  0,  0,  0,  0,  0
	};
	memcpy(eva->whiteKingSquareValuesEndGame, whiteKingSquareValuesEndGame, 128*sizeof(int));
	
	int whiteKingSquareValuesLosingGame[128] = {
		-80,-70,-60,-60,-60,-60,-70,-80,     0,  0,  0,  0,  0,  0,  0,  0,
		-70,-60,-40,-40,-40,-40,-60,-70,     0,  0,  0,  0,  0,  0,  0,  0,
		-60,-40,-20,-20,-20,-20,-40,-60,     0,  0,  0,  0,  0,  0,  0,  0,
		-60,-40,-20,  0,  0,-20,-40,-60,     0,  0,  0,  0,  0,  0,  0,  0,
		-60,-40,-20,  0,  0,-20,-40,-60,     0,  0,  0,  0,  0,  0,  0,  0,
		-60,-40,-20,-20,-20,-20,-40,-60,     0,  0,  0,  0,  0,  0,  0,  0,
		-70,-60,-40,-40,-40,-40,-60,-70,     0,  0,  0,  0,  0,  0,  0,  0,
		-80,-70,-60,-60,-60,-60,-70,-80,     0,  0,  0,  0,  0,  0,  0,  0
	};
	memcpy(eva->whiteKingSquareValuesLosingGame, whiteKingSquareValuesLosingGame, 128*sizeof(int));
	
	
	int blackPawnSquareValues[128] = {
		0,  0,  0,  0,  0,  0,  0,  0,     0,  0,  0,  0,  0,  0,  0,  0,
		50, 50, 50, 50, 50, 50, 50, 50,    0,  0,  0,  0,  0,  0,  0,  0,
		10, 10, 20, 30, 30, 20, 10, 10,    0,  0,  0,  0,  0,  0,  0,  0,
		5,  5, 10, 25, 25, 10,  5,  5,     0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0, 20, 20,  0,  0,  0,     0,  0,  0,  0,  0,  0,  0,  0,
		5, -5,-10,  0,  0,-10, -5,  5,     0,  0,  0,  0,  0,  0,  0,  0,
		5, 10, 10,-20,-20, 10, 10,  5,     0,  0,  0,  0,  0,  0,  0,  0,
		0,  0,  0,  0,  0,  0,  0,  0,     0,  0,  0,  0,  0,  0,  0,  0
	};
	memcpy(eva->blackPawnSquareValues, blackPawnSquareValues, 128*sizeof(int));

	int blackKnightSquareValues[128] = {
		-50,-40,-30,-30,-30,-30,-40,-50,     0,  0,  0,  0,  0,  0,  0,  0,
		-40,-20,  0,  0,  0,  0,-20,-40,     0,  0,  0,  0,  0,  0,  0,  0,
		-30,  0, 10, 15, 15, 10,  0,-30,     0,  0,  0,  0,  0,  0,  0,  0,
		-30,  5, 15, 20, 20, 15,  5,-30,     0,  0,  0,  0,  0,  0,  0,  0,
		-30,  0, 15, 20, 20, 15,  0,-30,     0,  0,  0,  0,  0,  0,  0,  0,
		-30,  5, 10, 15, 15, 10,  5,-30,     0,  0,  0,  0,  0,  0,  0,  0,
		-40,-20,  0,  5,  5,  0,-20,-40,     0,  0,  0,  0,  0,  0,  0,  0,
		-50,-40,-30,-30,-30,-30,-40,-50,     0,  0,  0,  0,  0,  0,  0,  0
	};
	memcpy(eva->blackKnightSquareValues, blackKnightSquareValues, 128*sizeof(int));
	
	int blackBishopSquareValues[128] = {
		-20,-10,-10,-10,-10,-10,-10,-20,     0,  0,  0,  0,  0,  0,  0,  0,
		-10,  0,  0,  0,  0,  0,  0,-10,     0,  0,  0,  0,  0,  0,  0,  0,
		-10,  0,  5, 10, 10,  5,  0,-10,     0,  0,  0,  0,  0,  0,  0,  0,
		-10,  5,  5, 10, 10,  5,  5,-10,     0,  0,  0,  0,  0,  0,  0,  0,
		-10,  0, 10, 10, 10, 10,  0,-10,     0,  0,  0,  0,  0,  0,  0,  0,
		-10, 10, 10, 10, 10, 10, 10,-10,     0,  0,  0,  0,  0,  0,  0,  0,
		-10,  5,  0,  0,  0,  0,  5,-10,     0,  0,  0,  0,  0,  0,  0,  0,
		-20,-10,-10,-10,-10,-10,-10,-20,     0,  0,  0,  0,  0,  0,  0,  0
	};
	memcpy(eva->blackBishopSquareValues, blackBishopSquareValues, 128*sizeof(int));
	
	int blackRookSquareValues[128] = {
		 0,  0,  0,  0,  0,  0,  0,  0,     0,  0,  0,  0,  0,  0,  0,  0,
		 5, 10, 10, 10, 10, 10, 10,  5,     0,  0,  0,  0,  0,  0,  0,  0,
		-5,  0,  0,  0,  0,  0,  0, -5,     0,  0,  0,  0,  0,  0,  0,  0,
		-5,  0,  0,  0,  0,  0,  0, -5,     0,  0,  0,  0,  0,  0,  0,  0,
		-5,  0,  0,  0,  0,  0,  0, -5,     0,  0,  0,  0,  0,  0,  0,  0,
		-5,  0,  0,  0,  0,  0,  0, -5,     0,  0,  0,  0,  0,  0,  0,  0,
		-5,  0,  0,  0,  0,  0,  0, -5,     0,  0,  0,  0,  0,  0,  0,  0,
		 0,  0,  0,  5,  5,  0,  0,  0,     0,  0,  0,  0,  0,  0,  0,  0
	};
	memcpy(eva->blackRookSquareValues, blackRookSquareValues, 128*sizeof(int));
	
	int blackQueenSquareValues[128] = {
		-20,-10,-10, -5, -5,-10,-10,-20,     0,  0,  0,  0,  0,  0,  0,  0,
		-10,  0,  0,  0,  0,  0,  0,-10,     0,  0,  0,  0,  0,  0,  0,  0,
		-10,  0,  5,  5,  5,  5,  0,-10,     0,  0,  0,  0,  0,  0,  0,  0,
		 -5,  0,  5,  5,  5,  5,  0, -5,     0,  0,  0,  0,  0,  0,  0,  0,
		  0,  0,  5,  5,  5,  5,  0, -5,     0,  0,  0,  0,  0,  0,  0,  0,
		-10,  5,  5,  5,  5,  5,  0,-10,     0,  0,  0,  0,  0,  0,  0,  0,
		-10,  0,  5,  0,  0,  0,  0,-10,     0,  0,  0,  0,  0,  0,  0,  0,
		-20,-10,-10, -5, -5,-10,-10,-20,     0,  0,  0,  0,  0,  0,  0,  0
	};
	memcpy(eva->blackQueenSquareValues, blackQueenSquareValues, 128*sizeof(int));
	
	int blackKingSquareValuesMidGame[128] = {
		-30,-40,-40,-50,-50,-40,-40,-30,     0,  0,  0,  0,  0,  0,  0,  0,
		-30,-40,-40,-50,-50,-40,-40,-30,     0,  0,  0,  0,  0,  0,  0,  0,
		-30,-40,-40,-50,-50,-40,-40,-30,     0,  0,  0,  0,  0,  0,  0,  0,
		-30,-40,-40,-50,-50,-40,-40,-30,     0,  0,  0,  0,  0,  0,  0,  0,
		-20,-30,-30,-40,-40,-30,-30,-20,     0,  0,  0,  0,  0,  0,  0,  0,
		-10,-20,-20,-20,-20,-20,-20,-10,     0,  0,  0,  0,  0,  0,  0,  0,
		 20, 20,  0,  0,  0,  0, 20, 20,     0,  0,  0,  0,  0,  0,  0,  0,
		 20, 30, 10,  0,  0, 10, 30, 20,     0,  0,  0,  0,  0,  0,  0,  0
	};
	memcpy(eva->blackKingSquareValuesMidGame, blackKingSquareValuesMidGame, 128*sizeof(int));
	
	int blackKingSquareValuesEndGame[128] = {
		-50,-40,-30,-20,-20,-30,-40,-50,     0,  0,  0,  0,  0,  0,  0,  0,
		-30,-20,-10,  0,  0,-10,-20,-30,     0,  0,  0,  0,  0,  0,  0,  0,
		-30,-10, 20, 30, 30, 20,-10,-30,     0,  0,  0,  0,  0,  0,  0,  0,
		-30,-10, 30, 40, 40, 30,-10,-30,     0,  0,  0,  0,  0,  0,  0,  0,
		-30,-10, 30, 40, 40, 30,-10,-30,     0,  0,  0,  0,  0,  0,  0,  0,
		-30,-10, 20, 30, 30, 20,-10,-30,     0,  0,  0,  0,  0,  0,  0,  0,
		-30,-30,  0,  0,  0,  0,-30,-30,     0,  0,  0,  0,  0,  0,  0,  0,
		-50,-30,-30,-30,-30,-30,-30,-50,     0,  0,  0,  0,  0,  0,  0,  0
	};
	memcpy(eva->blackKingSquareValuesEndGame, blackKingSquareValuesEndGame, 128*sizeof(int));
	
	int blackKingSquareValuesLosingGame[128] = {
		-80,-70,-60,-60,-60,-60,-70,-80,     0,  0,  0,  0,  0,  0,  0,  0,
		-70,-60,-40,-40,-40,-40,-60,-70,     0,  0,  0,  0,  0,  0,  0,  0,
		-60,-40,-20,-20,-20,-20,-40,-60,     0,  0,  0,  0,  0,  0,  0,  0,
		-60,-40,-20,  0,  0,-20,-40,-60,     0,  0,  0,  0,  0,  0,  0,  0,
		-60,-40,-20,  0,  0,-20,-40,-60,     0,  0,  0,  0,  0,  0,  0,  0,
		-60,-40,-20,-20,-20,-20,-40,-60,     0,  0,  0,  0,  0,  0,  0,  0,
		-70,-60,-40,-40,-40,-40,-60,-70,     0,  0,  0,  0,  0,  0,  0,  0,
		-80,-70,-60,-60,-60,-60,-70,-80,     0,  0,  0,  0,  0,  0,  0,  0
	};
	memcpy(eva->blackKingSquareValuesLosingGame, blackKingSquareValuesLosingGame, 128*sizeof(int));
	
	return eva;
}

- (int)evaluateState:(GameState*)state forColorBlack:(bool)black {
	int whiteValue = 0;
	int blackValue = 0;
	int blackBishops = 0;
	int whiteBishops = 0;
	int numberOfPawns = 0;
	int blackKingPos = -1;
	int whiteKingPos = -1;
	for (int i = 0; i <= 7; i++) {
		for (int j = 0; j <= 7; j++) {
			int pos = i*16+j;
			type type = [state getTypeForPos:pos];
			switch (type) {
				case WHITE_PAWN:
					whiteValue += (PAWN + whitePawnSquareValues[pos]);
					numberOfPawns++;
					break;
				case WHITE_ROOK:
					if (self.isEndGame != 2) {
						whiteValue += (self.currentRookValue + whiteRookSquareValues[pos]);
					} else {
						whiteValue += self.currentRookValue;
					}
					break;
				case WHITE_KNIGHT:
					if (self.isEndGame != 2) {
						whiteValue += (self.currentKnightValue + whiteKnightSquareValues[pos]);
					} else {
						whiteValue += self.currentKnightValue;
					}
					break;
				case WHITE_BISHOP:
					if (self.isEndGame != 2) {
						whiteValue += (BISHOP + whiteBishopSquareValues[pos]);
					} else {
						whiteValue += BISHOP;
					}
					whiteBishops++;
					break;
				case WHITE_QUEEN:
					if (self.isEndGame != 2) {
						whiteValue += (QUEEN + whiteQueenSquareValues[pos]);
					} else {
						whiteValue += QUEEN;
					}
					break;
				case WHITE_KING:
					if (self.isEndGame == 1) {
						whiteValue += (KING + whiteKingSquareValuesEndGame[pos]);
					} else if (self.isEndGame == 2) {
						if (state.isBlackLosing) {
							whiteKingPos = pos;
							whiteValue += KING;
						} else {
							whiteValue += (KING + whiteKingSquareValuesLosingGame[pos]);
							whiteKingPos = pos;
						}
					} else {
						whiteValue += (KING + whiteKingSquareValuesMidGame[pos]);
					}
					break;
				case BLACK_PAWN:
					blackValue += (PAWN + blackPawnSquareValues[pos]);
					numberOfPawns++;
					break;
				case BLACK_ROOK:
					if (self.isEndGame != 2) {
						blackValue += (self.currentRookValue + blackRookSquareValues[pos]);
					} else {
						blackValue += self.currentRookValue;
					}
					break;
				case BLACK_KNIGHT:
					if (self.isEndGame != 2) {
						blackValue += (self.currentKnightValue + blackKnightSquareValues[pos]);
					} else {
						blackValue += self.currentKnightValue;
					}
					break;
				case BLACK_BISHOP:
					if (self.isEndGame != 2) {
						blackValue += (BISHOP + blackBishopSquareValues[pos]);
					} else {
						blackValue += BISHOP;
					}
					blackBishops++;
					break;
				case BLACK_QUEEN:
					if (self.isEndGame != 2) {
						blackValue += (QUEEN + blackQueenSquareValues[pos]);
					} else {
						blackValue += QUEEN;
					}
					break;
				case BLACK_KING:
					if (self.isEndGame == 1) {
						blackValue += (KING + blackKingSquareValuesEndGame[pos]);
					} else if (self.isEndGame == 2) {
						if (state.isBlackLosing) {
							blackValue += (KING + blackKingSquareValuesLosingGame[pos]);
							blackKingPos = pos;
						} else {
							blackKingPos = pos;
							blackValue += KING;
						}
					} else {
						blackValue += (KING + blackKingSquareValuesMidGame[pos]);
					}
					break;
				default:
					break;
			}
		}
	}
	//bishop pair bonus;
	if (blackBishops > 1) {
		blackValue += PAWN/2;
	}
	if (whiteBishops > 1) {
		whiteValue += PAWN/2;
	}
	//base rook and knight value of pawns
	self.currentKnightValue = KNIGHT + numberOfPawns*5;
	self.currentRookValue = ROOK - numberOfPawns*5;
	
	if ((self.isEndGame != 2 || state.isEndGame != 2) && (blackValue-KING < 600 || whiteValue-KING < 600)) {
		state.isEndGame = 2;
	} else if ((self.isEndGame < 1 || state.isEndGame < 1) &&(blackValue-KING < 1500 || whiteValue-KING < 1500)) {
		state.isEndGame = 1;
	}
	if (state.isEndGame == 2) {
		if (blackValue >= whiteValue) {
			state.isBlackLosing = NO;
		} else {
			state.isBlackLosing = YES;
		}
	} else if (!state.isEndGame) {
		blackValue -= (self.movesToMate*100);
		whiteValue -= (self.movesToMate*100);
	}
	
	//mate king calculation
	if (self.isEndGame == 2) {
		if (blackKingPos >= 0 && whiteKingPos >= 0) {
			if (state.isBlackLosing) {
				whiteValue += (-50)*(ABS(blackKingPos - whiteKingPos)/16);
			} else {
				blackValue += (-50)*(ABS(blackKingPos - whiteKingPos)/16);
			}
		}
	}
	if (black) {
		return blackValue-whiteValue;
	} else {
		return whiteValue-blackValue;
	}
}

@end
