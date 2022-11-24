//
//  ContentView.swift
//  ReactionGame
//
//  Created by Daniel Hogl on 17.11.22.
//

import SwiftUI

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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
