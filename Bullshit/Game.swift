//
//  Game.swift
//  Bullshit
//
//  Created by L.A. van de Guchte on 28/02/2018.
//  Copyright © 2018 L.A. van de Guchte. All rights reserved.
//

import Foundation

class Game {
    // Initialize variables
    var playing_deck = Deck()
    let cards_to_be_handed_out = 26
    let cards_in_pyramid = 10
    var cards_AI = [Card]()
    var cards_player = [Card]()
    var cards_pyramid = [Card]()
    var cards_played_by_AI = [Card]()
    
    var viewController: ViewController?
    
    init(){
        
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
        for i in 0..<cards_in_pyramid{
            cards_pyramid.append(playing_deck.deck_shuffled[playing_deck.deck_shuffled.endIndex-1])
            playing_deck.deck_shuffled.remove(at: playing_deck.deck_shuffled.endIndex-1)
         
            
            
            switch (i+1){
            case 1:
                cards_pyramid[cards_pyramid.endIndex-1].index_pyramid = 4
            case 2...3:
                cards_pyramid[cards_pyramid.endIndex-1].index_pyramid = 3
            case 4...6:
                cards_pyramid[cards_pyramid.endIndex-1].index_pyramid = 2
            case 7...10:
                cards_pyramid[cards_pyramid.endIndex-1].index_pyramid = 1
            default:
                cards_pyramid[cards_pyramid.endIndex-1].index_pyramid = 0
            }
            
        }
        
//        // Cards left over in the playing deck
//        print("Cards in playing deck: ")
//        for i in 0..<playing_deck.deck_shuffled.count{
//            print("\(playing_deck.deck_shuffled[i])")
//
//        }
     
    }
    
   
    func AI_decide_if_bullshit(diff_num_cards: Int, pyramid_level: Int, amount_cards_known: Int, amount_cards_claimed: Int, claimed_value: Int, claimed_amount: Int){
        print("AI decide if Bullshit")
        
        var ML = MachineLearning(start: true)
        let input = [diff_num_cards, pyramid_level,amount_cards_known,amount_cards_claimed]
        let target = 1
        for _ in 0...10{
            print(ML.getChance(input2: input));
            ML.updateWeights(target: target);
            ML.saveWeights()
        }
        ML = MachineLearning(start:false)
        print("final:")
        print(ML.getChance(input2: input));
        
        if(ML.getChance(input2: input) > 0.7){
            viewController?.update_AI_says(says: "AI Says: Bullshit!")
            AI_calls_bullshit(claimed_value: claimed_value, claimed_amount: claimed_amount)
        }else{
            viewController?.update_AI_says(says: "AI Says: I believe you")
        }
        
    }
    
    func AI_calls_bullshit(claimed_value: Int, claimed_amount: Int) {
        var counter = 0
        print(current_cards_on_table.count)
        for i in 0..<current_cards_on_table.count{
            if current_cards_on_table[i].value == claimed_value{
                counter += 1
            }
        }
        
        if counter == claimed_amount{
            viewController?.false_bullshit()
        }else{
            viewController?.true_bullshit()
        }
    }
    
    
    
    
}
