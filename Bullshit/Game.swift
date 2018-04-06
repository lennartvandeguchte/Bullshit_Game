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
    var viewController: ViewController?
    var playing_deck = Deck()
    let cards_to_be_handed_out = 26
    let cards_in_pyramid = 10
    var cards_AI = [Card]()
    var cards_player = [Card]()
    var cards_pyramid = [Card]()
    var cards_played_by_AI = [Card]()
    
    // Machine learning parameters
    var target = 1
    let bullshit_threshold = 0.5
    var ML = MachineLearning(start: true) // Needs to be changed if we want to play multiple games with the same ML
    
    init(){
        // Hand out cards to the AI and the player
        for _ in 0..<(cards_to_be_handed_out/2){
            cards_AI.append(playing_deck.deck_shuffled[playing_deck.deck_shuffled.endIndex-1])
            playing_deck.deck_shuffled.remove(at: playing_deck.deck_shuffled.endIndex-1)
            cards_player.append(playing_deck.deck_shuffled[playing_deck.deck_shuffled.endIndex-1])
            playing_deck.deck_shuffled.remove(at: playing_deck.deck_shuffled.endIndex-1)
        }
        
        // Cards that are used to build the pyramid
        for i in 0..<cards_in_pyramid{
            cards_pyramid.append(playing_deck.deck_shuffled[playing_deck.deck_shuffled.endIndex-1])
            playing_deck.deck_shuffled.remove(at: playing_deck.deck_shuffled.endIndex-1)
            cards_pyramid[i].tag_pyramid = i+1
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
        
        
    }
    
   // Determine if AI calls bullshit or not by using a MLP
    func AI_decide_if_bullshit(diff_num_cards: Int, pyramid_level: Int, amount_cards_known: Int, amount_cards_claimed: Int, claimed_value: Int, claimed_amount: Int){
        print("AI decide if Bullshit")
        let input = [diff_num_cards, pyramid_level,amount_cards_known,amount_cards_claimed]
        
        print("MLP output:")
        print(ML.getChance(input2: input));
        
        if(ML.getChance(input2: input) > bullshit_threshold || cards_player.count == 0){
            viewController?.update_AI_says(says: "AI Says: Bullshit!")
            if(check_if_bullshit(claimed_value: claimed_value, claimed_amount: claimed_amount) == true){
                viewController?.true_bullshit_called(player_or_AI: "AI")
            }else{
                viewController?.false_bullshit_called(player_or_AI: "AI")
            }
        }else{
            viewController?.update_AI_says(says: "AI Says: I believe you")
            let bullshit_check = check_if_bullshit(claimed_value: claimed_value, claimed_amount: claimed_amount)
            if(cards_player.isEmpty && bullshit_check == true){
                viewController?.update_AI_says(says: "AI Says: Bullshit")
                viewController?.true_bullshit_called(player_or_AI: "AI")
            }else if(cards_player.isEmpty && bullshit_check == true){
                viewController?.update_AI_says(says: "AI Says: Bullshit")
                viewController?.false_bullshit_called(player_or_AI: "AI")
            }
        }
        
        print("update weights MLP")
        ML.updateWeights(target: target);
    }
    
    // Determine if it is really bullshit or not
    func check_if_bullshit(claimed_value: Int, claimed_amount: Int) -> Bool{
        var counter = 0
        var counter_2 = 0
        var lower_boundary = current_pyramid_card!.value-current_pyramid_card!.index_pyramid
        if lower_boundary < 2{lower_boundary = 2}
        var upper_boundary = current_pyramid_card!.value+current_pyramid_card!.index_pyramid
        if upper_boundary > 10{upper_boundary=10}
        print(current_cards_on_table.count)
        for i in 0..<claimed_amount{
            if current_cards_on_table[current_cards_on_table.endIndex-1-i].value == claimed_value{
                counter += 1
            }
            if (current_cards_on_table[current_cards_on_table.endIndex-1].value == current_cards_on_table[current_cards_on_table.endIndex-1-i].value) {
                counter_2 += 1
            }
        }
        
        if counter == claimed_amount && counter_2 == claimed_amount && claimed_value >= lower_boundary && claimed_value <= upper_boundary{
            target = 0
            print("Not Bullshit")
            return false
        }else{
            target = 1
            print("Bullshit")
            return true
        }
    }
    
    
    //ML.saveWeights()
    /// Need to be changed if we want to use machine learning over multiple games
//    if pyramid_level != 1{
//    ML = MachineLearning(start:false)
//    }
}
