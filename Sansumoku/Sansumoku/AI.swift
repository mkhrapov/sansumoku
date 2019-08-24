//
//  AI.swift
//  Sansumoku
//
//  Created by Maksim Khrapov on 3/28/19.
//  Copyright © 2019 Maksim Khrapov. All rights reserved.
//

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
        let moves = givenBoardState.allLegalMoves()
        if moves.count == 0 {
            return (0, 0)
        }
        
        if(moves.count == 1) {
            return moves[0]
        }
        
        let whoami = givenBoardState.player
        
        // check for immediately winning move
        for i in 0..<moves.count {
            let (x, y) = moves[i]
            let child = givenBoardState.clone()
            _ = child.set(x, y)
            if child.isTerminal() && child.gameWon == whoami {
                return (x, y)
            }
        }
        
        // no immediately winning move
        let aiLevel = UserDefaults.standard.integer(forKey: aiLevelKey)
        if aiLevel == 0 {
            return basicallyRandomMove()
        }
        else {
            return basicMonteCarloTreeSearch(aiLevel)
        }
    }
    
    
    func basicallyRandomMove() -> (Int, Int) {
        let moves = givenBoardState.allLegalMoves()
        let randomIndex = Int.random(in: 0..<moves.count)
        return moves[randomIndex]
    }
    
    
    func basicMonteCarloTreeSearch(_ aiLevel: Int) -> (Int, Int) {
        let aiIterations: Int
        switch aiLevel {
        case 1: aiIterations = 100
        case 2: aiIterations = 1000
        default: aiIterations = 100
        }
        
        let aiEngine = MonteCarloTreeSearch(givenBoardState)
        return aiEngine.bridge_to_c(aiIterations)
    }
}
