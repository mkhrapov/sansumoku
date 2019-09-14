//
//  BaseGameEngine.hpp
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

#ifndef BaseGameEngine_hpp
#define BaseGameEngine_hpp


#include "BoardState.hpp"


#include <random>
#include <chrono>

using namespace std;

class BaseGameEngine {
private:
    BoardState bs;
    default_random_engine generator;
    int iterations;
    
    int randomIntUnder(int);
    int8_t immediatelyWinningMove(BoardState &);
    vector<int8_t> calcSmartMoves(BoardState &);
    int8_t actualSearchFunction(vector<int8_t> &);
    int8_t naivePlayout(BoardState &);
    
public:
    BaseGameEngine(BoardState boardState);
    int search(int);
    // actual search function
};

#endif /* BaseGameEngine_hpp */
