//
//  ReactionGameModel.swift
//  ReactionGame
//
//  Created by Daniel Hogl on 18.11.22.
//

import SwiftUI

class ReactionGameModel: ObservableObject {
    @Published var isGameRunning: Bool = false {
        didSet {
            timer?.invalidate()
        }
    }

    @Published var firedDate: Date?

    @Published var player1 = Player(backgroundColor: Color("player1"), tintColor: Color("player2"))
    @Published var player2 = Player(backgroundColor: Color("player2"), tintColor: Color("player1"))

    private var timer: Timer?

    var isTimerFired: Bool {
        firedDate != nil
    }

    var isWaiting: Bool {
        isGameRunning && !isTimerFired
    }

    var randomInterval: TimeInterval {
        TimeInterval.random(in: 3...10)
    }

    var elapsedTime: TimeInterval {
        -(firedDate?.timeIntervalSinceNow ?? 0)
    }

    func restart() {
        player1.reset()
        player2.reset()
        firedDate = nil
        isGameRunning = true

        timer = Timer.scheduledTimer(withTimeInterval: randomInterval, repeats: false) { timer in
            withAnimation {
                self.firedDate = Date()
            }
        }
    }

    func tapped(player: Player) {
        guard isGameRunning else { return }

        defer {
            evaluateWinner()
        }

        withAnimation {
            player.hasTapped = true
        }

        guard isTimerFired, player.time == nil else { return }

        withAnimation {
            player.time = elapsedTime
        }
    }

    func evaluateWinner() {
        guard player1.hasTapped, player2.hasTapped else {
            return
        }

        withAnimation {
            isGameRunning = false
        }

        let player1Time = player1.time ?? .infinity
        let player2Time = player2.time ?? .infinity

        if player1Time == .infinity, player2Time == .infinity {
            return
        } else if player1Time < player2Time {
            player1.wins += 1
        } else if player2Time < player1Time {
            player2.wins += 1
        } else {
            player1.wins += 1
            player2.wins += 1
        }
    }
}

#if DEBUG
extension ReactionGameModel {
    static var mock: ReactionGameModel {
        ReactionGameModel()
    }
}
#endif

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
