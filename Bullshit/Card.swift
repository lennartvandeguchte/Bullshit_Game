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
    var isInPyramid = false
    var identifier: Int
    var symbol: String
    var value: Int
    
    // Initialize a card with a identifier, value and symbol
    init(identifier: Int){
        self.identifier = identifier
        switch identifier {
        case 1...9:
            value = identifier+1
            symbol = "club"
        case 10...18:
            value = identifier-8
            symbol = "spade"
        case 19...27:
            value = identifier-17
            symbol = "heart"
        case 28...36:
            value = identifier-26
            symbol = "diamond"
        default:
            symbol = "club"
            value = 0
        }
    }
    
}
