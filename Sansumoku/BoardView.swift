//
//  BoardView.swift
//  Sansumoku
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

import Foundation
import UIKit


class BoardView: UIView {
    var boardState: BoardState?
    var indicator: UIActivityIndicatorView?
    var shouldDisplayIndicator = false
    
    
    func setBoardState(_ bs: BoardState) {
        boardState = bs
        self.setNeedsDisplay()
    }
    
    
    func displayIndicator(_ b: Bool) {
        shouldDisplayIndicator = b
    }
    
    
    func activityIndicator() {
        if shouldDisplayIndicator {
            if indicator == nil {
                indicator = UIActivityIndicatorView(style: .whiteLarge)
                indicator!.color = UIColor.gray;
                indicator!.hidesWhenStopped = true
            }
            indicator!.center = CGPoint(x: bounds.midX, y: bounds.midY)
            self.addSubview(indicator!)
            indicator!.startAnimating()
        }
        else {
            if indicator != nil {
                indicator!.stopAnimating()
                indicator!.removeFromSuperview()
            }
        }
    }
    
    
    override func draw(_ rect: CGRect) {
        guard let boardState = boardState else {
            return
        }
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        let draw = Draw(context, bounds, boardState)
        draw.draw()
        activityIndicator()
    }
    
    
    class Draw {
        let context: CGContext
        let rect: CGRect
        let boardState: BoardState
        let cellSize: CGFloat
        let sectionSize: CGFloat
        let myColors: MyColors
        
        
        init(_ c: CGContext, _ r: CGRect, _ bs: BoardState) {
            context = c
            rect = r
            boardState = bs
            cellSize = r.width / 9.0
            sectionSize = r.width / 3.0
            myColors = MyColors()
        }
        
        
        func draw() {
            fillBackground()
            positions()
            lightLines()
            winners()
            heavyLines()
            finalStrike()
        }
        
        
        func fillBackground() {
            context.setFillColor(myColors.background)
            context.fill(rect)
        }
        
        
        func lightLines() {
            context.setStrokeColor(myColors.lightLine)
            context.setLineWidth(1)
            
            context.beginPath()
            
            // horizontal lines
            for i in [1, 2, 4, 5, 7, 8] {
                let i = CGFloat(i)
                context.move(to: CGPoint(x: rect.minX, y: rect.minY + i*cellSize))
                context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + i*cellSize))
            }
            
            // vertical lines
            for i in [1, 2, 4, 5, 7, 8] {
                let i = CGFloat(i)
                context.move(to: CGPoint(x: rect.minX + i*cellSize, y: rect.minY))
                context.addLine(to: CGPoint(x: rect.minX + i*cellSize, y: rect.maxY))
            }
            
            context.strokePath()
        }
        
        
        func heavyLines() {
            context.setStrokeColor(myColors.heavyLine)
            context.setLineWidth(4)
            
            context.beginPath()
            
            // horizontal lines
            context.move(to: CGPoint(x: rect.minX, y: rect.minY + 2))
            context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + 2))
            
            context.move(to: CGPoint(x: rect.minX, y: rect.minY + sectionSize))
            context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + sectionSize))
            
            context.move(to: CGPoint(x: rect.minX, y: rect.minY + 2.0*sectionSize))
            context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + 2.0*sectionSize))
            
            context.move(to: CGPoint(x: rect.minX, y: rect.maxY - 2))
            context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - 2))
            
            // vertical lines
            context.move(to: CGPoint(x: rect.minX + 2, y: rect.minY))
            context.addLine(to: CGPoint(x: rect.minX + 2, y: rect.maxY))
            
            context.move(to: CGPoint(x: rect.minX + sectionSize, y: rect.minY))
            context.addLine(to: CGPoint(x: rect.minX + sectionSize, y: rect.maxY))
            
            context.move(to: CGPoint(x: rect.minX + 2.0*sectionSize, y: rect.minY))
            context.addLine(to: CGPoint(x: rect.minX + 2.0*sectionSize, y: rect.maxY))
            
            context.move(to: CGPoint(x: rect.maxX - 2, y: rect.minY))
            context.addLine(to: CGPoint(x: rect.maxX - 2, y: rect.maxY))
            
            context.strokePath()
        }
        
        
        func finalStrike() {
            if boardState.gameWon == OPEN || boardState.gameWon == DONE {
                return
            }
            
            if boardState.finalStrikeStart == -1 || boardState.finalStrikeEnd == -1 {
                return
            }
            
            var x1 = rect.minX
            var x2 = rect.minX
            var y1 = rect.minY
            var y2 = rect.minY
            
            var dy = CGFloat(boardState.finalStrikeStart / 3) + 0.5
            var dx = CGFloat(boardState.finalStrikeStart % 3) + 0.5
            
            x1 += sectionSize*dx
            y1 += sectionSize*dy
            
            dy = CGFloat(boardState.finalStrikeEnd / 3) + 0.5
            dx = CGFloat(boardState.finalStrikeEnd % 3) + 0.5
            
            x2 += sectionSize*dx
            y2 += sectionSize*dy
            
            context.setStrokeColor(myColors.finalStrikeColor)
            context.setLineWidth(24)
            context.beginPath()
            context.move(to: CGPoint(x: x1, y: y1))
            context.addLine(to: CGPoint(x: x2, y: y2))
            context.strokePath()
        }
        
        
        func winners() {
            for y in 0..<3 {
                for x in 0..<3 {
                    let i = y*3 + x
                    if boardState.sectionWon[i] == BLUE {
                        context.setFillColor(myColors.blueFgColor)
                        fillSection(x, y)
                    }
                    else if boardState.sectionWon[i] == ORAN {
                        context.setFillColor(myColors.oranFgColor)
                        fillSection(x, y)
                    }
                    
                    if boardState.sectionWonByConstraint[i] {
                        markSection(x, y)
                    }
                }
            }
        }
        
        
        func fillSection(_ x: Int, _ y: Int) {
            let x1 = rect.minX + CGFloat(x)*sectionSize
            let y1 = rect.minY + CGFloat(y)*sectionSize
            
            let sectionRect = CGRect(x: x1, y: y1, width: sectionSize, height: sectionSize)
            context.fill(sectionRect)
        }
        
        
        func markSection(_ x: Int, _ y: Int) {
            let x1 = rect.minX + CGFloat(x)*sectionSize + cellSize/2
            let y1 = rect.minY + CGFloat(y)*sectionSize + cellSize/2
            let sectionRect = CGRect(x: x1, y: y1, width: cellSize*2, height: cellSize*2)
            
            context.setFillColor(myColors.shadow)
            context.fillEllipse(in: sectionRect)
        }
        
        
        func positions() {
            for y in 0..<9 {
                for x in 0..<9 {
                    let i = y*9 + x
                    if boardState.cellOccupied[i] == BLUE {
                        if i == boardState.mostRecent {
                            paintDigit(
                                x: x,
                                y: y,
                                digit: boardState.cellValue[i],
                                fgColor: myColors.blueFgColorRecent,
                                bgColor: myColors.blueBgColorRecent
                            )
                        }
                        else {
                            paintDigit(
                                x: x,
                                y: y,
                                digit: boardState.cellValue[i],
                                fgColor: myColors.blueFgColor,
                                bgColor: myColors.blueBgColor
                            )
                        }
                    }
                    else if boardState.cellOccupied[i] == ORAN {
                        if i == boardState.mostRecent {
                            paintDigit(
                                x: x,
                                y: y,
                                digit: boardState.cellValue[i],
                                fgColor: myColors.oranFgColorRecent,
                                bgColor: myColors.oranBgColorRecent
                            )
                        }
                        else {
                            paintDigit(
                                x: x,
                                y: y,
                                digit: boardState.cellValue[i],
                                fgColor: myColors.oranFgColor,
                                bgColor: myColors.oranBgColor
                            )
                        }
                    }
                    else if boardState.cellAllowed[i] == true {
                        let section = boardState.ownSection(x, y)
                        let digit = boardState.sectionNextValue[section]
                        let color: CGColor
                        
                        if boardState.player == BLUE {
                            color = myColors.blueBgColor
                        }
                        else {
                            color = myColors.oranBgColor
                        }
                        
                        paintDigit(
                            x: x,
                            y: y,
                            digit: digit,
                            fgColor: color,
                            bgColor: myColors.background
                        )
                    }
                }
            }
        }
        
        
        func paintDigit(x: Int, y: Int, digit: Int, fgColor: CGColor, bgColor: CGColor) {
            let x1 = rect.minX + CGFloat(x)*cellSize
            let y1 = rect.minY + CGFloat(y)*cellSize
            let cellRect = CGRect(x: x1, y: y1, width: cellSize, height: cellSize)
            
            context.setFillColor(bgColor)
            context.fill(cellRect)
            
            let digitRect = CGRect(x: x1 + 0.3*cellSize, y: y1, width: 0.8*cellSize, height: 0.8*cellSize)
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 0.8*cellSize),
                .foregroundColor: UIColor(cgColor: fgColor)
            ]
            let character = NSAttributedString(string: String(digit), attributes: attributes)
            character.draw(in: digitRect)
        }
    }
}

