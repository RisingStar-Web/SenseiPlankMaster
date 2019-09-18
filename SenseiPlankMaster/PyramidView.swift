//
//  PyramidView.swift
//  SenseiPlankMaster
//
//  Created by Роман Кабиров on 12.09.2018.
//  Copyright © 2018 Logical Mind. All rights reserved.
//

import UIKit

class PyramidView: UIView {
    private var ninjaImage: UIImageView?
    private var cupImage: UIImageView?
    private var timeLabels: [UILabel] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        // setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // setupView()
    }
    
    public func setupView() {
        let brickColor = UIColor.init(red: 54/255, green: 187/255, blue: 206/255, alpha: 1.0)
        let brickWidth = UIScreen.main.bounds.width / 10
        let brickHeight = self.bounds.height / 10
        let frameHeight = self.bounds.height
        
        backgroundColor = .white
        
        for level in 0...10 {
            for i in level-1...9 {
                let x = CGFloat(i) * brickWidth
                let y: CGFloat = frameHeight - (brickHeight * CGFloat(level))
                
                let brickFrame = CGRect(x: x, y: y, width: brickWidth, height: brickHeight)
                let brick = UIView(frame: brickFrame)
                brick.backgroundColor = brickColor
                
                addSubview(brick)
            }
        }
    }
    
    public func paintNinja(day: Int) {
        let brickWidth = UIScreen.main.bounds.width / 10
        let brickHeight = self.bounds.height / 10
        let ninjaSize: CGFloat = brickWidth - 2
        
        ninjaImage?.removeFromSuperview()
        
        var level = Int(day / 3)
        if level > 9 {
            level = 9
        }

        let x: CGFloat = brickWidth * CGFloat(level)
        var y: CGFloat = (brickHeight * 10) - ninjaSize
        y = y - (brickHeight * (CGFloat(level) + 1)) - 1

        let ninjaRect = CGRect(x: x, y: y, width: ninjaSize, height: ninjaSize)
        ninjaImage = UIImageView(frame: ninjaRect)
        ninjaImage?.image = UIImage(named: "ninja-icon")
        addSubview(ninjaImage!)
        
        // paint times: 30 sec, 40 sec... etc
        for l in timeLabels {
            l.removeFromSuperview()
        }
        timeLabels.removeAll()
        
        for currentLevel in 2...9 {
            let index = (currentLevel * 3)

            for i in 0...2 {
                let dayIndex = index + i
                let timeStr = WorkoutData.days[dayIndex]
                let yDelta = brickHeight * CGFloat(i) - 28
                let timeFrame = CGRect(x: CGFloat(currentLevel) * brickWidth, y: (brickHeight * 10) - (CGFloat(currentLevel) * brickHeight) + yDelta, width: brickWidth, height: 22)
                let timeLabel = UILabel(frame: timeFrame)
                timeLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
                timeLabel.textAlignment = .center
                timeLabel.textColor = .white
                timeLabel.text = String(timeStr)
                
                if dayIndex < day {
                    timeLabel.alpha = 0.3
                }
                if dayIndex == day {
                    timeLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
                }
                
                addSubview(timeLabel)
                timeLabels.append(timeLabel)
            }
        }
        
        // add cup
        cupImage?.removeFromSuperview()
        if level < 9 {
            let cupWidth = ninjaSize
            let cupHeight = ninjaSize
            let cupRect = CGRect(x: (brickWidth * 10) - cupWidth - 1, y: -brickHeight - 5, width: cupWidth, height: cupHeight)
            cupImage = UIImageView(frame: cupRect)
            cupImage?.image = UIImage(named: "cup-icon")
            addSubview(cupImage!)
        }
    }
    
}
