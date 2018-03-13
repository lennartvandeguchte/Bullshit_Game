//
//  Card.swift
//  Bullshit
//
//  Created by L.A. van de Guchte on 28/02/2018.
//  Copyright © 2018 L.A. van de Guchte. All rights reserved.
//

import Foundation

struct Card  {
    
    
    var isFaceUp = false
    var isInPiramyd = false
    var identifier: Int
    var symbol: String
    var value: Int
    
    // Initialize a card with a identifier, value and symbol
    init(identifier: Int){
        self.identifier = identifier
        value = identifier % 10
        switch identifier {
        case 1...9:
            symbol = "Clubs"
        case 10...18:
            symbol = "Spades"
        case 19...27:
            symbol = "Hearts"
        case 28...36:
            symbol = "Diamonds"
        default:
            symbol = "Clubs"
        }
    }
    
}
