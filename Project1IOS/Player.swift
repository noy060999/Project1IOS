//
//  Player.swift
//  Project1IOS
//
//  Created by user167523 on 6/13/20.
//  Copyright © 2020 NoyD. All rights reserved.
//

import Foundation
class Player {
    let MOVES_CONST = 25

    private var _playerName: String = ""
    private var _timeToFinishGame: Double = 0.0
    private var _movesPerGame: Int = 25
    
    init() {
        _playerName = "player"
    }
    var playerName: String{
        set{
            _playerName = newValue
        }
        get{
            return _playerName
        }
    }
    
    var timeToFinishGame: Double{
        set{
           _timeToFinishGame = newValue
        }
        get{
            return _timeToFinishGame
        }
    }
    
    var movesPerGame: Int{
        set{
           _movesPerGame = newValue
        }
        get{
            return _movesPerGame
        }
    }
    
}




