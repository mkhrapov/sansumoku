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
        
        print("First round.")
        print("Blue won \(b1) times, Orange won \(o1) times, Draw \(d1) times out of \(count) plays.")
        print("Second round.")
        print("Blue won \(b2) times, Orange won \(o2) times, Draw \(d2) times out of \(count) plays.")
        print("Total.")
        print("Blue won \(b1 + b2) times, Orange won \(o1 + o2) times, Draw \(d1 + d2) times out of \(count*2) plays.")
    }
    
    
    /*
     Totally random
     Apple won 95 times, Random won 5 times, Draw 0 times out of 100 plays.
     Basic player
     Apple won 83 times, Random won 11 times, Draw 6 times out of 100 plays.
     */
    func testApplePlayerRandom() {
        let bs = BoardState()
        
        let random_player = SwiftBasicPlayer(bs)
        let gk_player = SwiftGKMCPlayer(bs)
        
        let count = 50
        let (b1, o1, d1) = playoff(count, blue: gk_player, orange: random_player)
        let (b2, o2, d2) = playoff(count, blue: random_player, orange:  gk_player)
        
        print("First round.")
        print("Apple (blue) won \(b1) times, Random (orange) won \(o1) times, Draw \(d1) times out of \(count) plays.")
        print("Second round.")
        print("Random (blue) won \(b2) times, Apple (orange) won \(o2) times, Draw \(d2) times out of \(count) plays.")
        print("Total.")
        print("Apple won \(b1 + o2) times, Random won \(o1 + b2) times, Draw \(d1 + d2) times out of \(count*2) plays.")
    }
    
    
    /*
     First round.
     Apple (blue) won 1 times, My algo (orange) won 49 times, Draw 0 times out of 50 plays.
     Second round.
     My algo (blue) won 45 times, Apple (orange) won 5 times, Draw 0 times out of 50 plays.
     Total.
     Apple won 6 times, My algo won 94 times, Draw 0 times out of 100 plays.
     */
    func testApplePlayer() {
        let bs = BoardState()
        
        let cppv1_player = ConnectorV1(bs)
        let gk_player = SwiftGKMCPlayer(bs)
        
        let count = 50
        let (b1, o1, d1) = playoff(count, blue: gk_player, orange: cppv1_player)
        let (b2, o2, d2) = playoff(count, blue: cppv1_player, orange:  gk_player)
        
        print("First round.")
        print("Apple (blue) won \(b1) times, My algo (orange) won \(o1) times, Draw \(d1) times out of \(count) plays.")
        print("Second round.")
        print("My algo (blue) won \(b2) times, Apple (orange) won \(o2) times, Draw \(d2) times out of \(count) plays.")
        print("Total.")
        print("Apple won \(b1 + o2) times, My algo won \(o1 + b2) times, Draw \(d1 + d2) times out of \(count*2) plays.")
    }
    
    
    /*
    First round.
    V100 (blue) won 18 times, V1000 (orange) won 30 times, Draw 2 times out of 50 plays.
    Second round.
    V1000 (blue) won 35 times, V100 (orange) won 13 times, Draw 2 times out of 50 plays.
    Total.
    V100 won 31 times, V1000 won 65 times, Draw 4 times out of 100 plays.
    */
    func testHundredvsThousand() {
        let bs = BoardState()
        
        let v100 = ConnectorV1(bs)
        v100.setIterCount(100)
        let v1000 = ConnectorV1(bs)
        v1000.setIterCount(1000)
        
        let count = 50
        let (b1, o1, d1) = playoff(count, blue: v100, orange: v1000)
        let (b2, o2, d2) = playoff(count, blue: v1000, orange:  v100)
        
        print("First round.")
        print("V100 (blue) won \(b1) times, V1000 (orange) won \(o1) times, Draw \(d1) times out of \(count) plays.")
        print("Second round.")
        print("V1000 (blue) won \(b2) times, V100 (orange) won \(o2) times, Draw \(d2) times out of \(count) plays.")
        print("Total.")
        print("V100 won \(b1 + o2) times, V1000 won \(o1 + b2) times, Draw \(d1 + d2) times out of \(count*2) plays.")
    }
    
    
    /*
     First round.
     V2000 (blue) won 29 times, V1000 (orange) won 20 times, Draw 1 times out of 50 plays.
     Second round.
     V1000 (blue) won 23 times, V2000 (orange) won 26 times, Draw 1 times out of 50 plays.
     Total.
     V2000 won 55 times, V1000 won 43 times, Draw 2 times out of 100 plays.
     */
    func test1Kvs2K() {
        let bs = BoardState()
        
        let v2000 = ConnectorV1(bs)
        v2000.setIterCount(2000)
        let v1000 = ConnectorV1(bs)
        v1000.setIterCount(1000)
        
        let count = 50
        let (b1, o1, d1) = playoff(count, blue: v2000, orange: v1000)
        let (b2, o2, d2) = playoff(count, blue: v1000, orange:  v2000)
        
        print("First round.")
        print("V2000 (blue) won \(b1) times, V1000 (orange) won \(o1) times, Draw \(d1) times out of \(count) plays.")
        print("Second round.")
        print("V1000 (blue) won \(b2) times, V2000 (orange) won \(o2) times, Draw \(d2) times out of \(count) plays.")
        print("Total.")
        print("V2000 won \(b1 + o2) times, V1000 won \(o1 + b2) times, Draw \(d1 + d2) times out of \(count*2) plays.")
    }
}
