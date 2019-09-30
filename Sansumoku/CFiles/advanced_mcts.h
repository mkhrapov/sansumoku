//
//  advanced_mcts_cpp.h
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

#ifndef advanced_mcts_h
#define advanced_mcts_h

#include "board_state.h"

#ifdef __cplusplus
extern "C" {
#endif
    
int advanced_mcts_v1(int iter_count, board_state *);
    
#ifdef __cplusplus
}
#endif

#endif /* advanced_mcts_h */
