//
//  SansumokuTests.swift
//  SansumokuTests
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

import XCTest
@testable import Sansumoku

class SansumokuTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    //==============================================================================================================
    
    
    func testCalcBestOpeningMove() {
        let boardState = BoardState()
        let aiEngine = MonteCarloTreeSearch(boardState)
        let result = aiEngine.basic(100)
        print(result)
    }
    
    
    func testPrettyPrint() {
        let boardState = BoardState()
        let aiEngine = MonteCarloTreeSearch(boardState)
        let counts: [Double] = Array(repeating: 0.0, count: 81)
        aiEngine.prettyPrint(counts)
    }
    
    
    // 115.885 seconds
    func testBridgeToCLang() {
        let boardState = BoardState()
        let aiEngine = ConnectorOldC(boardState)
        aiEngine.setIterCount(10000)
        let result = aiEngine.search()
        print(result)
    }
    
    
    // 179.030 seconds
    func testCPPV1() {
        let boardState = BoardState()
        let aiEngine = ConnectorV1(boardState)
        aiEngine.setIterCount(10000)
        let result = aiEngine.search()
        print(result)
    }
    
    // A bug was discovered - processing of constraints should be recursive
    
    /*
    2019-06-15 14:06:16.888151-0500 Sansumoku[31060:2855018] libMobileGestalt MobileGestalt.c:890: MGIsDeviceOneOfType is not supported on this platform.
    Test Suite 'Selected tests' started at 2019-06-15 14:06:16.983
    Test Suite 'SansumokuTests.xctest' started at 2019-06-15 14:06:16.984
    Test Suite 'SansumokuTests' started at 2019-06-15 14:06:16.984
    Test Case '-[SansumokuTests.SansumokuTests testCalcBestOpeningMove]' started.
    Game State:
    Player: 1  gameWon: 0  mostRecent: 46
    cellOccupied [0, 1, 1, 2, 1, 2, 2, 1, 0, 0, 0, 1, 2, 1, 2, 1, 1, 2, 0, 2, 1, 1, 2, 1, 0, 2, 1, 2, 1, 2, 0, 2, 0, 2, 1, 1, 2, 1, 2, 0, 0, 0, 1, 2, 1, 1, 2, 1, 2, 0, 2, 2, 2, 0, 1, 0, 2, 0, 0, 0, 2, 2, 1, 1, 2, 0, 1, 1, 1, 2, 0, 1, 2, 1, 1, 0, 0, 1, 2, 2, 2]
    cellValue [0, 2, 5, 7, 4, 1, 3, 6, 0, 0, 0, 4, 2, 3, 5, 1, 7, 4, 0, 1, 3, 6, 9, 8, 0, 5, 2, 4, 8, 1, 0, 2, 0, 6, 3, 7, 5, 3, 2, 0, 0, 0, 4, 8, 1, 7, 9, 6, 1, 0, 3, 5, 2, 0, 1, 0, 5, 0, 0, 0, 2, 4, 3, 2, 7, 0, 3, 1, 4, 7, 0, 6, 3, 6, 4, 0, 0, 2, 8, 1, 5]
    sectionWon [1, 3, 0, 3, 2, 0, 2, 1, 2]
    sectionAllowed [false, false, true, false, false, true, false, false, false]
    sectionNextValue [6, 10, 8, 10, 4, 9, 8, 5, 9]
    cellAllowed [false, false, false, false, false, false, false, false, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]
    sectionWonByConstraint [false, false, false, false, true, false, false, false, false]
    
    
    
    BBB21221
    BBB212112
    BBB121 21
    212OOO211
    212OOO121
    121OOO22
    OOOBBBOOO
    OOOBBBOOO
    OOOBBBOOO
    
    
    
    BBB74136
    BBB235174
    BBB698 52
    481OOO637
    532OOO481
    796OOO52
    OOOBBBOOO
    OOOBBBOOO
    OOOBBBOOO
    Game State:
    Player: 2  gameWon: 0  mostRecent: 8
    cellOccupied [0, 1, 1, 2, 1, 2, 2, 1, 1, 0, 0, 1, 2, 1, 2, 1, 1, 2, 0, 2, 1, 1, 2, 1, 0, 2, 1, 2, 1, 2, 0, 2, 0, 2, 1, 1, 2, 1, 2, 0, 0, 0, 1, 2, 1, 1, 2, 1, 2, 0, 2, 2, 2, 0, 1, 0, 2, 0, 0, 0, 2, 2, 1, 1, 2, 0, 1, 1, 1, 2, 0, 1, 2, 1, 1, 0, 0, 1, 2, 2, 2]
    cellValue [0, 2, 5, 7, 4, 1, 3, 6, 8, 0, 0, 4, 2, 3, 5, 1, 7, 4, 0, 1, 3, 6, 9, 8, 0, 5, 2, 4, 8, 1, 0, 2, 0, 6, 3, 7, 5, 3, 2, 0, 0, 0, 4, 8, 1, 7, 9, 6, 1, 0, 3, 5, 2, 0, 1, 0, 5, 0, 0, 0, 2, 4, 3, 2, 7, 0, 3, 1, 4, 7, 0, 6, 3, 6, 4, 0, 0, 2, 8, 1, 5]
    sectionWon [1, 3, 1, 3, 2, 0, 2, 1, 2]
    sectionAllowed [false, false, false, false, false, true, false, false, false]
    sectionNextValue [6, 10, 9, 10, 4, 9, 8, 5, 9]
    cellAllowed [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]
    sectionWonByConstraint [false, false, true, false, true, false, false, false, false]
    
    
    
    BBB212BBB
    BBB212BBB
    BBB121BBB
    212OOO211
    212OOO121
    121OOO22
    OOOBBBOOO
    OOOBBBOOO
    OOOBBBOOO
    
    
    
    BBB741BBB
    BBB235BBB
    BBB698BBB
    481OOO637
    532OOO481
    796OOO52
    OOOBBBOOO
    OOOBBBOOO
    OOOBBBOOO
    Fatal error: State is not terminal, but move count is zero.: file /Users/max/Code/CodeCommit/Sansumoku/Sansumoku/Sansumoku/MonteCarloTreeSearch.swift, line 68
    2019-06-15 14:06:23.088401-0500 Sansumoku[31060:2855018] Fatal error: State is not terminal, but move count is zero.: file /Users/max/Code/CodeCommit/Sansumoku/Sansumoku/Sansumoku/MonteCarloTreeSearch.swift, line 68
    (lldb)
 
 */
    
    
    func testRecursiveConstraintProcessing() {
        let bs = BoardState()
        
        bs.player = 1
        bs.gameWon = 0
        bs.mostRecent = 46
        bs.cellOccupied = [0, 1, 1, 2, 1, 2, 2, 1, 0, 0, 0, 1, 2, 1, 2, 1, 1, 2, 0, 2, 1, 1, 2, 1, 0, 2, 1, 2, 1, 2, 0, 2, 0, 2, 1, 1, 2, 1, 2, 0, 0, 0, 1, 2, 1, 1, 2, 1, 2, 0, 2, 2, 2, 0, 1, 0, 2, 0, 0, 0, 2, 2, 1, 1, 2, 0, 1, 1, 1, 2, 0, 1, 2, 1, 1, 0, 0, 1, 2, 2, 2]
        bs.cellValue = [0, 2, 5, 7, 4, 1, 3, 6, 0, 0, 0, 4, 2, 3, 5, 1, 7, 4, 0, 1, 3, 6, 9, 8, 0, 5, 2, 4, 8, 1, 0, 2, 0, 6, 3, 7, 5, 3, 2, 0, 0, 0, 4, 8, 1, 7, 9, 6, 1, 0, 3, 5, 2, 0, 1, 0, 5, 0, 0, 0, 2, 4, 3, 2, 7, 0, 3, 1, 4, 7, 0, 6, 3, 6, 4, 0, 0, 2, 8, 1, 5]
        bs.sectionWon = [1, 3, 0, 3, 2, 0, 2, 1, 2]
        bs.sectionAllowed = [false, false, true, false, false, true, false, false, false]
        bs.sectionNextValue = [6, 10, 8, 10, 4, 9, 8, 5, 9]
        bs.cellAllowed = [false, false, false, false, false, false, false, false, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]
        bs.sectionWonByConstraint = [false, false, false, false, true, false, false, false, false]
        
        _ = bs.set(8, 0)
        
        XCTAssertTrue(bs.isTerminal())
    }

}
