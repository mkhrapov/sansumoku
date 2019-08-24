//
//  BoardStateInt32.swift
//  Sansumoku
//
//  Created by Maksim Khrapov on 5/4/19.
//  Copyright © 2019 Maksim Khrapov. All rights reserved.
//

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
