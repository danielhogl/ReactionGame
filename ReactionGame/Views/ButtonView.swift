//
//  ButtonView.swift
//  ReactionGame
//
//  Created by Daniel Hogl on 24.11.22.
//

import SwiftUI

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
                        .opacity(0.5)
                        .scaleEffect(gameModel.isWaiting ? 2 : 1)
                        .animation(
                            gameModel.isWaiting ? .easeInOut(duration: 0.8).repeatForever(autoreverses: true) : .default,
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

#if DEBUG
struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(gameModel: .mock)
    }
}
#endif
