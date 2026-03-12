//
//  GameViewController.swift
//  Panic
//
//  Created by Karamjit Singh on 08/03/26.
//

import UIKit
import SwiftUI
import SpriteKit
import GameKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateGameCenter()
        showMenu()
      NotificationCenter.default.addObserver(
          self,
          selector: #selector(showMenu),
          name: .quitToMenu,
          object: nil
      )
    }

  @objc  func showMenu() {

      let gameMenu = GameMenuView(){ actionItem in

          switch actionItem {
          case .play:
            self.startGame()
          break
        case .ranking:
            self.showLeaderboard()
          break
        case .theme:
          break
        case .settings:
          break
        }
      }
        let hostingController = UIHostingController(rootView: gameMenu)
        addChild(hostingController)
        hostingController.view.frame = view.bounds
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
    }

    func startGame() {

        let scene = MyScene(size: view.bounds.size)
        scene.scaleMode = .resizeFill

        let skView = SKView(frame: view.bounds)
        view.addSubview(skView)

        skView.presentScene(scene)
    }
  // MARK: - Game Center Login
  func authenticateGameCenter() {
      GKLocalPlayer.local.authenticateHandler = { vc, error in
          if let vc = vc {
              self.present(vc, animated: true)
          }
      }
  }
  // MARK: - Leaderboard
  func showLeaderboard() {
      let gcVC = GKGameCenterViewController()
      gcVC.gameCenterDelegate = self
      present(gcVC, animated: true)
  }

  override var prefersStatusBarHidden: Bool {
      true
  }
}
extension GameViewController: GKGameCenterControllerDelegate {

    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true)
    }
}
