//
//  ThemeSelectionView.swift
//  Panic
//
//  Created by Karamjit Singh on 12/03/26.
//


import SwiftUI

struct ThemeSelectionView: View {

    @Environment(\.dismiss) var dismiss

    @State private var selectedTheme: String =
        UserDefaults.standard.string(forKey: "selectedTheme") ?? GameTheme.sunrise.rawValue

    let themes = GameTheme.allCases

    var body: some View {

        ZStack {

            LinearGradient(
                colors: [.blue, .indigo],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 25) {

                Text("SELECT THEME")
                    .font(.custom("YoureGone-Regular", size: 40))
                    .foregroundColor(.white)

                ScrollView {

                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: 150))],
                        spacing: 20
                    ) {

                        ForEach(themes, id: \.self) { theme in

                            ThemeCard(
                                theme: theme,
                                isSelected: selectedTheme == theme.rawValue
                            ) {

                                withAnimation(.spring()) {
                                    selectedTheme = theme.rawValue
                                }
                            }
                        }
                    }
                    .padding()
                }
                .scrollIndicators(.hidden)

                Spacer()

               HStack {
                 Button {
                     UserDefaults.standard.set(selectedTheme, forKey: "selectedTheme")
                     dismiss()
                 } label: {

                     Text("SAVE")
                         .foregroundColor(.white)
                         .font(.custom("YoureGone-Regular", size: 20))
                         .frame(width: 160, height: 55)
                         .background(
                             RoundedRectangle(cornerRadius: 20)
                                 .fill(Color("greenColor"))
                         )
                 }

                 // MAIN MENU BUTTON
                 Button {

                     dismiss()

                 } label: {

                     Text("MAIN MENU")
                         .font(.custom("YoureGone-Regular", size: 20))
                         .foregroundColor(.white)
                         .frame(width: 160, height: 55)
                         .background(
                             RoundedRectangle(cornerRadius: 20)
                                 .fill(Color("redColor"))
                         )
                 }

              }
                // SAVE BUTTON

                Spacer()
            }
            .padding()
        }
    }
}
