//
//  SwiftRandomPlayer.swift
//  Sansumoku
//
//  Created by Maksim Khrapov on 9/29/19.
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

import Foundation

final class SwiftRandomPlayer: AIEngine {
    private var givenBoardState: BoardState
    
    
    init(_ givenBoardState: BoardState) {
        self.givenBoardState = givenBoardState
    }
    
    
    func setBoardState(_ bs: BoardState) {
        givenBoardState = bs
    }
    
    
    func search() -> (Int, Int) {
        let moves = givenBoardState.allLegalMoves()
        
        if moves.count == 0 {
            return (0, 0)
        }
        
        if(moves.count == 1) {
            return moves[0]
        }
        
        let randomIndex = Int.random(in: 0..<moves.count)
        return moves[randomIndex]
    }
}

