//
//  BoardStateInt32.swift
//  Sansumoku
//
//  Created by Maksim Khrapov on 5/4/19.
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

func bool2Int8(_ b: Bool) -> Int8 {
    if b {
        return 1
    }
    return 0
}

final class BoardStateInt8 {
    var cellOccupied: [Int8]
    var cellValue: [Int8]
    var cellAllowed: [Int8]
    var sectionWon: [Int8]
    var sectionAllowed: [Int8]
    var sectionNextValue: [Int8]
    var player: Int8
    var gameWon: Int8
    
    
    
    
    
    init(_ bs: BoardState) {
        gameWon = Int8(bs.gameWon)
        player = Int8(bs.player)
        
        cellOccupied = []
        cellValue = []
        cellAllowed = []
        
        sectionWon = []
        sectionAllowed = []
        sectionNextValue = []
        
        for i in 0..<9 {
            sectionWon.append(Int8(bs.sectionWon[i]))
            sectionAllowed.append(bool2Int8(bs.sectionAllowed[i]))
            sectionNextValue.append(Int8(bs.sectionNextValue[i]))
        }
        
        for i in 0..<81 {
            cellOccupied.append(Int8(bs.cellOccupied[i]))
            cellValue.append(Int8(bs.cellValue[i]))
            cellAllowed.append(bool2Int8(bs.cellAllowed[i]))
        }
    }
}
