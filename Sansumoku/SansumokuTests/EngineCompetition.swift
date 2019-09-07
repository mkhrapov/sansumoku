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
            
            while !bs.isTerminal() {
                if bs.player == BLUE {
                    let (x, y) = blue.search()
                    _ = bs.set(x, y)
                }
                else {
                    let (x, y) = orange.search()
                    _ = bs.set(x, y)
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
}
