//
//  BoardState.swift
//  Sansumoku
//
//  Created by Maksim Khrapov on 1/22/19.
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


let OPEN = 0
let BLUE = 1
let ORAN = 2
let DONE = 3


var sudokuGroups: [Set<Int>] = {
    var g = [Set<Int>]()
    
    g.append(Set<Int>([ 0,  1,  2,  3,  4,  5,  6,  7,  8]))
    g.append(Set<Int>([ 9, 10, 11, 12, 13, 14, 15, 16, 17]))
    g.append(Set<Int>([18, 19, 20, 21, 22, 23, 24, 25, 26]))
    g.append(Set<Int>([27, 28, 29, 30, 31, 32, 33, 34, 35]))
    g.append(Set<Int>([36, 37, 38, 39, 40, 41, 42, 43, 44]))
    g.append(Set<Int>([45, 46, 47, 48, 49, 50, 51, 52, 53]))
    g.append(Set<Int>([54, 55, 56, 57, 58, 59, 60, 61, 62]))
    g.append(Set<Int>([63, 64, 65, 66, 67, 68, 69, 70, 71]))
    g.append(Set<Int>([72, 73, 74, 75, 76, 77, 78, 79, 80]))
    
    g.append(Set<Int>([ 0,  9, 18, 27, 36, 45, 54, 63, 72]))
    g.append(Set<Int>([ 1, 10, 19, 28, 37, 46, 55, 64, 73]))
    g.append(Set<Int>([ 2, 11, 20, 29, 38, 47, 56, 65, 74]))
    g.append(Set<Int>([ 3, 12, 21, 30, 39, 48, 57, 66, 75]))
    g.append(Set<Int>([ 4, 13, 22, 31, 40, 49, 58, 67, 76]))
    g.append(Set<Int>([ 5, 14, 23, 32, 41, 50, 59, 68, 77]))
    g.append(Set<Int>([ 6, 15, 24, 33, 42, 51, 60, 69, 78]))
    g.append(Set<Int>([ 7, 16, 25, 34, 43, 52, 61, 70, 79]))
    g.append(Set<Int>([ 8, 17, 26, 35, 44, 53, 62, 71, 80]))
    
    // not adding cells in each section because those are tracked via other means
    
    return g
}()


final class BoardState {
    var cellOccupied: [Int] // OPEN, BLUE, ORAN
    var cellValue: [Int] // 0 - 9: zero if cell empty, 1 - 9 if cell played
    var sectionWon: [Int] // OPEN, BLUE, ORAN, DONE: done means full, but not won
    var sectionAllowed: [Bool] // which section is allowed on next move
    var sectionNextValue: [Int]
    var cellAllowed: [Bool]
    var sectionWonByConstraint: [Bool]
    
    var player: Int
    var gameWon: Int // OPEN if not won yet, DONE if a draw
    
    var finalStrikeStart: Int = -1
    var finalStrikeEnd: Int = -1
    
    var mostRecent: Int = 100
    
    
    init() {
        gameWon = OPEN
        player = BLUE
        cellOccupied = Array(repeating: OPEN, count: 81)
        cellValue = Array(repeating: OPEN, count: 81)
        sectionNextValue = Array(repeating: 1, count: 9)
        sectionWon = Array(repeating: OPEN, count: 9)
        sectionAllowed = Array(repeating: true, count: 9)
        cellAllowed = Array(repeating: true, count: 81)
        sectionWonByConstraint = Array(repeating: false, count: 9)
    }
    
    
    func isTerminal() -> Bool {
        return gameWon != OPEN
    }
    
    
    func allLegalMoves() -> [(Int, Int)] {
        var res: [(Int, Int)] = []
        
        for x in 0..<9 {
            for y in 0..<9 {
                if legalPlay(x, y) {
                    res.append((x, y))
                }
            }
        }
        
        return res
    }
    
    
    func clone() -> BoardState {
        let child = BoardState()
        
        child.gameWon = self.gameWon
        child.player = self.player
        child.cellOccupied = self.cellOccupied
        child.cellValue = self.cellValue
        child.sectionNextValue = self.sectionNextValue
        child.sectionWon = self.sectionWon
        child.sectionAllowed = self.sectionAllowed
        child.cellAllowed = self.cellAllowed
        child.sectionWonByConstraint = self.sectionWonByConstraint
        
        return child
    }
    
    
    func legalPlay(_ x: Int, _ y: Int) -> Bool {
        if gameWon != OPEN {
            return false
        }
        
        if x < 0 || x > 8 || y < 0 || y > 8 {
            return false
        }
        
        let cell = y*9 + x
        
        if !cellAllowed[cell] {
            return false
        }
        
        return true
    }
    
    
    // this function is very complicated. It contains basically all the game logic.
    func set(_ x: Int, _ y: Int) -> Bool {
        if !legalPlay(x, y) {
            return false
        }
        
        let cell = y*9 + x
        let section = ownSection(x, y)
        mostRecent = cell
        
        // set position
        cellOccupied[cell] = player
        cellValue[cell] = sectionNextValue[section]
        sectionNextValue[section] += 1
        
        if won(player, section) {
            sectionWon[section] = player
            if entireGameWon(by: player) {
                gameWon = player
            }
            else if entireBoardIsFull() {
                gameWon = DONE
            }
        }
        else if full(section) {
            sectionWon[section] = DONE
            if entireBoardIsFull() {
                gameWon = DONE
            }
        }
        
        // zero out allowed cells and sections
        for i in 0..<9 {
            sectionAllowed[i] = false
        }
        
        for i in 0..<81 {
            cellAllowed[i] = false
        }
        
        // figure out allowed sections
        let nextSection = targetSection(x, y)
        if sectionWon[nextSection] == OPEN {
            sectionAllowed[nextSection] = true
        }
        else {
            for i in 0..<9 {
                if sectionWon[i] == OPEN {
                    sectionAllowed[i] = true
                }
            }
        }
        
        // figure out allowed cells
        for s in 0..<9 {
            if sectionAllowed[s] {
                let cells = sectionLocations(s)
                for i in cells {
                    if cellOccupied[i] == OPEN && !sudokuConstrained(i) {
                        cellAllowed[i] = true
                    }
                }
            }
        }
        
        recursiveConstraintProcessing()
        
        // finishing touches
        if player == BLUE {
            player = ORAN
        }
        else {
            player = BLUE
        }
        
        return true
    }
    
    
    func recursiveConstraintProcessing() {
        if isTerminal() {
            return
        }
        
        if !noAllowedCells() {
            return
        }
        
        
        // opponent can not make a play, all cells in allowed sections are either
        // occupied or prohibited by sudoku constraints. We break this deadend
        // by scoring the allowed sections for the player, and allowing opponent
        // to play in any non-won, non-full sections.
        
        for i in 0..<9 {
            if sectionAllowed[i] {
                sectionWon[i] = player
                sectionWonByConstraint[i] = true
            }
        }
        
        if entireGameWon(by: player) {
            gameWon = player
        }
        else if entireBoardIsFull() {
            gameWon = DONE
        }
        else {
            for i in 0..<9 {
                sectionAllowed[i] = false
            }
            
            for i in 0..<9 {
                if sectionWon[i] == OPEN {
                    sectionAllowed[i] = true
                }
            }
            
            // figure out allowed cells
            for s in 0..<9 {
                if sectionAllowed[s] {
                    let cells = sectionLocations(s)
                    for i in cells {
                        if cellOccupied[i] == OPEN && !sudokuConstrained(i) {
                            cellAllowed[i] = true
                        }
                    }
                }
            }
        }
        
        recursiveConstraintProcessing()
        
    }
    
    
    func ownSection(_ x: Int, _ y: Int) -> Int {
        return 3*(y/3) + (x/3)
    }
    
    
    func ownSection(_ i: Int) -> Int {
        let y = i / 9
        let x = i % 9
        return ownSection(x, y)
    }
    
    
    func targetSection(_ x: Int, _ y: Int) -> Int {
        return 3*(y%3) + (x%3)
    }
    
    
    func won(_ player: Int, _ section: Int) -> Bool {
        let locations = sectionLocations(section)
        
        let listOfIndexes = [
            [0, 1, 2],
            [3, 4, 5],
            [6, 7, 8],
            [0, 3, 6],
            [1, 4, 7],
            [2, 5, 8],
            [0, 4, 8],
            [2, 4, 6]
        ]
        
        
        for indexes in listOfIndexes {
            if  cellOccupied[locations[indexes[0]]] == player &&
                cellOccupied[locations[indexes[1]]] == player &&
                cellOccupied[locations[indexes[2]]] == player {
                return true
            }
        }
        
        return false
    }
    
    
    func sectionLocations(_ section: Int) -> [Int] {
        var locations = [0, 1, 2, 9, 10, 11, 18, 19, 20]
        
        if section < 3 {
            for i in 0..<9 {
                locations[i] += section*3
            }
        }
        else if section < 6 {
            for i in 0..<9 {
                locations[i] += 27 + (section - 3)*3
            }
        }
        else {
            for i in 0..<9 {
                locations[i] += 54 + (section - 6)*3
            }
        }
        
        return locations
    }
    
    
    func full(_ section: Int) -> Bool {
        let locations = sectionLocations(section)
        
        for i in locations {
            if cellOccupied[i] == OPEN {
                return false
            }
        }
        return true
    }
    
    
    func entireBoardIsFull() -> Bool {
        for section in 0..<9 {
            if sectionWon[section] == OPEN {
                return false
            }
        }
        return true
    }
    
    
    func entireGameWon(by player: Int) -> Bool {
        let listOfIndexes = [
            [0, 1, 2],
            [3, 4, 5],
            [6, 7, 8],
            [0, 3, 6],
            [1, 4, 7],
            [2, 5, 8],
            [0, 4, 8],
            [2, 4, 6]
        ]
        
        for indexes in listOfIndexes {
            if  sectionWon[indexes[0]] == player &&
                sectionWon[indexes[1]] == player &&
                sectionWon[indexes[2]] == player     {
                finalStrikeStart = indexes[0]
                finalStrikeEnd = indexes[2]
                return true
            }
        }
        return false
    }
    
    
    func sudokuConstrained(_ cell: Int) -> Bool {
        let section = ownSection(cell)
        let digit = sectionNextValue[section]
        
        for otherCell in peers(cell) {
            if cellValue[otherCell] == digit {
                return true
            }
        }
        
        return false
    }
    
    
    func peers(_ cell: Int) -> Set<Int> {
        var p = Set<Int>()
        
        for g in sudokuGroups {
            if g.contains(cell) {
                p.formUnion(g)
            }
        }
        
        p.remove(cell)
        
        for otherCell in p {
            if constraintRemoved(otherCell) {
                p.remove(otherCell)
            }
        }
        
        return p
    }
    
    
    func constraintRemoved(_ i: Int) -> Bool {
        let section = ownSection(i)
        if sectionWon[section] == BLUE || sectionWon[section] == ORAN {
            return true
        }
        return false
    }
    
    
    func noAllowedCells() -> Bool {
        for allowed in cellAllowed {
            if allowed {
                return false
            }
        }
        
        return true
    }
    
    
    func display() {
        print("Game State:")
        print("Player: \(player)  gameWon: \(gameWon)  mostRecent: \(mostRecent) ")
        print("cellOccupied \(cellOccupied)")
        print("cellValue \(cellValue)")
        print("sectionWon \(sectionWon)")
        print("sectionAllowed \(sectionAllowed)")
        print("sectionNextValue \(sectionNextValue)")
        print("cellAllowed \(cellAllowed)")
        print("sectionWonByConstraint \(sectionWonByConstraint)")
        
        print("\n\n")
        
        for y in 0..<9 {
            for x in 0..<9 {
                let i = y*9 + x
                let section = ownSection(x, y)
                if sectionWon[section] == BLUE {
                    print("B", terminator: "")
                }
                else if sectionWon[section] == ORAN {
                    print("O", terminator: "")
                }
                else {
                    if cellOccupied[i] == 0 {
                        print(" ", terminator: "")
                    }
                    else {
                        print(cellOccupied[i], terminator: "")
                    }
                }
            }
            print()
        }
        
        print("\n\n")
        
        for y in 0..<9 {
            for x in 0..<9 {
                let i = y*9 + x
                let section = ownSection(x, y)
                if sectionWon[section] == BLUE {
                    print("B", terminator: "")
                }
                else if sectionWon[section] == ORAN {
                    print("O", terminator: "")
                }
                else {
                    if cellValue[i] == 0 {
                        print(" ", terminator: "")
                    }
                    else {
                        print(cellValue[i], terminator: "")
                    }
                }
            }
            print()
        }
        
        
    }
}
