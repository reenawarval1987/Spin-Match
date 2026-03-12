//
//  ThemeCard.swift
//  Panic
//
//  Created by Karamjit Singh on 12/03/26.
//


import SwiftUI

struct ThemeCard: View {

    let theme: GameTheme
    let isSelected: Bool
    var action: () -> Void

    @State private var glow = false
    @State private var float = false

    var body: some View {

        Button(action: action) {

            ZStack {

                RoundedRectangle(cornerRadius: 20)
                    .fill(theme.previewGradient)
                    .frame(height: 130)

                Text(theme.title)
                    .font(.headline)
                    .foregroundColor(.white)

                if isSelected {
                    VStack {
                      HStack {
                        Spacer()
                        Image(systemName: "checkmark.circle.fill")
                          .font(.largeTitle)
                          .foregroundColor(.white).padding(10)
                      }
                      Spacer()
                  }

                }
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(isSelected ? Color.yellow : Color.clear, lineWidth: 4)
                .shadow(color: glow ? .yellow : .clear, radius: 12)
        )
        .scaleEffect(isSelected ? 1.05 : 1)
        .offset(y: float ? -4 : 4)
        .animation(.spring(response: 0.4), value: isSelected)
        .onAppear {

            if isSelected {

                withAnimation(
                    .easeInOut(duration: 1)
                    .repeatForever(autoreverses: true)
                ) {
                    glow.toggle()
                }
            }

            withAnimation(
                .easeInOut(duration: 2)
                .repeatForever(autoreverses: true)
            ) {
                float.toggle()
            }
        }
    }
}
