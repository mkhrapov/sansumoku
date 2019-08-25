//
//  SettingsViewController.swift
//  Sansumoku
//
//  Created by Maksim Khrapov on 3/7/19.
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

class SettingsViewController: UIViewController {
    
    let explText = [
        "Humans play both sides.",
        "AI plays Blue.",
        "AI plays Orange."
    ]
    
    let gameStyleKey = "gameStyleKey"
    let aiLevelKey = "aiLevelKey"
    
    @IBOutlet weak var gameStyle: UISegmentedControl!
    @IBOutlet weak var gameStyleLabel: UILabel!
    @IBOutlet weak var aiLevel: UISegmentedControl!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Settings"
        
        let style = UserDefaults.standard.integer(forKey: gameStyleKey)
        gameStyleLabel.text = explText[style]
        gameStyle.selectedSegmentIndex = style
        
        
        let level = UserDefaults.standard.integer(forKey: aiLevelKey)
        aiLevel.selectedSegmentIndex = level
        
    
    }
    
    
    @IBAction func gameStyleControlPressed(_ sender: Any) {
        let style = gameStyle.selectedSegmentIndex
        gameStyleLabel.text = explText[style]
        UserDefaults.standard.set(style, forKey: gameStyleKey)
    }
    
    
    @IBAction func aiLevelControlPressed(_ sender: Any) {
        let level = aiLevel.selectedSegmentIndex
        UserDefaults.standard.set(level, forKey: aiLevelKey)
    }
    
    
    
}
