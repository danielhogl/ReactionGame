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
                PlayerView(gameModel: gameModel, player: gameModel.player1)
                PlayerView(gameModel: gameModel, player: gameModel.player2)
            }

            ButtonView(gameModel: gameModel)
                .frame(height: 100)
        }
        .ignoresSafeArea()
    }
}

struct PlayerView: View {
    @ObservedObject var gameModel: ReactionGameModel
    @ObservedObject var player: Player

    var body: some View {
        ZStack {
            Color.black

            player.backgroundColor
                .opacity(player.isDisabled ? 0.75 : 1)

            if player.isDisabled {
                Image(systemName: "lock.circle")
                    .font(.system(size: 48))
                    .foregroundColor(Color("accent"))
                    .transition(.scale)
            }

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
        .onTapGesture {
            gameModel.tapped(player: player)
        }
        .disabled(player.isDisabled)
    }
}

struct ButtonView: View {
    @ObservedObject var gameModel: ReactionGameModel

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
                        .opacity(gameModel.isWaiting ? 0.5 : 0)
                        .scaleEffect(gameModel.isWaiting ? 2 : 1)
                        .animation(
                            gameModel.isWaiting ?
                                .easeInOut(duration: 0.8).repeatForever(autoreverses: true) : nil,
                            value: gameModel.isWaiting
                        )

                    Button {
                        gameModel.restart()
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
                    .disabled(gameModel.isWaiting)
                    .transition(.scale)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
