//
//  GameMenuView.swift
//  Panic
//
//  Created by Karamjit Singh on 11/03/26.
//


import SwiftUI


struct GameMenuView: View {

    var playAction: (MenuItem) -> Void

    @State private var showButtons = false
    @State private var playPulse = false
    @State private var titleFloat = false
    @State private var isThemeSelected = false
    @State private var titleGlow = false
    @State private var titleScale = false
    var body: some View {

        ZStack {

            LinearGradient(
                colors: [
                    Color.blue,
                    Color.blue.opacity(0.7),
                    Color.indigo
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 25) {

                Spacer()

                // Floating Title


              Text("Reflex Circle")
                  .font(.custom("YoureGone-Regular", size: 48))
                  .foregroundStyle(
                      LinearGradient(
                          colors: [
                              Color("redColor"),
                              Color("greenColor"),
                              Color("blueColor"),
                              Color("yellowColor")
                          ],
                          startPoint: .leading,
                          endPoint: .trailing
                      )
                  )
                  .shadow(color: titleGlow ? .yellow : .clear, radius: 15)
                  .scaleEffect(titleScale ? 1.05 : 1)
                  .offset(y: titleFloat ? -8 : 8)
                  .onAppear {

                      withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                          titleFloat.toggle()
                      }

                      withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                          titleGlow.toggle()
                      }

                      withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) {
                          titleScale.toggle()
                      }
                  }

                Spacer()

                // PLAY BUTTON (NOW ABOVE)
                Button {
                    playAction(.play)
                } label: {
                  Image("play-button")
                      .resizable()
                      .frame(width: 140, height: 140)
                      .scaleEffect(playPulse ? 1.08 : 1)
                      .shadow(color: .green.opacity(0.6), radius: 20)
                      .animation(
                          .easeInOut(duration: 1)
                          .repeatForever(autoreverses: true),
                          value: playPulse
                      )
                }

                .padding(.bottom, 15)

                // Buttons
                VStack(spacing: 18) {

                    MenuButton(
                        title: "LEADERBOARD",
                        icon: "trophy.fill",
                        color: Color("yellowColor")
                    ) {
                        playAction(.ranking)
                    }

                    MenuButton(
                        title: "THEME",
                        icon: "paintpalette.fill",
                        color: Color("blueColor")
                    ) {
                        //playAction(.theme)
                      isThemeSelected = true
                    }

                    MenuButton(
                        title: "SETTINGS",
                        icon: "gearshape.fill",
                        color: Color("redColor")
                    ) {
                        playAction(.settings)
                    }

                }
                .offset(y: showButtons ? 0 : 100)
                .opacity(showButtons ? 1 : 0)
                .animation(
                    .spring(response: 0.6, dampingFraction: 0.7),
                    value: showButtons
                )

                Spacer()

            }
            .padding()
        }
        .onAppear {

            titleFloat = true
            showButtons = true

            withAnimation(
                .easeInOut(duration: 1)
                .repeatForever()
            ) {
                playPulse.toggle()
            }
        }.fullScreenCover(isPresented: $isThemeSelected) {
          ThemeSelectionView()
        }
    }
}

enum MenuItem {
  case play
  case ranking
  case settings
  case theme
}


struct MenuButton: View {

    var title: String
    var icon: String
    var color: Color

  var action: () -> Void

    var body: some View {
        GeometryReader { geo in
            Button {
                action()
            } label: {
                HStack(spacing: 15) {
                    Image(systemName: icon)
                    .font(.title2)
                    Text(title)
                        .font(.custom("YoureGone-Regular", size: 20))
                  // Spacer()
                }
                .foregroundColor(.white)
                .frame(maxWidth: geo.size.width * 0.6)
                .frame(height: 70)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(color)
                )
            }
            // Expand to take available width so the 60% calculation is meaningful
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        // Prevent GeometryReader from collapsing; height matches the button height
        .frame(height: 70)
    }
}
