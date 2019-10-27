//
//  SwiftGKMCPlayer.swift
//  Sansumoku
//
//  Created by Maksim Khrapov on 9/28/19.
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
import GameplayKit

final class SwiftGKMCPlayer: AIEngine {
    private var givenBoardState: BoardState
    
    
    init(_ givenBoardState: BoardState) {
        self.givenBoardState = givenBoardState
    }
    
    
    func setBoardState(_ bs: BoardState) {
        givenBoardState = bs
    }
    
    
    func search() -> (Int, Int) {
        if #available(iOS 10.0, *) {
            if givenBoardState.isInitialState() {
                // use precomputed value
                let moves = [(3,3), (3, 5), (5,3), (5,5), (4,4)]
                let randomIndex = Int.random(in: 0..<moves.count)
                return moves[randomIndex]
            }
            
            
            let strategist = GKMonteCarloStrategist()
            strategist.budget = 81
            strategist.explorationParameter = 4
            strategist.randomSource = GKRandomSource()
            strategist.gameModel = GameModel(givenBoardState.clone())
            
            let start = Date()
            let moveWrapper = strategist.bestMoveForActivePlayer()
            let end = Date()
            let duration = DateInterval(start: start, end: end)
            print("Duration: \(duration.duration)")
            
            
            if let move = moveWrapper as? Move {
                return (move.x, move.y)
            }
            
            // all failed; return an invalid move
            return (-1, -1)
        }
        else {
            return SwiftBasicPlayer(givenBoardState).search()
        }
    }
    
    
    final class GameModel: NSObject, GKGameModel {
        var players: [GKGameModelPlayer]?
        var activePlayer: GKGameModelPlayer?
        
        var bs: BoardState
        
        
        init(_ bs: BoardState) {
            self.bs = bs
            let blue = GameModelPlayer(BLUE)
            let orange = GameModelPlayer(ORAN)
            players = [blue, orange]
            activePlayer = players![bs.player - 1]
        }
        
        
        func setGameModel(_ gameModel: GKGameModel) {
            if let other = gameModel as? GameModel {
                self.bs = other.bs.clone()
                activePlayer = players![bs.player - 1]
            }
        }
        
        
        func gameModelUpdates(for player: GKGameModelPlayer) -> [GKGameModelUpdate]? {
            var moves: [GKGameModelUpdate] = []
            
            for (x, y) in bs.allLegalMoves() {
                moves.append(Move(x, y))
            }
            
            return moves
        }
        
        
        func apply(_ gameModelUpdate: GKGameModelUpdate) {
            if let move = gameModelUpdate as? Move {
                bs.set(move.x, move.y)
                activePlayer = players![bs.player - 1]
            }
        }
        
        
        func copy(with zone: NSZone? = nil) -> Any {
            let copy = GameModel(bs.clone())
            return copy
        }
        
        
        func isWin(for i: GKGameModelPlayer) -> Bool {
            return i.playerId == bs.gameWon
        }
        
        
        func isLoss(for i: GKGameModelPlayer) -> Bool {
            if i.playerId == 1 {
                return bs.gameWon == 2
            }
            else {
                return bs.gameWon == 1
            }
        }
    }
    
    
    final class GameModelPlayer: NSObject, GKGameModelPlayer {
        var playerId: Int
        
        init(_ id: Int) {
            playerId = id
        }
    }
    
    
    final class Move: NSObject, GKGameModelUpdate {
        var value: Int
        let x: Int
        let y: Int
        
        
        init(_ x: Int, _ y: Int) {
            value = 0
            self.x = x
            self.y = y
        }
    }
}
