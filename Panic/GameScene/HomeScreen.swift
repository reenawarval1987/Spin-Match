//
//  HomeScreen.swift
//  Panic
//
//  Created by Karamjit Singh on 08/03/26.
//


import SpriteKit
import UIKit

class HomeScreen: SKScene {

    var circleNode1: SKSpriteNode!
    var circleNode2: SKSpriteNode!
    var circleNode3: SKSpriteNode!
    var circleNode4: SKSpriteNode!

    var playButton: SKLabelNode!

    var counter = 1
    var timer: TimeInterval = 0
    var stopColorChanges = false

    override func didMove(to view: SKView) {

        backgroundColor = .white

        setFramesForSprite()

        counter = 1
        timer = 0
        stopColorChanges = false

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.stopColorChangeMethod()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.chooseOptionInitialise()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.circleChangeStart()
        }

        companyNameAndCreation()
    }

    // MARK: - PANIC TEXT ANIMATION

    func chooseOptionInitialise() {

        let letters = ["P","A","N","I","C"]
        let colors: [UIColor] = [.red,.green,.blue,.yellow,.red]

        for i in 0..<letters.count {

            let label = SKLabelNode(fontNamed: "Helvetica-Bold")
            label.text = letters[i]
            label.fontSize = 36
            label.fontColor = colors[i]
            label.position = CGPoint(x: -50 + (i * 50), y: 450)

            addChild(label)

          let action = SKAction.moveTo(x: CGFloat(100 + (i * 25)), duration: 0.5 + Double(i) * 0.1)
            label.run(action)
        }
    }

    // MARK: - COMPANY TEXT

    func companyNameAndCreation() {

        let created = SKLabelNode(fontNamed: "Helvetica")
        created.text = "created by"
        created.fontSize = 12
        created.fontColor = .lightGray
        created.position = CGPoint(x: size.width/2, y: 115)
        addChild(created)

        let company = SKLabelNode(fontNamed: "Gill Sans")
        company.text = "A p p l i f y"
        company.fontSize = 22
        company.fontColor = .gray
        company.position = CGPoint(x: size.width/2, y: 93)
        addChild(company)

        let music = SKLabelNode(fontNamed: "Helvetica")
        music.text = "with music by"
        music.fontSize = 12
        music.fontColor = .lightGray
        music.position = CGPoint(x: size.width/2, y: 70)
        addChild(music)

        let musicName = SKLabelNode(fontNamed: "Gill Sans")
        musicName.text = "AYK"
        musicName.fontSize = 20
        musicName.fontColor = .gray
        musicName.position = CGPoint(x: size.width/2, y: 50)
        addChild(musicName)

        let headphone = SKLabelNode(fontNamed: "Helvetica")
        headphone.text = "Headphones are recommended"
        headphone.fontSize = 10
        headphone.fontColor = .lightGray
        headphone.position = CGPoint(x: size.width/2, y: 15)
        headphone.alpha = 0
        addChild(headphone)

        headphone.run(.fadeIn(withDuration: 1.7))
    }

    // MARK: - CIRCLES

    func setFramesForSprite() {

        circleNode1 = SKSpriteNode(imageNamed: "circle")
        circleNode1.position = CGPoint(x: size.width/2, y: 270)
        circleNode1.size = CGSize(width: 200, height: 200)
        circleNode1.color = .red
        circleNode1.colorBlendFactor = 1

        circleNode2 = SKSpriteNode(imageNamed: "circle")
        circleNode2.position = circleNode1.position
        circleNode2.size = CGSize(width: 140, height: 140)
        circleNode2.color = .green
        circleNode2.colorBlendFactor = 1

        circleNode3 = SKSpriteNode(imageNamed: "circle")
        circleNode3.position = circleNode1.position
        circleNode3.size = CGSize(width: 90, height: 90)
        circleNode3.color = .blue
        circleNode3.colorBlendFactor = 1

        circleNode4 = SKSpriteNode(imageNamed: "circle")
        circleNode4.position = circleNode1.position
        circleNode4.size = CGSize(width: 40, height: 40)
        circleNode4.color = .yellow
        circleNode4.colorBlendFactor = 1

        addChild(circleNode1)
        addChild(circleNode2)
        addChild(circleNode3)
        addChild(circleNode4)

        circleNode1.name = "circle1"
        circleNode2.name = "circle2"
        circleNode3.name = "circle3"
        circleNode4.name = "circle4"
    }

    func circleChangeStart() {
        stopColorChanges = false
    }

    // MARK: - PLAY BUTTON

    func playButtonInitialisation() {

        playButton = SKLabelNode(fontNamed: "Helvetica")
        playButton.text = "PLAY"
        playButton.fontSize = 20
        playButton.fontColor = .red
        playButton.position = CGPoint(x: size.width/2, y: 300)
        playButton.name = "playBtn"
        playButton.isHidden = true

        addChild(playButton)
    }

    // MARK: - TOUCHES

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let node = atPoint(location)

        if node.name == "circle1" ||
           node.name == "circle2" ||
           node.name == "circle3" ||
           node.name == "circle4" {

            stopColorChanges = false
        }

        else if node.name == "playBtn" {
            moveToNextScene()
        }

        else if node.name == "startGame" {
            run(.sequence([
                .wait(forDuration: 0.2),
                .run { self.moveToNextScene() }
            ]))
        }
    }

    // MARK: - SCENE TRANSITION

    func moveToNextScene() {

        guard let view = self.view else { return }

        let scene = MyScene(size: view.bounds.size)
        scene.scaleMode = .aspectFill

        view.presentScene(scene)
    }

    // MARK: - STOP ANIMATION

    func stopColorChangeMethod() {

        circleNode1.removeFromParent()
        circleNode2.removeFromParent()
        circleNode3.removeFromParent()
        circleNode4.removeFromParent()

        stopColorChanges = true

        playButtonInitialisation()
        startGameInitialiseButton()
    }

    // MARK: - START GAME BUTTON

    func startGameInitialiseButton() {

        let startBtn = SKSpriteNode(imageNamed: "StartGame_1")

        startBtn.size = CGSize(width: 130, height: 130)
        startBtn.position = CGPoint(x: size.width/2, y: 300)
        startBtn.alpha = 0
        startBtn.name = "startGame"

        addChild(startBtn)

        startBtn.run(.fadeIn(withDuration: 1))
    }

    // MARK: - UPDATE LOOP

    override func update(_ currentTime: TimeInterval) {

        if currentTime > timer && !stopColorChanges {

            colorChangesCircle()
            timer = currentTime + 0.7
        }
    }

    // MARK: - CIRCLE ANIMATION

    func colorChangesCircle() {

        let scaleUp = SKAction.scale(by: 1.3, duration: 0.3)
        let scaleDown = SKAction.scale(by: 0.77, duration: 0.5)
        let seq = SKAction.sequence([scaleUp, scaleDown])

        switch counter {

        case 1:
            circleNode4.run(seq)
            counter = 2

        case 2:
            circleNode3.run(seq)
            counter = 3

        case 3:
            circleNode2.run(seq)
            counter = 4

        case 4:
            circleNode1.run(seq)
            counter = 1

        default:
            break
        }
    }
}
