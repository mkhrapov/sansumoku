//
//  CppConnector.swift
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


final class CppConnector {
    let boardState: BoardState
    
    
    init(_ boardState: BoardState) {
        self.boardState = boardState
    }
    
    
    private func setBoardStateValues(_ bs_p: UnsafeMutablePointer<board_state>) {
        let bs_int8 = BoardStateInt8(boardState)
        
        bs_p.pointee.player = bs_int8.player
        bs_p.pointee.gameWon = bs_int8.gameWon
        
        bs_p.pointee.sectionWon = (
            bs_int8.sectionWon[0],
            bs_int8.sectionWon[1],
            bs_int8.sectionWon[2],
            bs_int8.sectionWon[3],
            bs_int8.sectionWon[4],
            bs_int8.sectionWon[5],
            bs_int8.sectionWon[6],
            bs_int8.sectionWon[7],
            bs_int8.sectionWon[8]
        )
        
        bs_p.pointee.sectionAllowed = (
            bs_int8.sectionAllowed[0],
            bs_int8.sectionAllowed[1],
            bs_int8.sectionAllowed[2],
            bs_int8.sectionAllowed[3],
            bs_int8.sectionAllowed[4],
            bs_int8.sectionAllowed[5],
            bs_int8.sectionAllowed[6],
            bs_int8.sectionAllowed[7],
            bs_int8.sectionAllowed[8]
        )
        
        bs_p.pointee.sectionNextValue = (
            bs_int8.sectionNextValue[0],
            bs_int8.sectionNextValue[1],
            bs_int8.sectionNextValue[2],
            bs_int8.sectionNextValue[3],
            bs_int8.sectionNextValue[4],
            bs_int8.sectionNextValue[5],
            bs_int8.sectionNextValue[6],
            bs_int8.sectionNextValue[7],
            bs_int8.sectionNextValue[8]
        )
        
        
        bs_p.pointee.cellValue = (
            bs_int8.cellValue[0],
            bs_int8.cellValue[1],
            bs_int8.cellValue[2],
            bs_int8.cellValue[3],
            bs_int8.cellValue[4],
            bs_int8.cellValue[5],
            bs_int8.cellValue[6],
            bs_int8.cellValue[7],
            bs_int8.cellValue[8],
            bs_int8.cellValue[9],
            bs_int8.cellValue[10],
            bs_int8.cellValue[11],
            bs_int8.cellValue[12],
            bs_int8.cellValue[13],
            bs_int8.cellValue[14],
            bs_int8.cellValue[15],
            bs_int8.cellValue[16],
            bs_int8.cellValue[17],
            bs_int8.cellValue[18],
            bs_int8.cellValue[19],
            bs_int8.cellValue[20],
            bs_int8.cellValue[21],
            bs_int8.cellValue[22],
            bs_int8.cellValue[23],
            bs_int8.cellValue[24],
            bs_int8.cellValue[25],
            bs_int8.cellValue[26],
            bs_int8.cellValue[27],
            bs_int8.cellValue[28],
            bs_int8.cellValue[29],
            bs_int8.cellValue[30],
            bs_int8.cellValue[31],
            bs_int8.cellValue[32],
            bs_int8.cellValue[33],
            bs_int8.cellValue[34],
            bs_int8.cellValue[35],
            bs_int8.cellValue[36],
            bs_int8.cellValue[37],
            bs_int8.cellValue[38],
            bs_int8.cellValue[39],
            bs_int8.cellValue[40],
            bs_int8.cellValue[41],
            bs_int8.cellValue[42],
            bs_int8.cellValue[43],
            bs_int8.cellValue[44],
            bs_int8.cellValue[45],
            bs_int8.cellValue[46],
            bs_int8.cellValue[47],
            bs_int8.cellValue[48],
            bs_int8.cellValue[49],
            bs_int8.cellValue[50],
            bs_int8.cellValue[51],
            bs_int8.cellValue[52],
            bs_int8.cellValue[53],
            bs_int8.cellValue[54],
            bs_int8.cellValue[55],
            bs_int8.cellValue[56],
            bs_int8.cellValue[57],
            bs_int8.cellValue[58],
            bs_int8.cellValue[59],
            bs_int8.cellValue[60],
            bs_int8.cellValue[61],
            bs_int8.cellValue[62],
            bs_int8.cellValue[63],
            bs_int8.cellValue[64],
            bs_int8.cellValue[65],
            bs_int8.cellValue[66],
            bs_int8.cellValue[67],
            bs_int8.cellValue[68],
            bs_int8.cellValue[69],
            bs_int8.cellValue[70],
            bs_int8.cellValue[71],
            bs_int8.cellValue[72],
            bs_int8.cellValue[73],
            bs_int8.cellValue[74],
            bs_int8.cellValue[75],
            bs_int8.cellValue[76],
            bs_int8.cellValue[77],
            bs_int8.cellValue[78],
            bs_int8.cellValue[79],
            bs_int8.cellValue[80]
        )
        
        bs_p.pointee.cellAllowed = (
            bs_int8.cellAllowed[0],
            bs_int8.cellAllowed[1],
            bs_int8.cellAllowed[2],
            bs_int8.cellAllowed[3],
            bs_int8.cellAllowed[4],
            bs_int8.cellAllowed[5],
            bs_int8.cellAllowed[6],
            bs_int8.cellAllowed[7],
            bs_int8.cellAllowed[8],
            bs_int8.cellAllowed[9],
            bs_int8.cellAllowed[10],
            bs_int8.cellAllowed[11],
            bs_int8.cellAllowed[12],
            bs_int8.cellAllowed[13],
            bs_int8.cellAllowed[14],
            bs_int8.cellAllowed[15],
            bs_int8.cellAllowed[16],
            bs_int8.cellAllowed[17],
            bs_int8.cellAllowed[18],
            bs_int8.cellAllowed[19],
            bs_int8.cellAllowed[20],
            bs_int8.cellAllowed[21],
            bs_int8.cellAllowed[22],
            bs_int8.cellAllowed[23],
            bs_int8.cellAllowed[24],
            bs_int8.cellAllowed[25],
            bs_int8.cellAllowed[26],
            bs_int8.cellAllowed[27],
            bs_int8.cellAllowed[28],
            bs_int8.cellAllowed[29],
            bs_int8.cellAllowed[30],
            bs_int8.cellAllowed[31],
            bs_int8.cellAllowed[32],
            bs_int8.cellAllowed[33],
            bs_int8.cellAllowed[34],
            bs_int8.cellAllowed[35],
            bs_int8.cellAllowed[36],
            bs_int8.cellAllowed[37],
            bs_int8.cellAllowed[38],
            bs_int8.cellAllowed[39],
            bs_int8.cellAllowed[40],
            bs_int8.cellAllowed[41],
            bs_int8.cellAllowed[42],
            bs_int8.cellAllowed[43],
            bs_int8.cellAllowed[44],
            bs_int8.cellAllowed[45],
            bs_int8.cellAllowed[46],
            bs_int8.cellAllowed[47],
            bs_int8.cellAllowed[48],
            bs_int8.cellAllowed[49],
            bs_int8.cellAllowed[50],
            bs_int8.cellAllowed[51],
            bs_int8.cellAllowed[52],
            bs_int8.cellAllowed[53],
            bs_int8.cellAllowed[54],
            bs_int8.cellAllowed[55],
            bs_int8.cellAllowed[56],
            bs_int8.cellAllowed[57],
            bs_int8.cellAllowed[58],
            bs_int8.cellAllowed[59],
            bs_int8.cellAllowed[60],
            bs_int8.cellAllowed[61],
            bs_int8.cellAllowed[62],
            bs_int8.cellAllowed[63],
            bs_int8.cellAllowed[64],
            bs_int8.cellAllowed[65],
            bs_int8.cellAllowed[66],
            bs_int8.cellAllowed[67],
            bs_int8.cellAllowed[68],
            bs_int8.cellAllowed[69],
            bs_int8.cellAllowed[70],
            bs_int8.cellAllowed[71],
            bs_int8.cellAllowed[72],
            bs_int8.cellAllowed[73],
            bs_int8.cellAllowed[74],
            bs_int8.cellAllowed[75],
            bs_int8.cellAllowed[76],
            bs_int8.cellAllowed[77],
            bs_int8.cellAllowed[78],
            bs_int8.cellAllowed[79],
            bs_int8.cellAllowed[80]
        )
        
        bs_p.pointee.cellOccupied = (
            bs_int8.cellOccupied[0],
            bs_int8.cellOccupied[1],
            bs_int8.cellOccupied[2],
            bs_int8.cellOccupied[3],
            bs_int8.cellOccupied[4],
            bs_int8.cellOccupied[5],
            bs_int8.cellOccupied[6],
            bs_int8.cellOccupied[7],
            bs_int8.cellOccupied[8],
            bs_int8.cellOccupied[9],
            bs_int8.cellOccupied[10],
            bs_int8.cellOccupied[11],
            bs_int8.cellOccupied[12],
            bs_int8.cellOccupied[13],
            bs_int8.cellOccupied[14],
            bs_int8.cellOccupied[15],
            bs_int8.cellOccupied[16],
            bs_int8.cellOccupied[17],
            bs_int8.cellOccupied[18],
            bs_int8.cellOccupied[19],
            bs_int8.cellOccupied[20],
            bs_int8.cellOccupied[21],
            bs_int8.cellOccupied[22],
            bs_int8.cellOccupied[23],
            bs_int8.cellOccupied[24],
            bs_int8.cellOccupied[25],
            bs_int8.cellOccupied[26],
            bs_int8.cellOccupied[27],
            bs_int8.cellOccupied[28],
            bs_int8.cellOccupied[29],
            bs_int8.cellOccupied[30],
            bs_int8.cellOccupied[31],
            bs_int8.cellOccupied[32],
            bs_int8.cellOccupied[33],
            bs_int8.cellOccupied[34],
            bs_int8.cellOccupied[35],
            bs_int8.cellOccupied[36],
            bs_int8.cellOccupied[37],
            bs_int8.cellOccupied[38],
            bs_int8.cellOccupied[39],
            bs_int8.cellOccupied[40],
            bs_int8.cellOccupied[41],
            bs_int8.cellOccupied[42],
            bs_int8.cellOccupied[43],
            bs_int8.cellOccupied[44],
            bs_int8.cellOccupied[45],
            bs_int8.cellOccupied[46],
            bs_int8.cellOccupied[47],
            bs_int8.cellOccupied[48],
            bs_int8.cellOccupied[49],
            bs_int8.cellOccupied[50],
            bs_int8.cellOccupied[51],
            bs_int8.cellOccupied[52],
            bs_int8.cellOccupied[53],
            bs_int8.cellOccupied[54],
            bs_int8.cellOccupied[55],
            bs_int8.cellOccupied[56],
            bs_int8.cellOccupied[57],
            bs_int8.cellOccupied[58],
            bs_int8.cellOccupied[59],
            bs_int8.cellOccupied[60],
            bs_int8.cellOccupied[61],
            bs_int8.cellOccupied[62],
            bs_int8.cellOccupied[63],
            bs_int8.cellOccupied[64],
            bs_int8.cellOccupied[65],
            bs_int8.cellOccupied[66],
            bs_int8.cellOccupied[67],
            bs_int8.cellOccupied[68],
            bs_int8.cellOccupied[69],
            bs_int8.cellOccupied[70],
            bs_int8.cellOccupied[71],
            bs_int8.cellOccupied[72],
            bs_int8.cellOccupied[73],
            bs_int8.cellOccupied[74],
            bs_int8.cellOccupied[75],
            bs_int8.cellOccupied[76],
            bs_int8.cellOccupied[77],
            bs_int8.cellOccupied[78],
            bs_int8.cellOccupied[79],
            bs_int8.cellOccupied[80]
        )
    }
        
        
    func bridge_to_c(_ iterCount: Int) -> (Int, Int) {
        let bs_p = UnsafeMutablePointer<board_state>.allocate(capacity: 1)
        setBoardStateValues(bs_p)
        let res = monte_carlo_tree_search(Int32(iterCount), bs_p)
        bs_p.deallocate()
        
        let x: Int = Int(res) % 9
        let y: Int = Int(res) / 9
        return (x, y)
    }
    
    
    func bridge_to_cpp_v1(_ iterCount: Int) -> (Int, Int) {
        let bs_p = UnsafeMutablePointer<board_state>.allocate(capacity: 1)
        setBoardStateValues(bs_p)
        let res = advanced_mcts_v1(Int32(iterCount), bs_p)
        bs_p.deallocate()
        
        let x: Int = Int(res) % 9
        let y: Int = Int(res) / 9
        return (x, y)
    }
}
