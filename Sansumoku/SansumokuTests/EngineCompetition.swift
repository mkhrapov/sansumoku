//
//  EngineCompetition.swift
//  SansumokuTests
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


import XCTest
@testable import Sansumoku

class EngineCompetition: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func playoff(_ count: Int, blue: AIEngine, orange: AIEngine) -> (Int, Int, Int) {
        var blueWon = 0
        var orangeWon = 0
        var isDraw = 0
        
        for i in 0..<count {
            print("Stared run \(i+1)")
            let bs = BoardState()
            blue.setBoardState(bs)
            orange.setBoardState(bs)
            
            var counter = 0
            while !bs.isTerminal() {
                if bs.player == BLUE {
                    let (x, y) = blue.search()
                    print("Blue x = \(x), y = \(y)")
                    _ = bs.set(x, y)
                }
                else {
                    let (x, y) = orange.search()
                    print("Orange x = \(x), y = \(y)")
                    _ = bs.set(x, y)
                }
                counter += 1
                if counter > 100 {
                    fatalError("Something went wrong")
                }
            }
            
            if bs.gameWon == BLUE {
                blueWon += 1
                print("Blue Won")
            }
            else if bs.gameWon == ORAN {
                orangeWon += 1
                print("Orange Won")
            }
            else if bs.gameWon == DONE {
                isDraw += 1
                print("It's a draw!")
            }
            else {
                fatalError("Game is not finished")
            }
        }
        
        return (blueWon, orangeWon, isDraw)
    }

    
    func testBasicVsOldC() {
        let bs = BoardState()
        let blue = SwiftBasicPlayer(bs)
        let orange = ConnectorOldC(bs)
        
        let count = 10
        let (b, o, d) = playoff(count, blue: blue, orange: orange)
        
        print("Blue won \(b) times, Orange won \(o) times, Draw \(d) times out of \(count) plays.")
    }
    
    
    func testCvsCPPV1() {
        let bs = BoardState()
        let c_player = ConnectorOldC(bs)
        let cppv1_player = ConnectorV1(bs)
        
        let count = 50
        
        let (b1, o1, d1) = playoff(count, blue: c_player, orange: cppv1_player)
        let (b2, o2, d2) = playoff(count, blue: cppv1_player, orange: c_player)
        
        print("Blue won \(b1 + b2) times, Orange won \(o1 + o2) times, Draw \(d1 + d2) times out of \(count*2) plays.")
    }
}
