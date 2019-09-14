//
//  BoardState.cpp
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

#include "BoardState.hpp"


static int section_locations[9][9] = {
    { 0,  1,  2,  9, 10, 11, 18, 19, 20},
    { 3,  4,  5, 12, 13, 14, 21, 22, 23},
    { 6,  7,  8, 15, 16, 17, 24, 25, 26},
    {27, 28, 29, 36, 37, 38, 45, 46, 47},
    {30, 31, 32, 39, 40, 41, 48, 49, 50},
    {33, 34, 35, 42, 43, 44, 51, 52, 53},
    {54, 55, 56, 63, 64, 65, 72, 73, 74},
    {57, 58, 59, 66, 67, 68, 75, 76, 77},
    {60, 61, 62, 69, 70, 71, 78, 79, 80}
};

static int list_of_indexes[8][3] = {
    {0, 1, 2},
    {3, 4, 5},
    {6, 7, 8},
    {0, 3, 6},
    {1, 4, 7},
    {2, 5, 8},
    {0, 4, 8},
    {2, 4, 6}
};

static int peers[81][16] = {
    {1, 2, 3, 4, 5, 6, 7, 8, 9, 18, 27, 36, 45, 54, 63, 72},
    {0, 2, 3, 4, 5, 6, 7, 8, 10, 19, 28, 37, 46, 55, 64, 73},
    {0, 1, 3, 4, 5, 6, 7, 8, 11, 20, 29, 38, 47, 56, 65, 74},
    {0, 1, 2, 4, 5, 6, 7, 8, 12, 21, 30, 39, 48, 57, 66, 75},
    {0, 1, 2, 3, 5, 6, 7, 8, 13, 22, 31, 40, 49, 58, 67, 76},
    {0, 1, 2, 3, 4, 6, 7, 8, 14, 23, 32, 41, 50, 59, 68, 77},
    {0, 1, 2, 3, 4, 5, 7, 8, 15, 24, 33, 42, 51, 60, 69, 78},
    {0, 1, 2, 3, 4, 5, 6, 8, 16, 25, 34, 43, 52, 61, 70, 79},
    {0, 1, 2, 3, 4, 5, 6, 7, 17, 26, 35, 44, 53, 62, 71, 80},
    {0, 10, 11, 12, 13, 14, 15, 16, 17, 18, 27, 36, 45, 54, 63, 72},
    {1, 9, 11, 12, 13, 14, 15, 16, 17, 19, 28, 37, 46, 55, 64, 73},
    {2, 9, 10, 12, 13, 14, 15, 16, 17, 20, 29, 38, 47, 56, 65, 74},
    {3, 9, 10, 11, 13, 14, 15, 16, 17, 21, 30, 39, 48, 57, 66, 75},
    {4, 9, 10, 11, 12, 14, 15, 16, 17, 22, 31, 40, 49, 58, 67, 76},
    {5, 9, 10, 11, 12, 13, 15, 16, 17, 23, 32, 41, 50, 59, 68, 77},
    {6, 9, 10, 11, 12, 13, 14, 16, 17, 24, 33, 42, 51, 60, 69, 78},
    {7, 9, 10, 11, 12, 13, 14, 15, 17, 25, 34, 43, 52, 61, 70, 79},
    {8, 9, 10, 11, 12, 13, 14, 15, 16, 26, 35, 44, 53, 62, 71, 80},
    {0, 9, 19, 20, 21, 22, 23, 24, 25, 26, 27, 36, 45, 54, 63, 72},
    {1, 10, 18, 20, 21, 22, 23, 24, 25, 26, 28, 37, 46, 55, 64, 73},
    {2, 11, 18, 19, 21, 22, 23, 24, 25, 26, 29, 38, 47, 56, 65, 74},
    {3, 12, 18, 19, 20, 22, 23, 24, 25, 26, 30, 39, 48, 57, 66, 75},
    {4, 13, 18, 19, 20, 21, 23, 24, 25, 26, 31, 40, 49, 58, 67, 76},
    {5, 14, 18, 19, 20, 21, 22, 24, 25, 26, 32, 41, 50, 59, 68, 77},
    {6, 15, 18, 19, 20, 21, 22, 23, 25, 26, 33, 42, 51, 60, 69, 78},
    {7, 16, 18, 19, 20, 21, 22, 23, 24, 26, 34, 43, 52, 61, 70, 79},
    {8, 17, 18, 19, 20, 21, 22, 23, 24, 25, 35, 44, 53, 62, 71, 80},
    {0, 9, 18, 28, 29, 30, 31, 32, 33, 34, 35, 36, 45, 54, 63, 72},
    {1, 10, 19, 27, 29, 30, 31, 32, 33, 34, 35, 37, 46, 55, 64, 73},
    {2, 11, 20, 27, 28, 30, 31, 32, 33, 34, 35, 38, 47, 56, 65, 74},
    {3, 12, 21, 27, 28, 29, 31, 32, 33, 34, 35, 39, 48, 57, 66, 75},
    {4, 13, 22, 27, 28, 29, 30, 32, 33, 34, 35, 40, 49, 58, 67, 76},
    {5, 14, 23, 27, 28, 29, 30, 31, 33, 34, 35, 41, 50, 59, 68, 77},
    {6, 15, 24, 27, 28, 29, 30, 31, 32, 34, 35, 42, 51, 60, 69, 78},
    {7, 16, 25, 27, 28, 29, 30, 31, 32, 33, 35, 43, 52, 61, 70, 79},
    {8, 17, 26, 27, 28, 29, 30, 31, 32, 33, 34, 44, 53, 62, 71, 80},
    {0, 9, 18, 27, 37, 38, 39, 40, 41, 42, 43, 44, 45, 54, 63, 72},
    {1, 10, 19, 28, 36, 38, 39, 40, 41, 42, 43, 44, 46, 55, 64, 73},
    {2, 11, 20, 29, 36, 37, 39, 40, 41, 42, 43, 44, 47, 56, 65, 74},
    {3, 12, 21, 30, 36, 37, 38, 40, 41, 42, 43, 44, 48, 57, 66, 75},
    {4, 13, 22, 31, 36, 37, 38, 39, 41, 42, 43, 44, 49, 58, 67, 76},
    {5, 14, 23, 32, 36, 37, 38, 39, 40, 42, 43, 44, 50, 59, 68, 77},
    {6, 15, 24, 33, 36, 37, 38, 39, 40, 41, 43, 44, 51, 60, 69, 78},
    {7, 16, 25, 34, 36, 37, 38, 39, 40, 41, 42, 44, 52, 61, 70, 79},
    {8, 17, 26, 35, 36, 37, 38, 39, 40, 41, 42, 43, 53, 62, 71, 80},
    {0, 9, 18, 27, 36, 46, 47, 48, 49, 50, 51, 52, 53, 54, 63, 72},
    {1, 10, 19, 28, 37, 45, 47, 48, 49, 50, 51, 52, 53, 55, 64, 73},
    {2, 11, 20, 29, 38, 45, 46, 48, 49, 50, 51, 52, 53, 56, 65, 74},
    {3, 12, 21, 30, 39, 45, 46, 47, 49, 50, 51, 52, 53, 57, 66, 75},
    {4, 13, 22, 31, 40, 45, 46, 47, 48, 50, 51, 52, 53, 58, 67, 76},
    {5, 14, 23, 32, 41, 45, 46, 47, 48, 49, 51, 52, 53, 59, 68, 77},
    {6, 15, 24, 33, 42, 45, 46, 47, 48, 49, 50, 52, 53, 60, 69, 78},
    {7, 16, 25, 34, 43, 45, 46, 47, 48, 49, 50, 51, 53, 61, 70, 79},
    {8, 17, 26, 35, 44, 45, 46, 47, 48, 49, 50, 51, 52, 62, 71, 80},
    {0, 9, 18, 27, 36, 45, 55, 56, 57, 58, 59, 60, 61, 62, 63, 72},
    {1, 10, 19, 28, 37, 46, 54, 56, 57, 58, 59, 60, 61, 62, 64, 73},
    {2, 11, 20, 29, 38, 47, 54, 55, 57, 58, 59, 60, 61, 62, 65, 74},
    {3, 12, 21, 30, 39, 48, 54, 55, 56, 58, 59, 60, 61, 62, 66, 75},
    {4, 13, 22, 31, 40, 49, 54, 55, 56, 57, 59, 60, 61, 62, 67, 76},
    {5, 14, 23, 32, 41, 50, 54, 55, 56, 57, 58, 60, 61, 62, 68, 77},
    {6, 15, 24, 33, 42, 51, 54, 55, 56, 57, 58, 59, 61, 62, 69, 78},
    {7, 16, 25, 34, 43, 52, 54, 55, 56, 57, 58, 59, 60, 62, 70, 79},
    {8, 17, 26, 35, 44, 53, 54, 55, 56, 57, 58, 59, 60, 61, 71, 80},
    {0, 9, 18, 27, 36, 45, 54, 64, 65, 66, 67, 68, 69, 70, 71, 72},
    {1, 10, 19, 28, 37, 46, 55, 63, 65, 66, 67, 68, 69, 70, 71, 73},
    {2, 11, 20, 29, 38, 47, 56, 63, 64, 66, 67, 68, 69, 70, 71, 74},
    {3, 12, 21, 30, 39, 48, 57, 63, 64, 65, 67, 68, 69, 70, 71, 75},
    {4, 13, 22, 31, 40, 49, 58, 63, 64, 65, 66, 68, 69, 70, 71, 76},
    {5, 14, 23, 32, 41, 50, 59, 63, 64, 65, 66, 67, 69, 70, 71, 77},
    {6, 15, 24, 33, 42, 51, 60, 63, 64, 65, 66, 67, 68, 70, 71, 78},
    {7, 16, 25, 34, 43, 52, 61, 63, 64, 65, 66, 67, 68, 69, 71, 79},
    {8, 17, 26, 35, 44, 53, 62, 63, 64, 65, 66, 67, 68, 69, 70, 80},
    {0, 9, 18, 27, 36, 45, 54, 63, 73, 74, 75, 76, 77, 78, 79, 80},
    {1, 10, 19, 28, 37, 46, 55, 64, 72, 74, 75, 76, 77, 78, 79, 80},
    {2, 11, 20, 29, 38, 47, 56, 65, 72, 73, 75, 76, 77, 78, 79, 80},
    {3, 12, 21, 30, 39, 48, 57, 66, 72, 73, 74, 76, 77, 78, 79, 80},
    {4, 13, 22, 31, 40, 49, 58, 67, 72, 73, 74, 75, 77, 78, 79, 80},
    {5, 14, 23, 32, 41, 50, 59, 68, 72, 73, 74, 75, 76, 78, 79, 80},
    {6, 15, 24, 33, 42, 51, 60, 69, 72, 73, 74, 75, 76, 77, 79, 80},
    {7, 16, 25, 34, 43, 52, 61, 70, 72, 73, 74, 75, 76, 77, 78, 80},
    {8, 17, 26, 35, 44, 53, 62, 71, 72, 73, 74, 75, 76, 77, 78, 79}
};







BoardState::BoardState() {
    // initial board state
    
    cout << "Inside the empty constructor." << endl;
    
    _gameWon = OPEN;
    _player = BLUE;
    
    for(int i = 0; i < 9; i++) {
        sectionNextValue[i] = 1;
        sectionWon[i] = OPEN;
        sectionAllowed[i] = true;
    }
    
    for(int i = 0; i < 81; i++) {
        cellOccupied[i] = OPEN;
        cellValue[i] = OPEN;
        cellAllowed[i] = true;
    }
}


BoardState::BoardState(board_state *bs) {
    // board state as copied from bs pointer
    
    cout << "Inside the pointer constructor." << endl;
    
    _gameWon = bs->gameWon;
    _player = bs->player;
    
    for(int i = 0; i < 9; i++) {
        sectionNextValue[i] = bs->sectionNextValue[i];
        sectionWon[i] = bs->sectionWon[i];
        sectionAllowed[i] = bs->sectionAllowed[i];
    }
    
    for(int i = 0; i < 81; i++) {
        cellOccupied[i] = OPEN;
        cellValue[i] = OPEN;
        cellAllowed[i] = true;
    }
}


bool BoardState::isInitialState() {
    for(int i = 0; i < 81; i++) {
        if(cellOccupied[i] != 0) {
            return false;
        }
    }
    return true;
}


bool BoardState::isTerminal() {
    return _gameWon != OPEN;
}


int8_t BoardState::getPlayer() {
    return _player;
}


int8_t BoardState::getGameWon() {
    return _gameWon;
}


bool BoardState::isWonBy(int8_t p) {
    return _gameWon == p;
}


vector<int8_t> BoardState::legalMoves() {
    vector<int8_t> moves;
    
    if(_gameWon != OPEN) {
        return moves;
    }
    
    for(int8_t move = 0; move < 81; move++) {
        if(cellAllowed[move]) {
            moves.push_back(move);
        }
    }
    
    return moves;
}


void BoardState::set(int8_t move) {
    if(!isLegalMove(move)) {
        return;
    }
    
    int8_t currentSection = ownSection(move);
    
    cellOccupied[move] = _player;
    cellValue[move] = sectionNextValue[currentSection];
    sectionNextValue[currentSection] += 1;
    
    if(won(_player, currentSection)) {
        sectionWon[currentSection] = _player;
        if(entireGameWonBy(_player)) {
            _gameWon = _player;
        }
        else if(entireBoardIsFull()) {
            _gameWon = DONE;
        }
    }
    else if(full(currentSection)) {
        sectionWon[currentSection] = DONE;
        if(entireBoardIsFull()) {
            _gameWon = DONE;
        }
    }
    
    /* zero out allowed cells and sections */
    for(int i = 0; i < 9; i++) {
        sectionAllowed[i] = 0;
    }
    
    for(int i = 0; i < 81; i++) {
        cellAllowed[i] = 0;
    }
    
    /* figure out allowed sections */
    int nextSection = targetSection(move);
    if(sectionWon[nextSection] == OPEN) {
        sectionAllowed[nextSection] = 1;
    }
    else {
        for(int i = 0; i < 9; i++) {
            if(sectionWon[i] == OPEN) {
                sectionAllowed[i] = 1;
            }
        }
    }
    
    /* figure out allowed cells */
    for(int section = 0; section < 9; section++) {
        if(sectionAllowed[section]) {
            for(int cell_idx = 0; cell_idx < 9; cell_idx++) {
                int cell = section_locations[section][cell_idx];
                if(cellOccupied[cell] == OPEN && !sudokuConstrained(cell)) {
                    cellAllowed[cell] = true;
                }
            }
        }
    }
    
    recursiveConstraintProcessing();
    
    if(_player == BLUE) {
        _player = ORAN;
    }
    else {
        _player = BLUE;
    }
}


void BoardState::recursiveConstraintProcessing() {
    if(isTerminal()) {
        return;
    }
    
    if(!noAllowedCells()) {
        return;
    }
    
    /*
     opponent can not make a play, all cells in allowed sections are either
     occupied or prohibited by sudoku constraints. We break this deadend
     by scoring the allowed sections for the player, and allowing opponent
     to play in any non-won, non-full sections.
     */
    
    for(int sec = 0; sec < 9; sec++) {
        if(sectionAllowed[sec]) {
            sectionWon[sec] = _player;
        }
    }
    
    if(entireGameWonBy(_player)) {
        _gameWon = _player;
    }
    else if(entireBoardIsFull()) {
        _gameWon = DONE;
    }
    else {
        /* zero out allowed cells and sections */
        for(int i = 0; i < 9; i++) {
            sectionAllowed[i] = false;
        }
        
        for(int i = 0; i < 81; i++) {
            cellAllowed[i] = false;
        }
        
        /* figure out allowed sections */
        for(int i = 0; i < 9; i++) {
            if(sectionWon[i] == OPEN) {
                sectionAllowed[i] = true;
            }
        }
        
        /* figure out allowed cells */
        for(int sec = 0; sec < 9; sec++) {
            if(sectionAllowed[sec]) {
                for(int cell_idx = 0; cell_idx < 9; cell_idx++) {
                    int cell = section_locations[sec][cell_idx];
                    if(cellOccupied[cell] == OPEN && !sudokuConstrained(cell)) {
                        cellAllowed[cell] = true;
                    }
                }
            }
        }
    }
    
    recursiveConstraintProcessing();
}


bool BoardState::sudokuConstrained(int8_t cell) {
    int8_t section = ownSection(cell);
    int8_t digit = sectionNextValue[section];
    
    for(int i = 0; i < 16; i++) {
        int8_t location = peers[cell][i];
        if(active(location)) {
            if(cellValue[location] == digit) {
                return true;
            }
        }
    }
    return false;
}


bool BoardState::active(int8_t cell) {
    int8_t section = ownSection(cell);
    if(sectionWon[section] == BLUE || sectionWon[section] == ORAN) {
        return false;
    }
    return true;
}


bool BoardState::full(int8_t section) {
    for(int i = 0; i < 9; i++) {
        int location = section_locations[section][i];
        if(cellOccupied[location] == OPEN) {
            return false;
        }
    }
    return true;
}


bool BoardState::entireGameWonBy(int8_t player) {
    for(int row = 0; row < 8; row++) {  /* row in list_of_indexes */
        int sec1 = list_of_indexes[row][0];
        int sec2 = list_of_indexes[row][1];
        int sec3 = list_of_indexes[row][2];
        
        if(
           sectionWon[sec1] == player &&
           sectionWon[sec2] == player &&
           sectionWon[sec3] == player
           ) {
            return true;
        }
    }
    
    return false;
}


bool BoardState::entireBoardIsFull() {
    for(int i = 0; i < 9; i++) {
        if(sectionWon[i] == OPEN) {
            return false;
        }
    }
    
    return true;
}


bool BoardState::won(int8_t player, int8_t section) {
    for(int row = 0; row < 8; row++) {  /* row in list_of_indexes */
        int relative_position1 = list_of_indexes[row][0];
        int relative_position2 = list_of_indexes[row][1];
        int relative_position3 = list_of_indexes[row][2];
        
        int actual_position1 = section_locations[section][relative_position1];
        int actual_position2 = section_locations[section][relative_position2];
        int actual_position3 = section_locations[section][relative_position3];
        
        if(
           cellOccupied[actual_position1] == player &&
           cellOccupied[actual_position2] == player &&
           cellOccupied[actual_position3] == player
           ) {
            return true;
        }
    }
    
    return false;
}


bool BoardState::isLegalMove(int8_t move) {
    if(_gameWon != OPEN) {
        return false;
    }
    
    if(move < 0 || move > 80) {
        return false;
    }
    
    return cellAllowed[move];
}


int8_t BoardState::ownSection(int8_t move) {
    int8_t y = move / 9;
    int8_t x = move % 9;
    return 3*(y/3) + (x/3);
}


int8_t BoardState::targetSection(int8_t move) {
    int8_t y = move / 9;
    int8_t x = move % 9;
    return 3*(y%3) + (x%3);
}


bool BoardState::noAllowedCells() {
    for(int i = 0; i < 81; i++) {
        if(cellAllowed[i]) {
            return false;
        }
    }
    return true;
}
