//
//  BaseGameEngine.cpp
//  Sansumoku
//
//  Created by Maksim Khrapov on 9/2/19.
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





#include "BaseGameEngine.hpp"


BaseGameEngine::BaseGameEngine(BoardState boardState) {
    bs = boardState;
    iterations = 1000;
    
    unsigned int seed = chrono::high_resolution_clock::now().time_since_epoch().count() % 2147483647;
    generator.seed(seed);
}


int BaseGameEngine::search(int iter) {
    iterations = iter;
    
    if(bs.isInitialState()) {
        // return one of the precomputed values
        // (3, 3) (5, 3) (4, 4) (5, 3) (5, 5)
        int8_t precomp[] = {30, 32, 40, 48, 50};
        return precomp[randomIntUnder(5)];
    }
    
    vector<int8_t> legalMoves = bs.legalMoves();
    if(legalMoves.size() == 0) {
        return 0;
    }
    else if(legalMoves.size() == 1) {
        return legalMoves[0];
    }
    
    int8_t winningMove = immediatelyWinningMove(bs);
    if(winningMove > -1) {
        return winningMove;
    }
    
    // no winning move, check for dumb moves
    vector<int8_t> smartMoves = calcSmartMoves(bs);
    
    if(smartMoves.size() == 0) {
        // no smart moves. return random legal move.
        return legalMoves[randomIntUnder(int(legalMoves.size()))];
    }
    else if(smartMoves.size() == 1) {
        return smartMoves[0];
    }
    
    
    // more than one smart move. Perform search
    return actualSearchFunction(smartMoves);
}


int BaseGameEngine::randomIntUnder(int limit) {
    uniform_int_distribution<int> distribution(0, limit - 1);
    return distribution(generator);
}


// returns immediately winning move or -1 if no such move.
int8_t BaseGameEngine::immediatelyWinningMove(BoardState &board_state) {
    int whoami = board_state.getPlayer();
    
    for(int8_t move: board_state.legalMoves()) {
        BoardState child = board_state;
        child.set(move);
        if(child.isWonBy(whoami)) {
            return move;
        }
    }
    
    return -1;
}


vector<int8_t> BaseGameEngine::calcSmartMoves(BoardState &board_state) {
    vector<int8_t> smartMoves;
    
    for(int8_t move : board_state.legalMoves()) {
        BoardState child = board_state;
        child.set(move);
        
        if(immediatelyWinningMove(child) == -1) {
            smartMoves.push_back(move);
        }
    }
    
    return smartMoves;
}


// naive Monte Carlo Tree Search
int8_t BaseGameEngine::actualSearchFunction(vector<int8_t> &smartMoves) {
    float scores[81];
    
    for(int counter = 0; counter < iterations; counter++) {
        for(int8_t move : smartMoves) {
            BoardState child = bs;
            child.set(move);
            int8_t winner = naivePlayout(child);
            if (winner == bs.getPlayer()) {
                scores[move] += 1.0;
            }
            else if (winner == DONE) {
                scores[move] += 0.05;
            }
        }
    }
    
    float max = 0.0;
    int winning_move = 0;
    
    for(int i = 0; i < 81; i++) {
        if (scores[i] > max) {
            winning_move = i;
            max = scores[i];
        }
    }
    
    return winning_move;
}


int8_t BaseGameEngine::naivePlayout(BoardState &board_state) {
    while(!board_state.isTerminal()) {
        vector<int8_t> legalMoves = board_state.legalMoves();
        int8_t randomMove = legalMoves[randomIntUnder(int(legalMoves.size()))];
        board_state.set(randomMove);
    }
    
    return board_state.getGameWon();
}
