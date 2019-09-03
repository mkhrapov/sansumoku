//
//  SwiftBasicPlayer.swift
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

import Foundation

final class SwiftBasicPlayer {
    private let givenBoardState: BoardState
    
    
    init(_ givenBoardState: BoardState) {
        self.givenBoardState = givenBoardState
    }
    
    
    func basicPlay() -> (Int, Int) {
        let moves = givenBoardState.allLegalMoves()
        
        if moves.count == 0 {
            return (0, 0)
        }
        
        if(moves.count == 1) {
            return moves[0]
        }
        
        if let move = immediatelyWinningMove(givenBoardState) {
            return move
        }
        
        // no immediately winning move
        let smartMoves = getSmartMoves(givenBoardState)
        
        if smartMoves.count == 0 {
            //select a random move from all moves
            let randomIndex = Int.random(in: 0..<moves.count)
            return moves[randomIndex]
        }
        else if smartMoves.count == 1 {
            // That's the one
            return smartMoves[0]
        }
        else {
            // More than one, select a random smart move
            let randomIndex = Int.random(in: 0..<smartMoves.count)
            return smartMoves[randomIndex]
        }
    }
    
    
    private func immediatelyWinningMove(_ givenBoardState: BoardState) -> (Int, Int)? {
        let whoami = givenBoardState.player
        let moves = givenBoardState.allLegalMoves()
        
        for (x, y) in moves {
            let child = givenBoardState.clone()
            _ = child.set(x, y)
            if child.isTerminal() && child.gameWon == whoami {
                return (x, y)
            }
        }
        
        return nil
    }
    
    
    private func getSmartMoves(_ givenBoardState: BoardState) -> [(Int, Int)] {
        var smartMoves = [(Int, Int)]()
        
        let moves = givenBoardState.allLegalMoves()
        
        for (x, y) in moves {
            let child = givenBoardState.clone()
            _ = child.set(x, y)
            
            if immediatelyWinningMove(child) == nil {
                smartMoves.append((x, y))
            }
        }
        
        return smartMoves
    }
}
