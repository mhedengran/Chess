//
//  MoveGenerator.m
//  Chess
//
//  Created by Morten Hedengran on 21/11/14.
//  Copyright (c) 2014 Morten Hedengran. All rights reserved.
//

#import "MoveGenerator.h"

@implementation MoveGenerator

+ (MoveGenerator*)init {
	MoveGenerator* mvGen = [[MoveGenerator alloc] init];
	
	int knightMoves[8] = {
		0x21,
		0x1F,
		0x12,
		0x0E,
		-0x21,
		-0x1F,
		-0x12,
		-0x0E
	};
	memcpy(mvGen->knightMoves, knightMoves, 8*sizeof(int));
	
	int kingMoves[8] = {
		0x01,
		-0x0F,
		-0x10,
		-0x11,
		-0x01,
		0x0F,
		0x10,
		0x11
	};
	memcpy(mvGen->kingMoves, kingMoves, 8*sizeof(int));
	
	int queenMoves[8] = {
		0x01,
		-0x10,
		-0x01,
		0x10,
		-0x0F,
		0x0F,
		-0x11,
		0x11
	};
	memcpy(mvGen->queenMoves, queenMoves, 8*sizeof(int));
	
	int blackPawnMoves[4] = {
		-0x10,
		-0x11,
		-0x0F,
		-0x20
	};
	memcpy(mvGen->blackPawnMoves, blackPawnMoves, 4*sizeof(int));
	
	int whitePawnMoves[4] = {
		0x10,
		0x11,
		0x0F,
		0x20
	};
	memcpy(mvGen->whitePawnMoves, whitePawnMoves, 4*sizeof(int));
	
	int bishopMoves[4] = {
		-0x0F,
		-0x11,
		0x0F,
		0x11
	};
	memcpy(mvGen->bishopMoves, bishopMoves, 4*sizeof(int));
	
	int rookMoves[4] = {
		0x01,
		-0x10,
		-0x01,
		0x10,
	};
	memcpy(mvGen->rookMoves, rookMoves, 4*sizeof(int));
	
	return mvGen;
}

- (bool)isValidMoveForBlack:(bool)black andState:(GameState*)state withMoveFrom:(int)from andMove:(int)move {
	int to = from + move;
	
	//find ud af hvorfor egen konge bliver tage her...
	
	
	//is move on board?
	if (to & 0x88) {
		return NO;
	}
	
	//is our own piece where we are moving to?
	type toType = [state getTypeForPos:to];
	type fromType = [state getTypeForPos:from];
	//is there a piece on new loc
	if (toType != 0) {
		//is the piece black or white
		if (black) {
			if (toType > 0x08) {
				return NO;
			} else {
				if (fromType == BLACK_PAWN) {
					if (move == -0x11 || move == -0x0F) {
						return YES;
					} else {
						return NO;
					}
				} else {
					return YES;
				}
			}
		} else {
			if (toType < 0x08 ) {
				return NO;
			} else {
				if (fromType == WHITE_PAWN) {
					if (move == 0x11 || move == 0x0F) {
						return YES;
					} else {
						return NO;
					}
				} else {
					return YES;
				}
			}
		}//if no piece is present
	} else if (fromType == WHITE_PAWN) {
		if (move == 0x10) {
			return YES;
		} else if (move == 0x20) {
			if ([state getTypeForPos:from+0x10] == 0 ) {
				if (from >= 0x10 && from <= 0x17) {
					return YES;
				} else {
					return NO;
				}
			} else {
				return NO;
			}
		} else {
			return NO;
		}
	} else if (fromType == BLACK_PAWN) {
		if (move == -0x10) {
			return YES;
		} else if (move == -0x20) {
			if ([state getTypeForPos:from-0x10] == 0 ) {
				if (from >= 0x60 && from <= 0x67) {
					return YES;
				} else {
					return NO;
				}
				return YES;
			} else {
				return NO;
			}
		} else {
			return NO;
		}
	} else {
		return YES;
	}
}

- (int*)getMovesFor:(type)type {
	switch (type) {
		case WHITE_PAWN:
			return self->whitePawnMoves;
			break;
		case BLACK_PAWN:
			return self->blackPawnMoves;
			break;
		case WHITE_ROOK:
		case BLACK_ROOK:
			return self->rookMoves;
			break;
		case WHITE_KNIGHT:
		case BLACK_KNIGHT:
			return self->knightMoves;
			break;
		case WHITE_BISHOP:
		case BLACK_BISHOP:
			return self->bishopMoves;
			break;
		case WHITE_QUEEN:
		case BLACK_QUEEN:
			return self->queenMoves;
			break;
		case WHITE_KING:
		case BLACK_KING:
			return self->kingMoves;
			break;
		default:
			return nil;
			break;
	}
}

- (int)getSizeOfMovesArrayFor:(type)type {
	switch (type) {
		case WHITE_PAWN:
			return sizeof(self->whitePawnMoves) / sizeof(int);
			break;
		case BLACK_PAWN:
			return sizeof(self->blackPawnMoves) / sizeof(int);
			break;
		case WHITE_ROOK:
		case BLACK_ROOK:
			return sizeof(self->rookMoves) / sizeof(int);
			break;
		case WHITE_KNIGHT:
		case BLACK_KNIGHT:
			return sizeof(self->knightMoves) / sizeof(int);
			break;
		case WHITE_BISHOP:
		case BLACK_BISHOP:
			return sizeof(self->bishopMoves) / sizeof(int);
			break;
		case WHITE_QUEEN:
		case BLACK_QUEEN:
			return sizeof(self->queenMoves) / sizeof(int);
			break;
		case WHITE_KING:
		case BLACK_KING:
			return sizeof(self->kingMoves) / sizeof(int);
			break;
		default:
			return 0;
			break;
	}
}

@end
