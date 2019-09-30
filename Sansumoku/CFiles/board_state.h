//
//  board_state.h
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

#ifndef board_state_h
#define board_state_h

#include <inttypes.h>

typedef struct board_state {
    int8_t cellOccupied[81];
    int8_t cellValue[81];
    int8_t cellAllowed[81];
    int8_t sectionWon[9];
    int8_t sectionAllowed[9];
    int8_t sectionNextValue[9];
    int8_t player;
    int8_t gameWon;
} board_state;


#endif /* board_state_h */
