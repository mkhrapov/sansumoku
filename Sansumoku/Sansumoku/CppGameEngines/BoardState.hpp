//
//  BoardState.hpp
//  Sansumoku
//
//  Created by Maksim Khrapov on 9/6/19.
//  Copyright © 2019 Maksim Khrapov. All rights reserved.
//

// https://www.sansumoku.com/
// https://github.com/mkhrapov/sansumoku
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#ifndef BoardState_hpp
#define BoardState_hpp

#include "board_state.h"

#include <cstdint>
#include <vector>
#include <iostream>

using namespace std;

#define OPEN 0
#define BLUE 1
#define ORAN 2
#define DONE 3


class BoardState {
private:
    int8_t _player;
    int8_t _gameWon;
    
    int8_t sectionWon[9];
    int8_t sectionNextValue[9];
    bool sectionAllowed[9];
    
    int8_t cellOccupied[81];
    int8_t cellValue[81];
    bool cellAllowed[81];
    
    
    
    
public:
    BoardState();
    BoardState(board_state *);
    
    bool isInitialState();
    bool isTerminal();
    int8_t getPlayer();
    int8_t getGameWon();
    bool isWonBy(int8_t);
    vector<int8_t> legalMoves();
    void set(int8_t);
    bool isLegalMove(int8_t);
    int8_t ownSection(int8_t);
    bool won(int8_t, int8_t);
    bool entireGameWonBy(int8_t);
    bool entireBoardIsFull();
    bool full(int8_t);
    int8_t targetSection(int8_t);
    bool sudokuConstrained(int8_t);
    void recursiveConstraintProcessing();
    bool active(int8_t);
    bool noAllowedCells();
};




#endif /* BoardState_hpp */
