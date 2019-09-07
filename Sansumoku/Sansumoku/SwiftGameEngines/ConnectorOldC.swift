//
//  ConnectorOldC.swift
//  Sansumoku
//
//  Created by Maksim Khrapov on 9/6/19.
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

final class ConnectorOldC: CppConnector {
    private var iterCount = 1000
    
    
    override func actualSearchFunction(_ bs_p: UnsafeMutablePointer<board_state>) -> Int {
        let res = monte_carlo_tree_search(Int32(iterCount), bs_p)
        return Int(res)
    }
    
    
    func setIterCount(_ i: Int) {
        iterCount = i
    }
}
