//
//  GameState.h
//  Chess
//
//  Created by Morten Hedengran on 19/11/14.
//  Copyright (c) 2014 Morten Hedengran. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	WHITE_PAWN = 0x01,
	WHITE_KNIGHT = 0x02,
	WHITE_KING = 0x03,
	WHITE_ROOK = 0x05,
	WHITE_BISHOP = 0x06,
	WHITE_QUEEN = 0x07,
	BLACK_PAWN = 0x09,
	BLACK_KNIGHT = 0x0A,
	BLACK_KING = 0x0B,
	BLACK_ROOK = 0x0D,
	BLACK_BISHOP = 0x0E,
	BLACK_QUEEN = 0x0F
} type;

@interface GameState : NSObject {
	int board[128];
}

@property int value;
@property int isEndGame;
@property bool isBlackLosing;

+ (GameState*)initWithDeletedPos:(int)pos and:(GameState*)prevState;
+ (GameState*)initWithMoveFrom:(int)from To:(int)to and:(GameState*)prevState;
+ (GameState*)init;

- (type)getTypeForPos:(int)pos;
- (void)printBoard;


@end
