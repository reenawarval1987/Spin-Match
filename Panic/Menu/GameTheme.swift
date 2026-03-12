//
//  GameTheme.swift
//  Panic
//
//  Created by Karamjit Singh on 12/03/26.
//


import SwiftUI

enum GameTheme: String, CaseIterable {

    case sunrise
    case moonNight
    case neon
    case ocean
    case forest
    case sunset
    case galaxy

    var title: String {

        switch self {
        case .moonNight: return "Moon Night"
        case .neon: return "Neon"
        case .ocean: return "Ocean"
        case .forest: return "Forest"
        case .sunrise: return "Sunrise"
        case .sunset: return "Sunset"
        case .galaxy: return "Galaxy"
        }
    }
}

extension GameTheme {

    var previewGradient: LinearGradient {

        switch self {

        case .moonNight:
            return LinearGradient(
                colors: [
                    Color.black,
                    Color(red: 0.02, green: 0.02, blue: 0.08),
                    Color(red: 0.05, green: 0.05, blue: 0.15),
                    Color(red: 0.1, green: 0.1, blue: 0.25)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

        case .sunrise:
            return LinearGradient(
                colors: [
                    Color.white,
                    Color(red: 1.0, green: 0.93, blue: 0.85),
                    Color(red: 0.85, green: 0.92, blue: 1.0)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

        case .neon:
            return LinearGradient(
                colors: [
                    Color(red: 0.2, green: 0.0, blue: 0.4),
                    Color(red: 0.0, green: 0.6, blue: 1.0)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

        case .sunset:
            return LinearGradient(
                colors: [
                    Color(red: 1.0, green: 0.4, blue: 0.2),
                    Color(red: 1.0, green: 0.8, blue: 0.3)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

        case .ocean:
            return LinearGradient(
                colors: [
                    Color(red: 0.0, green: 0.3, blue: 0.6),
                    Color(red: 0.0, green: 0.8, blue: 0.9)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

        case .galaxy:
            return LinearGradient(
                colors: [
                    Color(red: 0.1, green: 0.0, blue: 0.2),
                    Color(red: 0.6, green: 0.0, blue: 0.8)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

        case .forest:
            return LinearGradient(
                colors: [
                    Color(red: 0.0, green: 0.3, blue: 0.1),
                    Color(red: 0.3, green: 0.7, blue: 0.3)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
}
