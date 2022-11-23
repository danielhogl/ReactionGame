//
//  ReactionGameModel.swift
//  ReactionGame
//
//  Created by Daniel Hogl on 18.11.22.
//

import SwiftUI

class Player: ObservableObject {
    let backgroundColor: Color
    let tintColor: Color
    @Published var time: TimeInterval?
    @Published var wins: Int = 0

    init(backgroundColor: Color, tintColor: Color, time: TimeInterval? = nil) {
        self.backgroundColor = backgroundColor
        self.tintColor = tintColor
        self.time = time
    }
}

class ReactionGameModel: ObservableObject {
    @Published var isGameRunning: Bool = false
    @Published var firedDate: Date?

    @Published var player1 = Player(backgroundColor: Color("player1"), tintColor: Color("player2"))
    @Published var player2 = Player(backgroundColor: Color("player2"), tintColor: Color("player1"))

    var isTimerFired: Bool {
        firedDate != nil
    }

    var randomInterval: TimeInterval {
        TimeInterval.random(in: 3...10)
    }

    var elapsedTime: TimeInterval {
        -(firedDate?.timeIntervalSinceNow ?? 0)
    }

    func restart() {
        player1.time = nil
        player2.time = nil
        firedDate = nil
        isGameRunning = true

        Timer.scheduledTimer(withTimeInterval: randomInterval, repeats: false) { timer in
            withAnimation {
                self.firedDate = Date()
            }
        }
    }

    func tapped(player: Player) {
        guard isTimerFired, player.time == nil else { return }

        withAnimation {
            player.time = elapsedTime
            evaluateWinner()
        }
    }

    func evaluateWinner() {
        guard let player1Time = player1.time, let player2Time = player2.time else {
            return
        }

        isGameRunning = false

        if player1Time < player2Time {
            player1.wins += 1
        } else if player2Time < player1Time {
            player2.wins += 1
        } else {
            player1.wins += 1
            player2.wins += 1
        }
    }
}

extension TimeInterval {
    var reactionTimeString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        formatter.usesGroupingSeparator = false
        let formattedTime = formatter.string(from: NSNumber(value: self * 1000)) ?? ""
        return formattedTime + " ms"
    }
}
