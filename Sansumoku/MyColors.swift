//
//  MyColors.swift
//  Sansumoku
//
//  Created by Maksim Khrapov on 10/27/19.
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
import UIKit


final class MyColors {
    
    var background: CGColor {
        if #available(iOS 13.0, *) {
            return UIColor.systemBackground.cgColor
        }
        else {
            return UIColor.white.cgColor
        }
    }
    
    
    var lightLine: CGColor {
        if #available(iOS 13.0, *) {
            return UIColor.gray.cgColor
        }
        else {
            return UIColor.gray.cgColor
        }
    }
    
    
    var heavyLine: CGColor {
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark {
                return makeColor(200, 200, 200)
            }
            else {
                return UIColor.black.cgColor
            }
        }
        else {
            return UIColor.black.cgColor
        }
    }
    
    lazy var black = makeColor(0, 0, 0)
    lazy var blueFgColor = makeColor(28, 134, 238) // dodgerblue2
    lazy var blueBgColor = makeColor(212, 229, 247) // lighter version of FG color
    lazy var blueFgColorRecent = black
    lazy var blueBgColorRecent = blueFgColor
    lazy var oranFgColor = makeColor(255, 127, 0) // darkorange1
    lazy var oranBgColor = makeColor(255, 217, 179) // lighter version of FG color
    lazy var oranFgColorRecent = black
    lazy var oranBgColorRecent = oranFgColor
    lazy var finalStrikeColor = makeColor(255, 0, 0) // just make it red for now
    lazy var shadow = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.1).cgColor
    
    
    init() {
        
    }
    
    
    func makeColor(_ red: Int, _ green: Int, _ blue: Int) -> CGColor {
        let scale:CGFloat = 255.0
        
        return UIColor(
            red: CGFloat(red)/scale,
            green: CGFloat(green)/scale,
            blue: CGFloat(blue)/scale,
            alpha: 1.0
            ).cgColor
    }
}
