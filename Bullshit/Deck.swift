//
//  Deck.swift
//  Bullshit
//
//  Created by L.A. van de Guchte on 28/02/2018.
//  Copyright © 2018 L.A. van de Guchte. All rights reserved.
//

import Foundation


class Deck {
    
    
    var deck = [Card]()
    var numberOfCards = 36
    var deck_shuffled = [Card]();
    
    init(){
        // Create a deck of cards
        for identifier in 1...numberOfCards{
            let card = Card(identifier: identifier)
            deck.append(card)
        }
        // Shuffle the deck of cards
        for _ in 0..<deck.count
        {
            let rand = Int(arc4random_uniform(UInt32(deck.count)))
            deck_shuffled.append(deck[rand])
            deck.remove(at: rand)
        }
    }
}
