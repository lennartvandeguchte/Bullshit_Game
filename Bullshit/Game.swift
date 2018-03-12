//
//  Game.swift
//  Bullshit
//
//  Created by L.A. van de Guchte on 28/02/2018.
//  Copyright © 2018 L.A. van de Guchte. All rights reserved.
//

import Foundation

class Game {
    
    
    init(){
        // Initialize variables
        var playing_deck = Deck()
        let cards_to_be_handed_out = 20
        let cards_in_pyramid = 10
        var cards_AI = [Card]()
        var cards_player = [Card]()
        var cards_pyramid = [Card]()
        
        
        // Test: print deck of cards
        for i in 0..<playing_deck.deck_shuffled.count{
            print("\(playing_deck.deck_shuffled[i])")
        }
        
        // Hand out cards to the AI and the player
        for _ in 0..<(cards_to_be_handed_out/2){
            print("\(playing_deck.deck_shuffled.endIndex)")
            cards_AI.append(playing_deck.deck_shuffled[playing_deck.deck_shuffled.endIndex-1])
            playing_deck.deck_shuffled.remove(at: playing_deck.deck_shuffled.endIndex-1)
            cards_player.append(playing_deck.deck_shuffled[playing_deck.deck_shuffled.endIndex-1])
            playing_deck.deck_shuffled.remove(at: playing_deck.deck_shuffled.endIndex-1)
        }
        
        // Cards that are used to build the pyramid
        for _ in 0..<cards_in_pyramid{
            cards_pyramid.append(playing_deck.deck_shuffled[playing_deck.deck_shuffled.endIndex-1])
            playing_deck.deck_shuffled.remove(at: playing_deck.deck_shuffled.endIndex-1)
        }
        
        // Cards left over in the playing deck
        print("Cards in playing deck: ")
        for i in 0..<playing_deck.deck_shuffled.count{
            print("\(playing_deck.deck_shuffled[i])")
        }
     
    }
    
    
    
    
}
