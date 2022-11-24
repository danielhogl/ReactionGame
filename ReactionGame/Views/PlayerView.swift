//
//  PlayerView.swift
//  ReactionGame
//
//  Created by Daniel Hogl on 24.11.22.
//

import SwiftUI
import ConfettiSwiftUI

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
            num: 30,
            colors: [.blue, .red, .green, .yellow, .purple, .mint, .indigo],
            radius: 500,
            repetitions: 1,
            repetitionInterval: 0.75
        )
        .onTapGesture {
            gameModel.tapped(player: player)
        }
        .disabled(player.isDisabled)
    }
}

#if DEBUG
struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView(gameModel: .mock, player: .mock)
    }
}
#endif
