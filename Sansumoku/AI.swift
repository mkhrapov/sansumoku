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
    
    
    func respond() -> (Int, Int) {
        let aiLevel = UserDefaults.standard.integer(forKey: aiLevelKey)
        let aiEngine: AIEngine = {
            switch aiLevel {
            case 0:
                return SwiftRandomPlayer(givenBoardState)
            case 1:
                return SwiftBasicPlayer(givenBoardState)
            case 2:
                return SwiftGKMCPlayer(givenBoardState)
            case 3:
                return ConnectorV1(givenBoardState)
            case 4:
                return ConnectorOldC(givenBoardState)
            default:
                return ConnectorOldC(givenBoardState)
            }
        }()
        
        return aiEngine.search()
    }
}
