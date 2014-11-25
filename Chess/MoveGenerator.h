//
//  MoveGenerator.h
//  Chess
//
//  Created by Morten Hedengran on 21/11/14.
//  Copyright (c) 2014 Morten Hedengran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameState.h"

@interface MoveGenerator : NSObject {
	int knightMoves[8];
	int kingMoves[8];
	int queenMoves[8];
	int blackPawnMoves[4];
	int whitePawnMoves[4];
	int bishopMoves[4];
	int rookMoves[4];
}

+ (MoveGenerator*)init;
- (bool)isValidMoveForBlack:(bool)black andState:(GameState*)state withMoveFrom:(int)from andMove:(int)move;
- (int*)getMovesFor:(type)type;
- (int)getSizeOfMovesArrayFor:(type)type;

@end
