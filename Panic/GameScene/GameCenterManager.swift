//
//  GameCenterManager.swift
//  Panic
//
//  Created by Karamjit Singh on 12/03/26.
//



import GameKit

class GameCenterManager {

    static let shared = GameCenterManager()

    func authenticatePlayer() {
        let localPlayer = GKLocalPlayer.local

        localPlayer.authenticateHandler = { viewController, error in
            if let vc = viewController {
                UIApplication.shared.windows.first?.rootViewController?
                    .present(vc, animated: true)
            } else if localPlayer.isAuthenticated {
                print("Game Center Authenticated")
            } else {
                print("Game Center Disabled")
            }

            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
  func submitScore(score: Int, id: String) {
      GKLeaderboard.submitScore(Int(score),
                                context: 0,
                                player: GKLocalPlayer.local,
                                leaderboardIDs:[id]) { error in
          if let error = error {
              print("Error submitting score: \(error)")
          } else {
              print("Score submitted successfully")
          }
      }
  }
}

