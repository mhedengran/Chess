//
//  GameState.m
//  Chess
//
//  Created by Morten Hedengran on 19/11/14.
//  Copyright (c) 2014 Morten Hedengran. All rights reserved.
//

#import "GameState.h"

@implementation GameState

+ (GameState*)init {
	GameState* state = [[GameState alloc] init];
	for (int i = 0; i <= 128; i++) {
		if (i >= 0x10 && i <= 0x17) {
			state->board[i] = WHITE_PAWN;
		} else if (i == 0x00 || i == 0x07) {
			state->board[i] = WHITE_ROOK;
		} else if (i == 0x01 || i == 0x06) {
			state->board[i] = WHITE_KNIGHT;
		} else if (i == 0x02 || i == 0x05) {
			state->board[i] = WHITE_BISHOP;
		} else if (i == 0x04) {
			state->board[i] = WHITE_KING;
		} else if (i == 0x03) {
			state->board[i] = WHITE_QUEEN;
		} else if (i >= 0x60 && i <= 0x67) {
			state->board[i] = BLACK_PAWN;
		} else if (i == 0x70 || i == 0x77) {
			state->board[i] = BLACK_ROOK;
		} else if (i == 0x71 || i == 0x76) {
			state->board[i] = BLACK_KNIGHT;
		} else if (i == 0x72 || i == 0x75) {
			state->board[i] = BLACK_BISHOP;
		} else if (i == 0x74) {
			state->board[i] = BLACK_KING;
		} else if (i == 0x73) {
			state->board[i] = BLACK_QUEEN;
		} else {
			state->board[i] = 0;
		}
	}
	state.value = 0;
	return state;
}

+ (GameState*)initWithMoveFrom:(int)from To:(int)to and:(GameState*)prevState {
	GameState* state = [[GameState alloc] init];
	for (int i = 0; i <= 128; i++) {
		state->board[i] = prevState->board[i];
	}
	
	if (to >= 0x70 && to <= 0x77) {
		if (prevState->board[from] == WHITE_PAWN) {
			state->board[from] = WHITE_QUEEN;
		}
	} else if (to >= 0x00 && to <= 0x07) {
		if (prevState->board[from] == BLACK_PAWN) {
			state->board[from] = BLACK_QUEEN;
		}
	}
	state->board[to] = state->board[from];
	state->board[from] = 0;
	state.isEndGame = prevState.isEndGame;
	state.isBlackLosing = prevState.isBlackLosing;
	return state;
}

+ (GameState*)initWithDeletedPos:(int)pos and:(GameState*)prevState {
	GameState* state = [[GameState alloc] init];
	for (int i = 0; i <= 128; i++) {
		state->board[i] = prevState->board[i];
	}
	state->board[pos] = 0;
	return state;
}

- (type)getTypeForPos:(int)pos {
	return self->board[pos];
}

- (void)printBoard {
	for (int i = 7; i >= 0; i--) {
		NSMutableString* printStr = [[NSMutableString alloc] init];
		for (int j = 0; j <= 7; j++) {
			[printStr appendString:[NSString stringWithFormat:@"%2d  ", self->board[i*16+j]]];
			
		}
		NSLog(@"%@", printStr);
	}
	NSLog(@"  ");
}

@end
