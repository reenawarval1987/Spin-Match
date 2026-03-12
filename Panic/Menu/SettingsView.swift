//
//  SettingsView.swift
//  Panic
//
//  Created by Karamjit Singh on 12/03/26.
//


import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("soundEnabled") private var soundEnabled = true
    @AppStorage("vibrationEnabled") private var vibrationEnabled = true

    var body: some View {

        ZStack {

            LinearGradient(
                colors: [.black, .purple.opacity(0.6)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 30) {

                Text("SETTINGS")
                    .font(.custom("YoureGone-Regular", size: 30))
                    .foregroundColor(.white)

                // Sound Card
                SettingCard(
                    title: "Music",
                    icon: soundEnabled ? "speaker.wave.2.fill" : "speaker.slash.fill",
                    color: Color("greenColor"),
                    isOn: $soundEnabled
                ).padding(.horizontal, 25).frame(height: 70)

                // Vibration Card
                SettingCard(
                    title: "Vibration",
                    icon: vibrationEnabled ? "iphone.radiowaves.left.and.right" : "iphone.slash",
                    color: Color("blueColor"),
                    isOn: $vibrationEnabled
                ).padding(25).frame(height: 70)


                Spacer()

              Button {
                dismiss()
              } label: {
                Text("MAIN MENU")
                  .font(.custom("YoureGone-Regular", size: 20))
                  .foregroundColor(.white)
                  .padding()
                  .frame(maxWidth: .infinity)
                  .background(
                    RoundedRectangle(cornerRadius: 18)
                      .fill(Color("yellowColor"))
                      .shadow(radius: 8)
                  )
              }
              .padding(.horizontal)
              .padding(.bottom, 30)
              VStack{
                Text("About")
                  .font(.headline)
                  .foregroundColor(.white)
                Text("Reflex Circle Game")
                  .foregroundColor(.white.opacity(0.7))
              }
              VStack{
                Text("Version")
                  .font(.headline)
                  .foregroundColor(.white)
                Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                  .foregroundColor(.white.opacity(0.7))
              }
            }
            .padding()
            }
        }
}
struct SettingCard: View {

    var title: String
    var icon: String
    var color: Color

    @Binding var isOn: Bool

    var body: some View {

        Button {
            withAnimation(.spring()) {
                isOn.toggle()
            }
        } label: {

            HStack {

                Image(systemName: icon)
                    .font(.custom("YoureGone-Regular", size: 20))
                    .foregroundColor(.white)
                    .frame(width: 50)

                Text(title)
                    .font(.custom("YoureGone-Regular", size: 20))
                    .foregroundColor(.white)

                Spacer()

                Text(isOn ? "ON" : "OFF")
                    .font(.custom("YoureGone-Regular", size: 20))
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(color.opacity(0.8))
                    .shadow(color: color, radius: 10)
            )
            .scaleEffect(isOn ? 1.05 : 1)
        }
    }
}
struct InfoCard: View {

    var title: String
    var subtitle: String

    var body: some View {

        HStack {

            Text(title)
                .font(.headline)
                .foregroundColor(.white)

            Spacer()

            Text(subtitle)
                .foregroundColor(.white.opacity(0.7))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.gray.opacity(0.3))
        )
    }
}
