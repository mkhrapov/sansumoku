//
//  SettingsViewController.swift
//  Sansumoku
//
//  Created by Maksim Khrapov on 3/7/19.
//  Copyright © 2019 Maksim Khrapov. All rights reserved.
//

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
