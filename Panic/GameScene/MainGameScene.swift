//
//  MyScene.swift
//  Panic
//
//  Created by Karamjit Singh on 08/03/26.
//


import SpriteKit
import AVFoundation
import SwiftUI

class MainGameScene: SKScene,SKPhysicsContactDelegate {
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
    var colorCircleChangeTimer: TimeInterval = 0
    var highestScoreNode: SKLabelNode?
    var scoreNumberLabel: SKLabelNode?
    var highScoreLbl: SKLabelNode?
    var scoreLbl: SKLabelNode?
    var nextLifeLine: SKLabelNode?
    var videoShapeNode: SKShapeNode?
    var videoPlayer: AVPlayer?
    var videoNode: SKVideoNode?
    var backGround: SKSpriteNode?
    // Power ball sprites
    var redballNode = SKSpriteNode(texture:SKTexture(imageNamed: "red-ball"))
    var greenballNode = SKSpriteNode(texture:SKTexture(imageNamed: "green-ball"))
    var blueballNode = SKSpriteNode(texture:SKTexture(imageNamed: "blue-ball"))
    var yellowballNode = SKSpriteNode(texture:SKTexture(imageNamed: "yellow-ball"))
    var redballNode2 = SKSpriteNode(texture:SKTexture(imageNamed: "red-ball"))
    var powerRushNode: SKLabelNode?
    var touchEnabled:Bool = true
    var isNewRecord: Bool = false
    private var gameStarted = false
    var endOverlay: SKSpriteNode?
    private var startLabel: SKLabelNode!
    private var bgMusicPlayer: AVAudioPlayer?

  var circleNode1 = SKSpriteNode(texture:SKTexture(imageNamed: "red-ball"))
  var circleNode2  = SKSpriteNode(texture:SKTexture(imageNamed: "green-ball"))
  var circleNode3  =  SKSpriteNode(texture:SKTexture(imageNamed: "blue-ball"))
  var circleNode4  = SKSpriteNode(texture:SKTexture(imageNamed: "yellow-ball"))
  var circle1  =  SKSpriteNode(texture:SKTexture(imageNamed: "red-ball"))
  var lastPowerScore = 0
  var centerX: CGFloat { return size.width / 2 }
  var centerY: CGFloat { return size.height / 2 }
  var gradientBackground: SKSpriteNode?
  var comboCount = 0
  var feverModeActive = false
  var feverEndTime: TimeInterval = 0
  var feverLabel: SKLabelNode?
  var lastScoreTime: TimeInterval = 0

  var heartNodes: [SKSpriteNode] = []
  let maxLifeLine = 3
  var lifeLineCount = 3
  private var isGamePaused = true

  @AppStorage("soundEnabled") private var soundEnabled = true
  @AppStorage("vibrationEnabled") private var vibrationEnabled = true

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

    let cameraNode = SKCameraNode()
    cameraNode.position = CGPoint(x: centerX, y: centerY)
    self.camera = cameraNode
    addChild(cameraNode)

      configureGameScene()

      counter = 1
      timer = 0
      matchcolor = 1
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

  
  func gameOver() {

      stopGame = true
      isPlayAgainActive = true
      touchEnabled = false

      lifeLineCount = 3
      displayHighScoreNexTLifeLabel()
  }


  private func setupBackgroundMusic() {

      guard let url = Bundle.main.url(forResource: "background-game-music", withExtension: "mp3") else {
          print("Music file not found")
          return
      }
      do {
          bgMusicPlayer = try AVAudioPlayer(contentsOf: url)
          bgMusicPlayer?.numberOfLoops = -1   // infinite loop
          bgMusicPlayer?.volume = 0.6
          bgMusicPlayer?.prepareToPlay()
        if soundEnabled {
            bgMusicPlayer?.play()
        }

          print("Music started")
      } catch {
          print("Error loading music:", error)
      }
  }


  func configureGameScene() {

    setupBackgroundMusic()
      emitterEffect()
      setupGradientBackground()
      setFramesForSprite()
      playAgainGameInitialise()
      initialisePowerBallDesign()
      scoreLabel()
      scoreNumberInitialise()
      createHeartUI()
      showTapToStart()

  }

  func setFramesForSprite() {


      // Define positions and sizes for circle nodes

      let circleNodePosition = CGPoint(x: centerX, y: size.height * 0.25)
      let circleNodeSize1 = CGSize(width: 260, height: 260)
      let circleNodeSize2 = CGSize(width: 180, height: 180)
      let circleNodeSize3 = CGSize(width: 100, height: 100)
      let circleNodeSize4 = CGSize(width: 50, height: 50)
      circleNode1 = SKSpriteNode(texture: circleTextures[0]) //SKSpriteNode(imageNamed:"red-ball")
      circleNode1.position = circleNodePosition
      circleNode1.size = circleNodeSize1
      circleNode1.physicsBody = SKPhysicsBody(circleOfRadius: 100)
      circleNode1.physicsBody?.isDynamic = false
      circleNode1.physicsBody?.categoryBitMask = PhysicsCategory.circle
      circleNode1.physicsBody?.contactTestBitMask = PhysicsCategory.ball
      circleNode1.physicsBody?.collisionBitMask = PhysicsCategory.none
      circleNode1.name = "actionCircle"
      circleNode2 = SKSpriteNode(texture: circleTextures[1])
      circleNode2.position = circleNodePosition
      circleNode2.size = circleNodeSize2
      circleNode2.physicsBody = SKPhysicsBody(circleOfRadius: 100)
      circleNode2.physicsBody?.isDynamic = false
      circleNode2.physicsBody?.categoryBitMask = PhysicsCategory.circle
      circleNode2.physicsBody?.contactTestBitMask = PhysicsCategory.ball
      circleNode2.physicsBody?.collisionBitMask = PhysicsCategory.none
      circleNode2.name = "actionCircle"

      circleNode3 = SKSpriteNode(texture: circleTextures[2])
      circleNode3.position = circleNodePosition
      circleNode3.size = circleNodeSize3
      circleNode3.physicsBody = SKPhysicsBody(circleOfRadius: 100)
      circleNode3.physicsBody?.isDynamic = false
      circleNode3.physicsBody?.categoryBitMask = PhysicsCategory.circle
      circleNode3.physicsBody?.contactTestBitMask = PhysicsCategory.ball
      circleNode3.physicsBody?.collisionBitMask = PhysicsCategory.none
      circleNode3.name = "actionCircle"
      circleNode4 = SKSpriteNode(texture: circleTextures[3])
      circleNode4.position = circleNodePosition
      circleNode4.size = circleNodeSize4
      circleNode4.physicsBody = SKPhysicsBody(circleOfRadius: 100)
      circleNode4.physicsBody?.isDynamic = false
      circleNode4.physicsBody?.categoryBitMask = PhysicsCategory.circle
      circleNode4.physicsBody?.contactTestBitMask = PhysicsCategory.ball
      circleNode4.physicsBody?.collisionBitMask = PhysicsCategory.none
      circleNode4.name = "actionCircle"
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
        self.run(SKAction.playSoundFileNamed("confirmTap.mp3", waitForCompletion: false))

    } else {
      if vibrationEnabled {
          self.errorHaptic()
      }

        self.screenShake()
        self.screenFlash()
        isGamePaused = true

      if lifeLineCount > 0 {
          useLifeLine()
         } else {

           isGamePaused = true
           self.stopGame = true
           self.isPlayAgainActive = true
           self.isHiddenPlayAgianBtn = false
           self.displayHighScoreNexTLifeLabel()
           DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
             self.showEndScreen()
           }

         }
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
extension MainGameScene {
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {


    if !gameStarted {
      startLabel.removeFromParent()
      isGamePaused = false
      gameStarted = true
      return
    }
    if !gameStarted { return }

      guard let touch = touches.first else { return }
      let location = touch.location(in: self)

      let tappedNodes = nodes(at: location)


    for node in tappedNodes {

      if node.name == "restartButton" ||
         node.parent?.name == "restartButton" {
         playAgainGame()
         return
      }

      if node.name == "leaderboardButton" ||
          node.parent?.name == "leaderboardButton" {
        showLeaderShipBoard()
        return
      }
      if node.name == "mainMenuButton" ||
          node.parent?.name == "mainMenuButton" {
          quitToMenu()
        return
      }
      if node.name == "actionCircle" ||
          node.parent?.name == "actionCircle" {
        let virbrationEnabled = UserDefaults.standard.bool(forKey: "vibrationEnabled")
        if virbrationEnabled {
             tapHaptic()
        }

        colorChangesCircle()
        return
      }
    }
    // MARK: - Start Countdown




  }
  private func showTapToStart() {

      startLabel = SKLabelNode(fontNamed: "YoureGone-Regular")
      startLabel.text = "TAP TO START"
      startLabel.fontSize = 40
      startLabel.fontColor = .white
      startLabel.position = CGPoint(x: size.width/2,
                                    y: size.height/2)
      startLabel.zPosition = 1000
      addChild(startLabel)

      // Subtle pulse animation
      let pulseUp = SKAction.scale(to: 1.1, duration: 0.8)
      let pulseDown = SKAction.scale(to: 1.0, duration: 0.8)
      let pulse = SKAction.sequence([pulseUp, pulseDown])
      startLabel.run(SKAction.repeatForever(pulse))
      gameStarted = false
  }

  func ballSpeedIncreaseUpdator() {
      ballSpeed = max(0.7, 2.0 - Float(scoreNumber) * 0.015)
      ballIntervalUpdator = max(1.0, 2.5 - Float(scoreNumber) * 0.01)
  }
  func playAgainGame() {
      endOverlay?.removeFromParent()
      isPlayAgainActive = false
      resetHearts()
      scoreNumber = 0
      scoreNumberLabel?.text = "0"
      touchEnabled = true
      stopGame = false
      isHiddenPlayAgianBtn = true
      showTapToStart()
  }

  func playAgainGameInitialise() {
      highScoreLbl?.run(SKAction.fadeIn(withDuration: 1.0))
      nextLifeLine?.run(SKAction.fadeIn(withDuration: 1.3))
  }
}


extension MainGameScene {
  func scoreNumberInitialise() {

          let highestScore = UserDefaults.standard.integer(forKey: "HighestScore")
          highestScoreNode = SKLabelNode(fontNamed: "YoureGone-Regular")
          highestScoreNode?.text = "\(highestScore)"
          highestScoreNode?.fontSize = 30
          highestScoreNode?.fontColor = .white
          highestScoreNode?.position = CGPoint(x: size.width * 0.2, y: size.height * 0.88)
          addChild(highestScoreNode!)

          scoreNumberLabel = SKLabelNode(fontNamed: "YoureGone-Regular")
          scoreNumberLabel?.text = "0"
          scoreNumberLabel?.fontSize = 26
          scoreNumberLabel?.position = CGPoint(x: centerX, y: size.height * 0.88)
          addChild(scoreNumberLabel!)
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

  }
  func highScoreUpdator() {

      if highScore <= scoreNumber {
          highScore = scoreNumber
          highestScoreNode?.text = "\(highScore)"
      }
  }
  func displayHighScoreNexTLifeLabel() {
      highScoreLbl?.run(SKAction.fadeIn(withDuration: 1.0))
      nextLifeLine?.run(SKAction.fadeIn(withDuration: 1.3))
  }
}
extension MainGameScene {
  override func update(_ currentTime: TimeInterval) {
    if isGamePaused {
       return
    }
      ballSpeedIncreaseUpdator()
      powerIncrementScore()
      highScoreUpdator()

      if currentTime > timer && !stopGame {
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
      }


  }

  @objc func pauseGame() {
      stopGame = true
    //  saveScore()
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
          isGamePaused = false
      }
  }
  func colorChangesCircle() {

      switch counter {

      case 1:

          matchcolor = 2

        circleNode1.texture = circleTextures[1]
        circleNode2.texture = circleTextures[2]
        circleNode3.texture = circleTextures[3]
        circleNode4.texture = circleTextures[0]


          counter = 2

      case 2:

          matchcolor = 3



        circleNode1.texture = circleTextures[2]
        circleNode2.texture = circleTextures[3]
        circleNode3.texture = circleTextures[0]
        circleNode4.texture = circleTextures[1]

          counter = 3

      case 3:

        matchcolor = 4
        circleNode1.texture = circleTextures[3]
        circleNode2.texture = circleTextures[0]
        circleNode3.texture = circleTextures[1]
        circleNode4.texture = circleTextures[2]

          counter = 4

      case 4:
        matchcolor = 1
        circleNode1.texture = circleTextures[0]
        circleNode2.texture = circleTextures[1]
        circleNode3.texture = circleTextures[2]
        circleNode4.texture = circleTextures[3]
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
extension MainGameScene {


  func initialisePowerBallDesign() {
      let startY = size.height + 80
      redballNode.size = CGSize(width: 40, height: 40)
      addChild(redballNode)
      greenballNode.size = CGSize(width: 40, height: 40)
      addChild(greenballNode)
      blueballNode.size = CGSize(width: 40, height: 40)
      addChild(blueballNode)
      yellowballNode.size = CGSize(width: 40, height: 40)
      addChild(yellowballNode)
      redballNode2.size = CGSize(width: 40, height: 40)
      addChild(redballNode2)
      redballNode.position = CGPoint(x: centerX, y: startY)
      greenballNode.position = CGPoint(x: centerX, y: startY)
      blueballNode.position = CGPoint(x: centerX, y: startY)
      yellowballNode.position = CGPoint(x: centerX, y: startY)
      redballNode2.position = CGPoint(x: centerX, y: startY)

  }
  func movePowerBall(_ powerBall: SKSpriteNode) {

      powerBall.run(SKAction.moveTo(y: size.height * 0.25, duration: 0.8)) {

          self.scoreNumber += 1
          self.scoreNumberLabel?.text = "\(self.scoreNumber)"

          powerBall.run(SKAction.moveTo(y: self.size.height + 80, duration: 0))

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
        movePowerBall(redballNode)
          countPowerBall = 2

      case 2:
        movePowerBall(greenballNode)
          countPowerBall = 3

      case 3:
        movePowerBall(blueballNode)
          countPowerBall = 4

      case 4:
        movePowerBall(yellowballNode)
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
      guard let fire = SKEmitterNode(fileNamed: "sparkEmitter.sks") else { return }
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
extension MainGameScene {
  // MARK: - Haptic Feedback

  func tapHaptic() {
      let generator = UIImpactFeedbackGenerator(style: .medium)
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
}
extension MainGameScene {

  func setupGradientBackground() {

      // Make texture bigger than screen
      let bgSize = CGSize(width: size.width * 1.2,
                          height: size.height * 1.5)
    let themeString = UserDefaults.standard.string(forKey: "selectedTheme") ?? "neon"
    let theme = GameTheme(rawValue: themeString) ?? .neon
    let texture = createGradientTexture(size: bgSize, theme: theme)
      gradientBackground = SKSpriteNode(texture: texture)
      gradientBackground?.position = CGPoint(x: centerX, y: centerY)
      gradientBackground?.size = bgSize
      gradientBackground?.zPosition = -20

      if let bg = gradientBackground {
          addChild(bg)
      }

      animateGradient()
  }
 
  func createGradientTexture(size: CGSize, theme: GameTheme) -> SKTexture {

      let layer = CAGradientLayer()
      layer.frame = CGRect(origin: .zero, size: size)

      switch theme {

      case .moonNight:
        layer.colors = [
                UIColor.black.cgColor,
                UIColor(red: 0.02, green: 0.02, blue: 0.08, alpha: 1).cgColor,
                UIColor(red: 0.05, green: 0.05, blue: 0.15, alpha: 1).cgColor,
                UIColor(red: 0.1, green: 0.1, blue: 0.25, alpha: 1).cgColor
            ]

         case .sunrise:
        layer.colors = [
               UIColor.white.cgColor,
               UIColor(red: 1.0, green: 0.93, blue: 0.85, alpha: 1).cgColor,
               UIColor(red: 0.85, green: 0.92, blue: 1.0, alpha: 1).cgColor
           ]

      case .neon:
          layer.colors = [
              UIColor(red: 0.2, green: 0.0, blue: 0.4, alpha: 1).cgColor,
              UIColor(red: 0.0, green: 0.6, blue: 1.0, alpha: 1).cgColor
          ]

      case .sunset:
          layer.colors = [
              UIColor(red: 1.0, green: 0.4, blue: 0.2, alpha: 1).cgColor,
              UIColor(red: 1.0, green: 0.8, blue: 0.3, alpha: 1).cgColor
          ]

      case .ocean:
          layer.colors = [
              UIColor(red: 0.0, green: 0.3, blue: 0.6, alpha: 1).cgColor,
              UIColor(red: 0.0, green: 0.8, blue: 0.9, alpha: 1).cgColor
          ]

      case .galaxy:
          layer.colors = [
              UIColor(red: 0.1, green: 0.0, blue: 0.2, alpha: 1).cgColor,
              UIColor(red: 0.6, green: 0.0, blue: 0.8, alpha: 1).cgColor
          ]

      case .forest:
          layer.colors = [
              UIColor(red: 0.0, green: 0.3, blue: 0.1, alpha: 1).cgColor,
              UIColor(red: 0.3, green: 0.7, blue: 0.3, alpha: 1).cgColor
          ]
      }

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

extension MainGameScene {

  func createHeartUI() {

      let spacing: CGFloat = 30
      let startX = size.width * 0.72   // right side position

      for i in 0..<maxLifeLine {

          let heart = SKSpriteNode(imageNamed: "heart")
          heart.size = CGSize(width: 25, height: 25)

          heart.position = CGPoint(
              x: startX + CGFloat(i) * spacing,
              y: size.height * 0.89
          )

          heart.zPosition = 500

          addChild(heart)
          heartNodes.append(heart)
      }
  }

  func useLifeLine() {

      lifeLineCount -= 1
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
      if self.lifeLineCount >= 0 && self.lifeLineCount < self.heartNodes.count {

        let heart = self.heartNodes[self.lifeLineCount]

          let fade = SKAction.fadeOut(withDuration: 0.3)
          let scale = SKAction.scale(to: 0.1, duration: 0.3)

          heart.run(SKAction.group([fade, scale]))
      }

        self.isGamePaused = false
      }
      stopGame = false
      touchEnabled = true
  }

  func resetHearts() {

      lifeLineCount = maxLifeLine

      for heart in heartNodes {

          heart.alpha = 1
          heart.setScale(1)
      }
  }
  private func checkAndSaveRecord() {

      let previousRecord = UserDefaults.standard.integer(forKey: "HighestScore")

      if scoreNumber > previousRecord {
          UserDefaults.standard.set(scoreNumber, forKey: "HighestScore")
          isNewRecord = true
      } else {
          isNewRecord = false
      }
  }

  private func showEndScreen() {

      // Stop movement immediately
    checkAndSaveRecord()
    GameCenterManager.shared.submitScore(score:scoreNumber,id:"com.reena.spinmatch.highscore")
      // Black overlay
      let overlay = SKSpriteNode(color: .black, size: size)
      overlay.alpha = 0
      overlay.position = CGPoint(x: size.width/2,
                                 y: size.height/2)
      overlay.zPosition = 2000
      addChild(overlay)

      overlay.run(SKAction.fadeIn(withDuration: 0.5))
      endOverlay = overlay

      // Show result after fade
      run(SKAction.wait(forDuration: 0.5)) {

          self.showResultsPanel()
      }
  }
  private func showResultsPanel() {

      guard let overlay = endOverlay else { return }
      overlay.removeAllChildren()
      let record = UserDefaults.standard.integer(forKey: "HighestScore")

      // MARK: - Background Dim
      overlay.color = UIColor.black.withAlphaComponent(0.6)
      overlay.zPosition = 500
      endOverlay?.isUserInteractionEnabled = false

      // MARK: - Result Card (Rounded)
      let card = SKShapeNode(rectOf: CGSize(width: size.width * 0.85,
                                            height: 490),
                             cornerRadius: 25)

      card.fillColor = UIColor(red: 20/255,
                               green: 25/255,
                               blue: 45/255,
                               alpha: 0.98) // Same HUD color

      card.strokeColor = UIColor.white.withAlphaComponent(0.15)
      card.lineWidth = 2
      card.position = CGPoint(x: 0, y: 0)
      card.glowWidth = 6
      overlay.addChild(card)


      // MARK: - FINISH TITLE
      let finishLabel = SKLabelNode(fontNamed: "YoureGone-Regular")
      finishLabel.text = "Game Over"
      finishLabel.fontSize = 48
      finishLabel.fontColor = .white
      finishLabel.position = CGPoint(x: 0, y: 160)
      card.addChild(finishLabel)


      // MARK: - RECORD
      if isNewRecord {
          let newRecordLabel = SKLabelNode(fontNamed: "YoureGone-Regular")
          newRecordLabel.text = "🎉 NEW RECORD!"
          newRecordLabel.fontSize = 28
          newRecordLabel.fontColor = .systemYellow
          newRecordLabel.position = CGPoint(x: 0, y: 110)
          card.addChild(newRecordLabel)
         // createConfetti()
      } else {
          let recordLabel = SKLabelNode(fontNamed: "YoureGone-Regular")
          recordLabel.text = "Best Score: \(record)"
          recordLabel.fontSize = 28
          recordLabel.fontColor = .cyan
          recordLabel.position = CGPoint(x: 0, y: 110)
          card.addChild(recordLabel)
      }




      // MARK: - DISTANCE RESULT
      let distanceLabel = SKLabelNode(fontNamed: "YoureGone-Regular")
      distanceLabel.text = "High Score: \(scoreNumber)"
      distanceLabel.fontSize = 30
      distanceLabel.fontColor = .green
      distanceLabel.position = CGPoint(x: 0, y: 50)
      card.addChild(distanceLabel)


      // MARK: - RESTART BUTTON
      let restartButton = SKShapeNode(rectOf: CGSize(width: 240, height: 55),
                                      cornerRadius: 15)
      restartButton.fillColor = UIColor(named: "blueColor") ?? .systemBlue
      restartButton.strokeColor = .clear
      restartButton.position = CGPoint(x: 0, y: -30)
      restartButton.name = "restartButton"
      card.addChild(restartButton)

      let restartLabel = SKLabelNode(fontNamed: "YoureGone-Regular")
      restartLabel.text = "RESTART"
      restartLabel.fontSize = 22
      restartLabel.verticalAlignmentMode = .center
      restartLabel.name = "restartButton"
      restartButton.addChild(restartLabel)


      // MARK: - LEADERBOARD BUTTON
      let leaderboardButton = SKShapeNode(rectOf: CGSize(width: 240, height: 55),
                                          cornerRadius: 15)
      leaderboardButton.fillColor = UIColor(named: "yellowColor") ??  UIColor.systemYellow
      leaderboardButton.strokeColor = .clear
      leaderboardButton.position = CGPoint(x: 0, y: -100)
      leaderboardButton.name = "leaderboardButton"
      card.addChild(leaderboardButton)

      let leaderboardLabel = SKLabelNode(fontNamed: "YoureGone-Regular")
      leaderboardLabel.text = "LEADERBOARD"
      leaderboardLabel.fontSize = 20
      leaderboardLabel.verticalAlignmentMode = .center
      leaderboardLabel.name = "leaderboardButton"
      leaderboardButton.addChild(leaderboardLabel)

    let mainMenuButton = SKShapeNode(rectOf: CGSize(width: 240, height: 55),
                                        cornerRadius: 15)
    mainMenuButton.fillColor =  UIColor(named: "greenColor") ??  UIColor.green
    mainMenuButton.strokeColor = .clear
    mainMenuButton.position = CGPoint(x: 0, y: -170)
    mainMenuButton.name = "mainMenuButton"
    card.addChild(mainMenuButton)

    let mainMenuButtonLabel = SKLabelNode(fontNamed: "YoureGone-Regular")
    mainMenuButtonLabel.text = "Main Menu"
    mainMenuButtonLabel.fontSize = 20
    mainMenuButtonLabel.verticalAlignmentMode = .center
    mainMenuButtonLabel.name = "mainMenuButton"
    mainMenuButton.addChild(mainMenuButtonLabel)


      // MARK: - Button Pulse Animation
      let pulseUp = SKAction.scale(to: 1.05, duration: 0.6)
      let pulseDown = SKAction.scale(to: 1.0, duration: 0.6)
      let pulse = SKAction.sequence([pulseUp, pulseDown])
      restartButton.run(SKAction.repeatForever(pulse))


      // MARK: - Card Entrance Animation
      card.setScale(0.8)
      card.alpha = 0

      let scaleIn = SKAction.scale(to: 1.0, duration: 0.3)
      let fadeIn = SKAction.fadeIn(withDuration: 0.3)

      card.run(SKAction.group([scaleIn, fadeIn]))
  }

  private func restartGame() {
      let newScene = MainGameScene(size: self.size)
      newScene.scaleMode = .resizeFill
      self.view?.presentScene(newScene,
                              transition: SKTransition.fade(withDuration: 0.5))
  }
  private func quitToMenu() {
      bgMusicPlayer?.stop()
      NotificationCenter.default.post(name: .quitToMenu, object: nil)
  }
  private func showLeaderShipBoard() {
      //bgMusicPlayer?.stop()
    NotificationCenter.default.post(name: .leaderboard, object: nil)
  }

}

struct PhysicsCategory {
    static let none: UInt32 = 0
    static let ball: UInt32 = 0x1 << 0
    static let circle: UInt32 = 0x1 << 1
}

extension Notification.Name {
    static let startGame = Notification.Name("startGame")
    static let quitToMenu = Notification.Name("quitToMenu")
    static let leaderboard = Notification.Name("leaderboard")
}
