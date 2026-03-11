//
//  GameViewController.swift
//  Panic
//
//  Created by Karamjit Singh on 08/03/26.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
      guard let skView = self.view as? SKView else { return }

             let scene = HomeScreen(size: view.bounds.size)
             scene.scaleMode = .aspectFill

             skView.presentScene(scene)

             skView.ignoresSiblingOrder = true
             skView.showsFPS = true
             skView.showsNodeCount = true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
