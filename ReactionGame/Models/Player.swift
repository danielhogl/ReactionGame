//
//  Player.swift
//  ReactionGame
//
//  Created by Daniel Hogl on 24.11.22.
//

import SwiftUI

class Player: ObservableObject {
    let backgroundColor: Color
    let tintColor: Color

    @Published var time: TimeInterval?
    @Published var wins: Int = 0
    @Published var hasTapped: Bool = true

    var isDisabled: Bool {
        hasTapped && time == nil
    }

    init(backgroundColor: Color, tintColor: Color, time: TimeInterval? = nil) {
        self.backgroundColor = backgroundColor
        self.tintColor = tintColor
        self.time = time
    }

    func reset() {
        time = nil
        hasTapped = false
    }
}

#if DEBUG
extension Player {
    static var mock: Player {
        Player(backgroundColor: Color("player1"), tintColor: Color("player2"))
    }
}
#endif
