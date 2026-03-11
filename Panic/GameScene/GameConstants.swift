//
//  GameConstants.swift
//  Panic
//
//  Created by Karamjit Singh on 09/03/26.
//


import SpriteKit
import UIKit

struct GameConstants {

    // MARK: - Circle Colors
    static let redColor = SKColor(red: 255/255, green: 20/255, blue: 66/255, alpha: 1)
    static let yellowColor = SKColor(red: 248/255, green: 231/255, blue: 28/255, alpha: 1)
    static let greenColor = SKColor(red: 68/255, green: 195/255, blue: 116/255, alpha: 1)
    static let blueColor = SKColor(red: 17/255, green: 178/255, blue: 251/255, alpha: 1)

    // MARK: - Home Colors
    static let homeColor1 = SKColor(red: 146/255, green: 146/255, blue: 146/255, alpha: 1)
    static let homeColor2 = SKColor(red: 158/255, green: 158/255, blue: 158/255, alpha: 1)
    static let homeColor3 = SKColor(red: 132/255, green: 132/255, blue: 132/255, alpha: 1)
    static let homeColor4 = SKColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)

    // MARK: - Score UI
    static let scoreLabelColor = SKColor(red: 105/255, green: 105/255, blue: 105/255, alpha: 1)
    static let scoreLabelFont = UIFont(name: "Menlo", size: 14)
    static let scoreText = "SCORE"

    static let scoreNumberColorWhite = SKColor.white

    static let highScoreLabelColor = SKColor(red: 207/255, green: 207/255, blue: 207/255, alpha: 1)
    static let highScoreLabelFont = UIFont(name: "Menlo", size: 14)
    static let highScoreText = "HIGH SCORE"

    static let nextLifeText = "LIFE LINE"

    // MARK: - Circle Node Sizes
    static let circleNodePosition = CGPoint(x: 160, y: 120)

    static let circleSize1 = CGSize(width: 200, height: 200)
    static let circleSize2 = CGSize(width: 140, height: 140)
    static let circleSize3 = CGSize(width: 80, height: 80)
    static let circleSize4 = CGSize(width: 35, height: 35)

    // MARK: - iPad Sizes
    static let ipadCirclePosition = CGPoint(x: 380, y: 250)

    static let ipadCircleSize1 = CGSize(width: 350, height: 350)
    static let ipadCircleSize2 = CGSize(width: 250, height: 250)
    static let ipadCircleSize3 = CGSize(width: 150, height: 150)
    static let ipadCircleSize4 = CGSize(width: 70, height: 70)

    // MARK: - UserDefaults Keys
    static let lifeLineKey = "lifeLine"
    static let highestScoreKey = "HighestScore"
    static let databaseInitialiseKey = "InitialiseDatabase"
}