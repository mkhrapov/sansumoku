//
//  MonteCarloTreeSearch.swift
//  Sansumoku
//
//  Created by Maksim Khrapov on 4/21/19.
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


// This class is no longer used in the app, only in unit tests
final class MonteCarloTreeSearch {
    let boardState: BoardState
    
    
    init(_ boardState: BoardState) {
        self.boardState = boardState
    }
    
    
    func basic(_ iterCount: Int) -> (Int, Int) {
        let moves = boardState.allLegalMoves()
        let whoami = boardState.player
        var counts: [Double] = Array(repeating: 0.0, count: moves.count)
        
        for _ in 0..<iterCount {  // was c
            for i in 0..<counts.count {
                let (x, y) = moves[i]
                let child = boardState.clone()
                _ = child.set(x, y)
                let res = playout(child)
                if res == whoami {
                    counts[i] += 1.0
                }
                else if res == DONE {
                    counts[i] += 0.05
                }
            }
            
            /*
            print(c)
            if c % 100 == 0 {
                prettyPrint(counts)
            }
            */
        }
        
        let maxCount = counts.max()!
        let maxIndex = counts.firstIndex(of: maxCount)!
        
        //prettyPrint(counts)
        
        return moves[maxIndex]
    }
    
    
    func playout(_ state: BoardState) -> Int {
        let prev = state.clone()
        var x: Int = 0
        var y: Int = 0
        var madeMove: Bool = false
        
        while !state.isTerminal() {
            let moves = state.allLegalMoves()
            if moves.count == 0 {
                prev.display()
                state.display()
                fatalError("State is not terminal, but move count is zero.")
            }
            else if madeMove {
                _ = prev.set(x, y)
            }
            let index = Int.random(in: 0..<moves.count)
            (x, y) = moves[index]
            _ = state.set(x, y)
            madeMove = true
        }
        
        return state.gameWon
    }
    
    
    func prettyPrint(_ counts: [Double]) {
        for y in 0..<9 {
            for x in 0..<9 {
                let i = y*9 + x
                print(String(format: " %7.1f", counts[i]), terminator: "")
            }
            print()
        }
    }
}
