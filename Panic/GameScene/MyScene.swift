//
//  MyScene.swift
//  Panic
//
//  Created by Karamjit Singh on 08/03/26.
//


import SpriteKit
import AVFoundation

class MyScene: SKScene,SKPhysicsContactDelegate {
    var stopGame: Bool = false
    var scoreNumber: Int = 0
    var ballSpeed: Float = 0.0
    var ballIntervalUpdator: Float = 0.0
    var highScore: Int = 0
    var moveBallDown: Int = 0
    var randomColor = 1
    var counter = 1
    var timer:TimeInterval = 0
    var matchcolor = 4
    var isballPause: Bool = false
    var isHiddenPlayAgianBtn: Bool = false
    var powerBallActive: Bool = false
    var powerBallCompletion: Bool = false
    var nextLifeCount: Int = 0
    var backgroundColorWhite: Bool = false
    var countPowerBall: Int = 0
    var powerBallCountStop: Int = 0
    var startPowerBall: Bool = false
    var isPlayAgainActive: Bool = false
    var useLifeLineActive: Bool = false
    var colorCircleChangeTimer: TimeInterval = 0
    var highScoreNumber: SKLabelNode?
    var scoreNumberLabel: SKLabelNode?
    var nextLifeNumberlabel: SKLabelNode?
    var highScoreLbl: SKLabelNode?
    var scoreLbl: SKLabelNode?
    var nextLifeLine: SKLabelNode?
    var useLifeLine: SKSpriteNode?
    var videoShapeNode: SKShapeNode?
    var videoPlayer: AVPlayer?
    var videoNode: SKVideoNode?
    var backGround: SKSpriteNode?
    // Power ball sprites
    var ballNode1 = SKSpriteNode(imageNamed:"blue-1.png")
    var ballNode2 = SKSpriteNode(imageNamed:"blue-1.png")
    var ballNode3 = SKSpriteNode(imageNamed:"blue-1.png")
    var ballNode4 = SKSpriteNode(imageNamed:"blue-1.png")
    var ballNode5 = SKSpriteNode(imageNamed:"blue-1.png")
    var powerRushNode: SKLabelNode?
    var touchEnabled:Bool = true

  var circleNode1 = SKSpriteNode(texture:SKTexture(imageNamed: "red-ball"))  // SKSpriteNode(imageNamed:"circle.png")
  var circleNode2  = SKSpriteNode(texture:SKTexture(imageNamed: "green-ball")) // SKSpriteNode(imageNamed:"circle.png")
  var circleNode3  =  SKSpriteNode(texture:SKTexture(imageNamed: "blue-ball")) //SKSpriteNode(imageNamed:"circle.png")
  var circleNode4  = SKSpriteNode(texture:SKTexture(imageNamed: "yellow-ball"))// SKTexture(imageNamed: "yellow-ball")// SKSpriteNode(imageNamed:"circle.png")
  var circle1  =  SKSpriteNode(texture:SKTexture(imageNamed: "red-ball"))
  var againPlayNode = SKSpriteNode(imageNamed: "try_again.png")
  var glowRing: SKShapeNode?
  var lastPowerScore = 0
 // SKSpriteNode *againPlayNode;
  var centerX: CGFloat { return size.width / 2 }
  var centerY: CGFloat { return size.height / 2 }
  var gradientBackground: SKSpriteNode?



  var comboCount = 0
  var feverModeActive = false
  var feverEndTime: TimeInterval = 0
  var feverLabel: SKLabelNode?
  var lastScoreTime: TimeInterval = 0

  let ballTextures = [
      SKTexture(imageNamed: "red-ball"),
      SKTexture(imageNamed: "green-ball"),
      SKTexture(imageNamed: "blue-ball"),
      SKTexture(imageNamed: "yellow-ball")
  ]

  let circleTextures = [
      SKTexture(imageNamed: "red-circle"),
      SKTexture(imageNamed: "green-circle"),
      SKTexture(imageNamed: "blue-circle"),
      SKTexture(imageNamed: "yellow-circle")
  ]




  override func didMove(to view: SKView) {

      // Setup your scene here

    let cameraNode = SKCameraNode()
    cameraNode.position = CGPoint(x: centerX, y: centerY)
    self.camera = cameraNode
    addChild(cameraNode)

      initialiseAllMethods()

      useLifeLineActive = false
      counter = 1
      timer = 0
      matchcolor = 4
      stopGame = false
      ballSpeed = 8
      isHiddenPlayAgianBtn = true
      powerBallActive = true
      powerBallCompletion = false
      isUserInteractionEnabled = true
      countPowerBall = 1
      powerBallCountStop = 1
      startPowerBall = false
      isPlayAgainActive = false
      moveBallDown = 220
      physicsWorld.contactDelegate = self

      NotificationCenter.default.addObserver(
          self,
          selector: #selector(pauseGame),
          name: UIApplication.willResignActiveNotification,
          object: nil
      )

      NotificationCenter.default.addObserver(
          self,
          selector: #selector(startAgain),
          name: UIApplication.didBecomeActiveNotification,
          object: nil
      )
  }

  func initialiseBackgroundMusic() {

      run(SKAction.playSoundFileNamed("backgroundMusic.wav", waitForCompletion: false))
  }
  func initialiseAllMethods() {

      initialiseBackgroundMusic()
      emitterEffect()
      themeSelection()
      setupGradientBackground()
    //  initialiseBackground()
      initialiseDBAccess()
   //   createGlowRing()
      setFramesForSprite()
      playAgainGameInitialise()
      initialisePowerBallDesign()
      scoreLabel()
      scoreNumberInitialise()

  }
  func initialiseBackground() {

      if backgroundColorWhite {
          backGround = SKSpriteNode(imageNamed: "background.png")
      } else {
          backGround = SKSpriteNode(imageNamed: "backgroundThemeBlack.png")
      }

      guard let backGround = backGround else { return }

      backGround.position = CGPoint(x: centerX, y: centerY)
      backGround.size = CGSize(width: size.width, height: size.height)
      backGround.zPosition = -10
      addChild(backGround)
  }
  func setFramesForSprite() {


      // Define positions and sizes for circle nodes

      let circleNodePosition = CGPoint(x: centerX, y: size.height * 0.25)
      let circleNodeSize1 = CGSize(width: 260, height: 260)
      let circleNodeSize2 = CGSize(width: 180, height: 180)
      let circleNodeSize3 = CGSize(width: 100, height: 100)
      let circleNodeSize4 = CGSize(width: 50, height: 50)

//      circle1 = SKSpriteNode(texture: ballTextures[0])
//      circle1.position  =  CGPoint(x: centerX, y: size.height - 80)
//      circle1.size = CGSize(width: 40, height: 40)
//      addChild(circle1)
//


      circleNode1 = SKSpriteNode(texture: circleTextures[0]) //SKSpriteNode(imageNamed:"red-ball")
      circleNode1.position = circleNodePosition
      circleNode1.size = circleNodeSize1
    circleNode1.physicsBody = SKPhysicsBody(circleOfRadius: 100)
    circleNode1.physicsBody?.isDynamic = false
    circleNode1.physicsBody?.categoryBitMask = PhysicsCategory.circle
    circleNode1.physicsBody?.contactTestBitMask = PhysicsCategory.ball
    circleNode1.physicsBody?.collisionBitMask = PhysicsCategory.none

      circleNode2 = SKSpriteNode(texture: circleTextures[1]) //SKSpriteNode(imageNamed:"green-ball")
      circleNode2.position = circleNodePosition
      circleNode2.size = circleNodeSize2
      circleNode2.physicsBody = SKPhysicsBody(circleOfRadius: 100)
      circleNode2.physicsBody?.isDynamic = false
      circleNode2.physicsBody?.categoryBitMask = PhysicsCategory.circle
      circleNode2.physicsBody?.contactTestBitMask = PhysicsCategory.ball
      circleNode2.physicsBody?.collisionBitMask = PhysicsCategory.none

      circleNode3 = SKSpriteNode(texture: circleTextures[2]) //SKSpriteNode(imageNamed:"blue-ball.png")
      circleNode3.position = circleNodePosition
      circleNode3.size = circleNodeSize3
      circleNode3.physicsBody = SKPhysicsBody(circleOfRadius: 100)
      circleNode3.physicsBody?.isDynamic = false
      circleNode3.physicsBody?.categoryBitMask = PhysicsCategory.circle
      circleNode3.physicsBody?.contactTestBitMask = PhysicsCategory.ball
      circleNode3.physicsBody?.collisionBitMask = PhysicsCategory.none

      circleNode4 = SKSpriteNode(texture: circleTextures[3]) //SKSpriteNode(imageNamed:"yellow-ball.png")
      circleNode4.position = circleNodePosition
      circleNode4.size = circleNodeSize4
      circleNode4.physicsBody = SKPhysicsBody(circleOfRadius: 100)
      circleNode4.physicsBody?.isDynamic = false
      circleNode4.physicsBody?.categoryBitMask = PhysicsCategory.circle
      circleNode4.physicsBody?.contactTestBitMask = PhysicsCategory.ball
      circleNode4.physicsBody?.collisionBitMask = PhysicsCategory.none



   //   circle1.run(SKAction.colorize(with: .red, colorBlendFactor: 1, duration: 0))

  //    circleNode1.run(SKAction.colorize(with: GameConstants.redColor, colorBlendFactor: 1, duration: 0))
  //    circleNode2.run(SKAction.colorize(with: GameConstants.greenColor, colorBlendFactor: 1, duration: 0))
  //    circleNode3.run(SKAction.colorize(with: GameConstants.blueColor, colorBlendFactor: 1, duration: 0))
   //   circleNode4.run(SKAction.colorize(with: GameConstants.yellowColor, colorBlendFactor: 1, duration: 0))

      circleNode1.zPosition = 100
      circleNode2.zPosition = 150
      circleNode3.zPosition = 200
      circleNode4.zPosition = 250

      addChild(circleNode1)
      addChild(circleNode2)
      addChild(circleNode3)
      addChild(circleNode4)
  }

  func spawnBall() {
      randomColor = Int.random(in: 1...4)
      let ball = SKSpriteNode(texture: ballTextures[randomColor - 1])
      ball.position = CGPoint(x: centerX, y: size.height - 80)
      ball.size = CGSize(width: 40, height: 40)

      ball.physicsBody = SKPhysicsBody(circleOfRadius: 15)
      ball.physicsBody?.isDynamic = true
      ball.physicsBody?.categoryBitMask = PhysicsCategory.ball
      ball.physicsBody?.contactTestBitMask = PhysicsCategory.circle
      ball.physicsBody?.collisionBitMask = PhysicsCategory.none

      addChild(ball)

      let move = SKAction.moveTo(y: size.height * 0.25, duration: TimeInterval(ballSpeed))

      ball.run(move)
  }
/*
  func addingPhysicsToSprite() {

      ballSelectionWithColor()

    circle1.removeAllActions()

    let moveAction = SKAction.moveTo(
        y: size.height * 0.25,
        duration: TimeInterval(ballSpeed)
    )

    moveAction.timingMode = .easeInEaseOut



      circle1.run(moveAction) { [weak self] in
          guard let self = self else { return }

          if self.circle1.physicsBody?.contactTestBitMask ==
             self.circleNode1.physicsBody?.contactTestBitMask {

              if !self.isballPause {

                  if self.randomColor == self.matchcolor {

                      self.scoreNumber += 1

//                    if feverModeActive {
//                        self.scoreNumber += 2
//                    } else {
//                        self.scoreNumber += 1
//                    }
//                    comboCount += 1
                  //  checkFeverMode()

                      self.circleNode1.run(SKAction.scaleX(by: 1.3, y: 1.3, duration: 0.3))
                      self.circleNode1.run(SKAction.scaleX(by: 0.77, y: 0.77, duration: 0.5))

                      self.circleNode1.size = CGSize(width: 260, height: 260)

                      self.scoreNumberLabel?.text = "\(self.scoreNumber)"

                      self.run(SKAction.playSoundFileNamed("getballsound.wav", waitForCompletion: false))

                  } else {

                      self.errorHaptic()
                      self.screenShake()
                      self.screenFlash()
                      self.isHiddenPlayAgianBtn = false
                      self.stopGame = true
                      //self.isUserInteractionEnabled = false
                      self.isPlayAgainActive = true

                      self.againPlayNode.run(SKAction.unhide())

                      self.displayHighScoreNexTLifeLabel()
                      comboCount = 0
                  }
              }
          }

          self.nextLifeCount -= 1

          if self.nextLifeCount == 0 {

              self.isHiddenPlayAgianBtn = false
              self.stopGame = true
              self.isUserInteractionEnabled = false
              self.isPlayAgainActive = true
              self.useLifeLineActive = true
          }

          self.nextLifeNumberlabel?.text = "\(self.nextLifeCount)"

          self.moveBall()
      }
  }
  */

  func didBegin(_ contact: SKPhysicsContact) {

        var ballNode: SKSpriteNode?
       // var circleNode: SKSpriteNode?

        if contact.bodyA.categoryBitMask == PhysicsCategory.ball &&
           contact.bodyB.categoryBitMask == PhysicsCategory.circle {

            ballNode = contact.bodyA.node as? SKSpriteNode
          //  circleNode = contact.bodyB.node as? SKSpriteNode

        } else if contact.bodyB.categoryBitMask == PhysicsCategory.ball &&
                  contact.bodyA.categoryBitMask == PhysicsCategory.circle {

            ballNode = contact.bodyB.node as? SKSpriteNode
            //circleNode = contact.bodyA.node as? SKSpriteNode
        }

        guard let ball = ballNode else { return }

    if self.randomColor == self.matchcolor {
        self.scoreNumber += 1
        self.circleNode1.run(SKAction.scaleX(by: 1.3, y: 1.3, duration: 0.3))
        self.circleNode1.run(SKAction.scaleX(by: 0.77, y: 0.77, duration: 0.5))
        self.circleNode1.size = CGSize(width: 260, height: 260)
        self.scoreNumberLabel?.text = "\(self.scoreNumber)"
        self.run(SKAction.playSoundFileNamed("getballsound.wav", waitForCompletion: false))

    } else {

        self.errorHaptic()
        self.screenShake()
        self.screenFlash()
        self.isHiddenPlayAgianBtn = false
        self.stopGame = true
        self.isPlayAgainActive = true
        self.againPlayNode.run(SKAction.unhide())
        self.displayHighScoreNexTLifeLabel()
        comboCount = 0
    }


      ball.removeFromParent()
  }


  func checkFeverMode() {

      if comboCount >= 10 && !feverModeActive {

          startFeverMode()
      }
  }

  func startFeverMode() {

      feverModeActive = true
      feverEndTime = CACurrentMediaTime() + 6   // 6 seconds fever

      ballSpeed *= 0.7   // increase speed slightly

      showFeverLabel()
  }

  func showFeverLabel() {

      feverLabel = SKLabelNode(fontNamed: "YoureGone-Regular-Bold")
      feverLabel?.text = "FEVER MODE!"
      feverLabel?.fontSize = 40
      feverLabel?.fontColor = .yellow
      feverLabel?.position = CGPoint(x: centerX, y: size.height * 0.6)
      feverLabel?.zPosition = 500

      guard let label = feverLabel else { return }

      addChild(label)

      let scaleUp = SKAction.scale(to: 1.5, duration: 0.3)
      let fadeOut = SKAction.fadeOut(withDuration: 1.2)

      label.run(SKAction.sequence([
          scaleUp,
          fadeOut,
          .removeFromParent()
      ]))
  }

  func ballSelectionWithColor() {
      randomColor = Int.random(in: 1...4)
      circle1.texture = ballTextures[randomColor - 1]
  }

  func moveBall() {
     self.circle1.position.y = self.size.height + 50
  }

}
extension MyScene {
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

      if touchEnabled {
         tapHaptic()
         colorChangesCircle()
      }

      guard let touch = touches.first else { return }
      let location = touch.location(in: self)
      let node = atPoint(location)

      if node.name == "agianPlay" {
          playAgainGame()
      }
       // PLAY AGAIN BUTTON
       if node.name == "againPlay" {
           playAgainGame()
       }
  }
  /*

  func ballSpeedIncreaseUpdator() {

      if scoreNumber >= 10 && scoreNumber < 11 {
          ballSpeed = 1.6
          ballIntervalUpdator = 2.1
      }
      else if scoreNumber >= 11 && scoreNumber < 20 {
          ballSpeed = 1.5
          ballIntervalUpdator = 1.8
      }
      else if scoreNumber >= 20 && scoreNumber < 30 {
          ballSpeed = 1.4
          ballIntervalUpdator = 1.6
      }
      else if scoreNumber >= 30 && scoreNumber < 40 {
          ballSpeed = 1.2
          ballIntervalUpdator = 1.5
      }
      else if scoreNumber >= 40 && scoreNumber < 50 {
          ballSpeed = 1.1
          ballIntervalUpdator = 1.4
      }
      else if scoreNumber >= 50 && scoreNumber <= 60 {
          ballSpeed = 1.0
          ballIntervalUpdator = 1.4
      }
      else if scoreNumber >= 60 && scoreNumber <= 70 {
          ballSpeed = 0.9
          ballIntervalUpdator = 1.3
      }
      else if scoreNumber >= 80 && scoreNumber <= 100 {
          ballSpeed = 0.8
          ballIntervalUpdator = 1.3
      }
      else if scoreNumber >= 100 && scoreNumber <= 120 {
          ballSpeed = 0.7
          ballIntervalUpdator = 1.2
      }
      else if scoreNumber >= 120 && scoreNumber <= 140 {
          ballSpeed = 0.6
          ballIntervalUpdator = 1.2
      }
      else if scoreNumber >= 140 && scoreNumber <= 160 {
          ballSpeed = 0.4
          ballIntervalUpdator = 1.0
      }
      else if scoreNumber <= 1 {
          ballSpeed = 1.7
          ballIntervalUpdator = 2.3
      }
  }

   */

  func ballSpeedIncreaseUpdator() {
      ballSpeed = max(0.7, 2.0 - Float(scoreNumber) * 0.015)
      ballIntervalUpdator = max(1.0, 2.5 - Float(scoreNumber) * 0.01)
  }
  func playAgainGame() {

      isPlayAgainActive = false


          scoreNumber = 0
          scoreNumberLabel?.text = "0"
      hideHighScoreNexTLifeLabel()

      highScoreLbl?.run(SKAction.fadeOut(withDuration: 1))
      nextLifeLine?.run(SKAction.fadeOut(withDuration: 1.3))

      touchEnabled = true
      stopGame = false

      againPlayNode.run(SKAction.hide())
      isHiddenPlayAgianBtn = true
  }

  func playAgainGameInitialise() {
      highScoreLbl?.run(SKAction.fadeIn(withDuration: 1.0))
      nextLifeLine?.run(SKAction.fadeIn(withDuration: 1.3))
      againPlayNode = SKSpriteNode(imageNamed: "try_again.png")
      againPlayNode.name = "agianPlay"
      againPlayNode.zPosition = 800
      againPlayNode.position = CGPoint(x: centerX, y: size.height * 0.25)
       againPlayNode.size = CGSize(width: 50, height: 50)
      addChild(againPlayNode)
      againPlayNode.run(SKAction.hide())
  }
}


extension MyScene {
  func scoreNumberInitialise() {

      let highestScore = UserDefaults.standard.string(forKey: "HighestScore") ?? "0"
      let lifeLine = UserDefaults.standard.string(forKey: "lifeLine") ?? "0"



          highScoreNumber = SKLabelNode(fontNamed: "YoureGone-Regular")
          highScoreNumber?.text = highestScore
          highScoreNumber?.fontSize = 30
          highScoreNumber?.fontColor = GameConstants.highScoreLabelColor
          highScoreNumber?.position = CGPoint(x: size.width * 0.2, y: size.height * 0.88)
          addChild(highScoreNumber!)

          scoreNumberLabel = SKLabelNode(fontNamed: "YoureGone-Regular")
          scoreNumberLabel?.text = "0"
          scoreNumberLabel?.fontSize = 26
          scoreNumberLabel?.position = CGPoint(x: centerX, y: size.height * 0.88)
          addChild(scoreNumberLabel!)

          nextLifeNumberlabel = SKLabelNode(fontNamed: "YoureGone-Regular")
          nextLifeNumberlabel?.text = lifeLine
          nextLifeNumberlabel?.fontSize = 30
          nextLifeNumberlabel?.fontColor = GameConstants.highScoreLabelColor
          nextLifeNumberlabel?.position = CGPoint(x: size.width * 0.8, y: size.height * 0.88)
          addChild(nextLifeNumberlabel!)
  }
  func scoreLabel() {



          highScoreLbl = SKLabelNode(fontNamed: "YoureGone-Regular")
          highScoreLbl?.text = "HIGH SCORE"
          highScoreLbl?.fontSize = 18
          highScoreLbl?.position =  CGPoint(x: size.width * 0.2, y: size.height * 0.91)
          addChild(highScoreLbl!)

          scoreLbl = SKLabelNode(fontNamed: "YoureGone-Regular")
          scoreLbl?.text = "SCORE"
          scoreLbl?.fontSize = 18
          scoreLbl?.position = CGPoint(x: centerX, y: size.height * 0.91)
          addChild(scoreLbl!)

          nextLifeLine = SKLabelNode(fontNamed: "YoureGone-Regular")
          nextLifeLine?.text = "LIFE LINE"
          nextLifeLine?.fontSize = 18
          nextLifeLine?.position = CGPoint(x: size.width * 0.8, y: size.height * 0.91)
          addChild(nextLifeLine!)



        highScoreLbl?.fontColor = GameConstants.highScoreLabelColor
        highScoreLbl?.run(SKAction.fadeOut(withDuration: 1.0))
        nextLifeLine?.run(SKAction.fadeOut(withDuration: 1.3))
  }
  func highScoreUpdator() {

      if highScore <= scoreNumber {
          highScore = scoreNumber
          highScoreNumber?.text = "\(highScore)"
      }
  }
  func hideHighScoreNexTLifeLabel() {

      highScoreLbl?.run(SKAction.fadeOut(withDuration: 1.0))
      nextLifeLine?.run(SKAction.fadeOut(withDuration: 1.3))
  }
  func displayHighScoreNexTLifeLabel() {

      highScoreLbl?.run(SKAction.fadeIn(withDuration: 1.0))
      nextLifeLine?.run(SKAction.fadeIn(withDuration: 1.3))
  }
  func themeSelection() {

      let hour = Calendar.current.component(.hour, from: Date())
      if hour >= 18 || hour <= 6 {
          backgroundColor = .black
          backgroundColorWhite = false
      } else {
          backgroundColor = .white
          backgroundColorWhite = true
      }
  }
}
extension MyScene {
  override func update(_ currentTime: TimeInterval) {

      ballSpeedIncreaseUpdator()
      powerIncrementScore()
      highScoreUpdator()

      if currentTime > timer && !stopGame {

        //  addingPhysicsToSprite()
          spawnBall()
          timer = currentTime + TimeInterval(ballIntervalUpdator)

      }
      else if currentTime > timer && stopGame && startPowerBall {

          timer = currentTime + 0.3

          if powerBallActive {
              powerBallSelection()
          }
      }

      if currentTime > colorCircleChangeTimer && stopGame && startPowerBall {

          colorCircleChangeTimer = currentTime + 0.3

          if !powerBallCompletion {
              // colorChangesCircle()
          }
      }


    let current = CACurrentMediaTime()

    if feverModeActive && current > feverEndTime {

        feverModeActive = false
        ballSpeed /= 0.7
    }
  }

  @objc func pauseGame() {
      stopGame = true
      saveScore()
  }

  func pauseScreen() {

      guard let viewController = self.view?.window?.rootViewController else { return }

      let alert = UIAlertController(
          title: "Resume",
          message: "To continue game",
          preferredStyle: .alert
      )

      alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
      alert.addAction(UIAlertAction(title: "OK", style: .default))

      viewController.present(alert, animated: true)
  }
  @objc func startAgain() {
      stopGame = true

      DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
          self.delayForTimer()
      }
  }
  func delayForTimer() {

      if isPlayAgainActive {
          stopGame = true
      } else {
          stopGame = false
      }
  }
  func saveScore() {

      UserDefaults.standard.set(nextLifeCount, forKey: "lifeLine")
      UserDefaults.standard.set(highScore, forKey: "HighestScore")

      UserDefaults.standard.synchronize()
  }
  func initialiseDBAccess() {

      let highestScore = UserDefaults.standard.integer(forKey: "HighestScore")
      let lifeLine = UserDefaults.standard.integer(forKey: "lifeLine")


      if highestScore == 0 && lifeLine == 0 {

          nextLifeCount = 400
          highScore = 0

          UserDefaults.standard.set(nextLifeCount, forKey: "lifeLine")
          UserDefaults.standard.set(highScore, forKey: "HighestScore")
          UserDefaults.standard.set(1, forKey: "IntialiseDatabase")
      }
      else {

          highScore = highestScore
          nextLifeCount = lifeLine
      }
  }

  func colorChangesCircle() {




  //  updateGlowColor()
      switch counter {

      case 1:

          matchcolor = 2

        circleNode1.texture = circleTextures[1]
        circleNode2.texture = circleTextures[2]
        circleNode3.texture = circleTextures[3]
        circleNode4.texture = circleTextures[0]



//          circleNode1.run(SKAction.colorize(with: GameConstants.greenColor, colorBlendFactor: 1, duration: 0))
//          circleNode2.run(SKAction.colorize(with: GameConstants.blueColor, colorBlendFactor: 1, duration: 0))
//          circleNode3.run(SKAction.colorize(with: GameConstants.yellowColor, colorBlendFactor: 1, duration: 0))
//          circleNode4.run(SKAction.colorize(with: GameConstants.redColor, colorBlendFactor: 1, duration: 0))

          counter = 2

      case 2:

          matchcolor = 3



        circleNode1.texture = circleTextures[2]
        circleNode2.texture = circleTextures[3]
        circleNode3.texture = circleTextures[0]
        circleNode4.texture = circleTextures[1]

//          circleNode1.run(SKAction.colorize(with: GameConstants.blueColor, colorBlendFactor: 1, duration: 0))
//          circleNode2.run(SKAction.colorize(with: GameConstants.yellowColor, colorBlendFactor: 1, duration: 0))
//          circleNode3.run(SKAction.colorize(with: GameConstants.redColor, colorBlendFactor: 1, duration: 0))
//          circleNode4.run(SKAction.colorize(with: GameConstants.greenColor, colorBlendFactor: 1, duration: 0))

          counter = 3

      case 3:




        matchcolor = 4
        circleNode1.texture = circleTextures[3]
        circleNode2.texture = circleTextures[0]
        circleNode3.texture = circleTextures[1]
        circleNode4.texture = circleTextures[2]

//          circleNode1.run(SKAction.colorize(with: GameConstants.yellowColor, colorBlendFactor: 1, duration: 0))
//          circleNode2.run(SKAction.colorize(with: GameConstants.redColor, colorBlendFactor: 1, duration: 0))
//          circleNode3.run(SKAction.colorize(with: GameConstants.greenColor, colorBlendFactor: 1, duration: 0))
//          circleNode4.run(SKAction.colorize(with: GameConstants.blueColor, colorBlendFactor: 1, duration: 0))

          counter = 4

      case 4:



          matchcolor = 1
        circleNode1.texture = circleTextures[0]
        circleNode2.texture = circleTextures[1]
        circleNode3.texture = circleTextures[2]
        circleNode4.texture = circleTextures[3]

     //   circleNode1.run(SKAction.colorize(with: GameConstants.redColor , colorBlendFactor: 1, duration: 0))
//          circleNode2.run(SKAction.colorize(with:  GameConstants.greenColor, colorBlendFactor: 1, duration: 0))
//          circleNode3.run(SKAction.colorize(with:  GameConstants.blueColor, colorBlendFactor: 1, duration: 0))
//          circleNode4.run(SKAction.colorize(with: GameConstants.yellowColor, colorBlendFactor: 1, duration: 0))

          counter = 1

      default:
          break
      }
  }

  func initialisePowerBall() {

      circle1.run(SKAction.moveTo(y: size.height * 0.25, duration: 4)) {

          self.moveBall()

          self.scoreNumber += 5
          self.scoreNumberLabel?.text = "\(self.scoreNumber)"

          DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
              self.delayForTimer()
          }
      }
  }
//  func powerIncrementScore() {
//
//      let powerLevels = [
//          10, 46, 65, 75, 98, 124, 147, 161, 178, 191, 211, 231
//      ]
//
//      if powerLevels.contains(scoreNumber) {
//
//          counter = 1
//          startPowerBall = true
//          powerBallActive = true
//          stopGame = true
//          powerBallCompletion = false
//      }
//  }
  func powerIncrementScore() {

      if scoreNumber % 25 == 0 &&
         scoreNumber != 0 &&
         scoreNumber != lastPowerScore {

          lastPowerScore = scoreNumber

          counter = 1
          startPowerBall = true
          powerBallActive = true
          stopGame = true
          powerBallCompletion = false
      }
  }
}
extension MyScene {


  func initialisePowerBallDesign() {
      let startY = size.height + 50
      ballNode1.position = CGPoint(x: 160, y: 600)
      ballNode1.size = CGSize(width: 25, height: 25)
      addChild(ballNode1)
      ballNode2.position = CGPoint(x: 160, y: 600)
      ballNode2.size = CGSize(width: 25, height: 25)
      addChild(ballNode2)
      ballNode3.position = CGPoint(x: 160, y: 600)
      ballNode3.size = CGSize(width: 25, height: 25)
      addChild(ballNode3)
      ballNode4.position = CGPoint(x: 160, y: 600)
      ballNode4.size = CGSize(width: 25, height: 25)
      addChild(ballNode4)
      ballNode5.position = CGPoint(x: 160, y: 600)
      ballNode5.size = CGSize(width: 25, height: 25)
      addChild(ballNode5)
      ballNode1.position = CGPoint(x: centerX, y: startY)
      ballNode2.position = CGPoint(x: centerX, y: startY)
      ballNode3.position = CGPoint(x: centerX, y: startY)
      ballNode4.position = CGPoint(x: centerX, y: startY)
      ballNode5.position = CGPoint(x: centerX, y: startY)
      ballNode1.run(SKAction.colorize(with: GameConstants.greenColor, colorBlendFactor: 1, duration: 0))
      ballNode2.run(SKAction.colorize(with: GameConstants.blueColor, colorBlendFactor: 1, duration: 0))
      ballNode3.run(SKAction.colorize(with: GameConstants.yellowColor, colorBlendFactor: 1, duration: 0))
      ballNode4.run(SKAction.colorize(with: GameConstants.redColor, colorBlendFactor: 1, duration: 0))
  }
  func movePowerBall(_ powerBall: SKSpriteNode) {

      powerBall.run(SKAction.moveTo(y: size.height * 0.25, duration: 0.8)) {

          self.scoreNumber += 1
          self.scoreNumberLabel?.text = "\(self.scoreNumber)"

        powerBall.run(SKAction.moveTo(y: self.size.height - 80, duration: 0))

          self.circleNode1.run(SKAction.scaleX(by: 1.3, y: 1.3, duration: 0.3))
          self.circleNode1.run(SKAction.scaleX(by: 0.8, y: 0.8, duration: 0.5))
          self.circleNode1.size = CGSize(width: 260, height: 260)

          self.run(SKAction.playSoundFileNamed("getballsound.wav", waitForCompletion: false))
      }

      powerBallCountStop += 1

      if powerBallCountStop == 8 {

          powerBallActive = false
          startPowerBall = false

          DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
              self.circleColorEffectStop()
          }

          powerBallCountStop = 1
      }
  }
  func powerBallSelection() {

      switch countPowerBall {

      case 1:
        movePowerBall(ballNode1)
          countPowerBall = 2

      case 2:
        movePowerBall(ballNode2)
          countPowerBall = 3

      case 3:
        movePowerBall(ballNode3)
          countPowerBall = 4

      case 4:
        movePowerBall(ballNode4)
          countPowerBall = 1

      default:
          break
      }
  }
  func circleColorEffectStop() {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
          self.delayForTimer()
      }
      powerBallCompletion = true
  }

  func powerLabelEffect() {

      powerRushNode = SKLabelNode(fontNamed: "YoureGone-Regular")
      powerRushNode?.text = "POWER RUSH"
      powerRushNode?.fontSize = 8
      powerRushNode?.fontColor = .red
      powerRushNode?.position = CGPoint(x: 160, y: 350)

      if let node = powerRushNode {
          addChild(node)
      }
      DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
          self.powerLabelEffectsAdded()
      }
  }

  func powerLabelEffectsAdded() {
      powerRushNode?.run(SKAction.scaleX(to: 5, y: 5, duration: 0.5))
  }
  func emitterEffect() {
      guard let fire = SKEmitterNode(fileNamed: "magic.sks") else { return }
      fire.position = CGPoint(x: size.width/2, y: size.height/2)
      fire.zPosition = -1
      fire.particlePositionRange = CGVector(
          dx: size.width,
          dy: size.height
      )
      fire.particleBirthRate = 80
      fire.particleLifetime = 5
      fire.targetNode = self
      addChild(fire)
  }
}
extension MyScene {
  // MARK: - Haptic Feedback

  func tapHaptic() {
      let generator = UIImpactFeedbackGenerator(style: .light)
      generator.prepare()
      generator.impactOccurred()
  }

  func errorHaptic() {
      let generator = UINotificationFeedbackGenerator()
      generator.notificationOccurred(.error)
  }

  // MARK: - Screen Shake Effect

  func screenShake() {

      guard let camera = self.camera else { return }

      let amplitude: CGFloat = 20
      let shakes = 10
      let duration: TimeInterval = 0.03

      var actions: [SKAction] = []

      for _ in 0..<shakes {

          let dx = CGFloat.random(in: -amplitude...amplitude)
          let dy = CGFloat.random(in: -amplitude...amplitude)

          let move = SKAction.moveBy(x: dx, y: dy, duration: duration)
          move.timingMode = .easeOut

          actions.append(move)
          actions.append(move.reversed())
      }

      let shake = SKAction.sequence(actions)
      camera.run(shake)
  }
  func createGlowRing() {

      let radius: CGFloat = 110

      glowRing = SKShapeNode(circleOfRadius: radius)
      glowRing?.position = CGPoint(x: centerX, y: size.height * 0.25)

      glowRing?.strokeColor = .white
      glowRing?.lineWidth = 6
      glowRing?.glowWidth = 25
      glowRing?.alpha = 0.8
      glowRing?.zPosition = 50

      if let ring = glowRing {
          addChild(ring)
      }

      glowRingPulse()
  }
  func glowRingPulse() {

      guard let ring = glowRing else { return }

      let fadeOut = SKAction.fadeAlpha(to: 0.4, duration: 0.8)
      let fadeIn = SKAction.fadeAlpha(to: 0.9, duration: 0.8)

      let pulse = SKAction.sequence([fadeOut, fadeIn])

      ring.run(SKAction.repeatForever(pulse))
  }
  func updateGlowColor() {

      guard let ring = glowRing else { return }

      switch matchcolor {

      case 1:
          ring.strokeColor = GameConstants.greenColor

      case 2:
          ring.strokeColor = GameConstants.blueColor

      case 3:
          ring.strokeColor = GameConstants.yellowColor

      case 4:
          ring.strokeColor = GameConstants.redColor

      default:
          break
      }
  }
}
extension MyScene {

  func setupGradientBackground() {

      // Make texture bigger than screen
      let bgSize = CGSize(width: size.width * 1.2,
                          height: size.height * 1.5)

      let texture = createGradientTexture(size: bgSize)

      gradientBackground = SKSpriteNode(texture: texture)
      gradientBackground?.position = CGPoint(x: centerX, y: centerY)
      gradientBackground?.size = bgSize
      gradientBackground?.zPosition = -20

      if let bg = gradientBackground {
          addChild(bg)
      }

      animateGradient()
  }
  func createGradientTexture(size: CGSize) -> SKTexture {

      let layer = CAGradientLayer()
      layer.frame = CGRect(origin: .zero, size: size)

      layer.colors = [
          UIColor(red: 0.2, green: 0.0, blue: 0.4, alpha: 1).cgColor,
          UIColor(red: 0.0, green: 0.6, blue: 1.0, alpha: 1).cgColor
      ]

      layer.startPoint = CGPoint(x: 0, y: 1)
      layer.endPoint = CGPoint(x: 1, y: 0)

      UIGraphicsBeginImageContext(layer.frame.size)
      layer.render(in: UIGraphicsGetCurrentContext()!)
      let image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()

      return SKTexture(image: image!)
  }

  func animateGradient() {

      guard let bg = gradientBackground else { return }

      let moveUp = SKAction.moveBy(x: 0, y: 60, duration: 8)
      let moveDown = SKAction.moveBy(x: 0, y: -60, duration: 8)

      let sequence = SKAction.sequence([moveUp, moveDown])
      let repeatForever = SKAction.repeatForever(sequence)

      bg.run(repeatForever)
  }
  func screenFlash() {

      let flash = SKSpriteNode(color: .red, size: size)
      flash.position = CGPoint(x: centerX, y: centerY)
      flash.alpha = 0
      flash.zPosition = 999

      addChild(flash)

      let fadeIn = SKAction.fadeAlpha(to: 0.5, duration: 0.08)
      let fadeOut = SKAction.fadeOut(withDuration: 0.25)

      flash.run(SKAction.sequence([fadeIn, fadeOut, .removeFromParent()]))
  }
}
struct PhysicsCategory {
    static let none: UInt32 = 0
    static let ball: UInt32 = 0x1 << 0
    static let circle: UInt32 = 0x1 << 1
}
