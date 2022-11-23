//
//  ContentView.swift
//  ReactionGame
//
//  Created by Daniel Hogl on 17.11.22.
//

import SwiftUI
import ConfettiSwiftUI

struct ContentView: View {
    @ObservedObject var gameModel = ReactionGameModel()

    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                PlayerView(player: gameModel.player1)
                    .onTapGesture {
                        gameModel.tapped(player: gameModel.player1)
                    }
                
                PlayerView(player: gameModel.player2)
                    .onTapGesture {
                        gameModel.tapped(player: gameModel.player2)
                    }
            }

            ButtonView(gameModel: gameModel)
                .frame(height: 100)

        }
        .ignoresSafeArea()
    }
}

struct PlayerView: View {
    @ObservedObject var player: Player

    var body: some View {
        ZStack {
            player.backgroundColor

            if let time = player.time {
                Text("\(time.reactionTimeString)")
                    .font(.system(size: 38, weight: .heavy, design: .rounded))
                    .foregroundColor(player.tintColor)
                    .transition(.scale)
            }
        }
        .confettiCannon(
            counter: $player.wins,
            radius: 500,
            repetitions: 2,
            repetitionInterval: 0.75
        )

    }
}

struct ButtonView: View {
    @ObservedObject var gameModel: ReactionGameModel

    @State private var isAnimating = false

    var body: some View {

        Group {
            if gameModel.isTimerFired, gameModel.isGameRunning {
                Text("Press!")
                    .font(.system(size: 52, weight: .black, design: .rounded))
                    .frame(width: 340, height: 340)
                    .background(Color("accent"))
                    .foregroundColor(Color("player2"))
                    .clipShape(Circle())
                    .transition(.scale)

            } else {
                ZStack {
                    Circle()
                        .fill(Color("accent"))
                        .opacity(isAnimating ? 0.5 : 0)
                        .scaleEffect(isAnimating ? 2 : 1)
                        .animation(
                            .easeInOut(duration: 0.8).repeatForever(autoreverses: true),
                            value: isAnimating
                        )

                    Button {
                        gameModel.restart()
                        isAnimating = true
                    } label: {
                        Group {
                            if gameModel.isGameRunning {
                                Text("Wait...")
                            } else {
                                Text("Start Game!")
                            }
                        }
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                        .frame(width: 200, height: 200)
                        .background(Color("accent"))
                        .foregroundColor(Color("player1"))
                        .clipShape(Circle())
                    }
                    .disabled(isAnimating)
                    .transition(.scale)
                }
            }
        }
        .onChange(of: gameModel.isTimerFired, perform: { newValue in
            if newValue {
                isAnimating = false
            }
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
