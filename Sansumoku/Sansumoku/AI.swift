//
//  AI.swift
//  Sansumoku
//
//  Created by Maksim Khrapov on 3/28/19.
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

final class AI {
    let givenBoardState: BoardState
    let aiLevelKey = "aiLevelKey"
    
    
    init(_ givenBoardState: BoardState) {
        self.givenBoardState = givenBoardState
    }
    
    
    func respondFast() -> (Int, Int) {
        let moves = [(3,3), (3, 5), (5,3), (5,5), (4,4)]
        let randomIndex = Int.random(in: 0..<moves.count)
        return moves[randomIndex]
    }
    
    
    func respond() -> (Int, Int) {
        let aiLevel = UserDefaults.standard.integer(forKey: aiLevelKey)
        switch aiLevel {
        case 0:
            let aiEngine = SwiftBasicPlayer(givenBoardState)
            return aiEngine.basicPlay()
        case 1:
            let aiEngine = CppConnector(givenBoardState)
            return aiEngine.bridge_to_c(100)
        default:
            let aiEngine = CppConnector(givenBoardState)
            return aiEngine.bridge_to_c(1000)
        }
    }
}
