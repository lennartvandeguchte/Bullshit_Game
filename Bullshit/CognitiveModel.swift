//
//  CognitiveModel.swift
//  Bullshit
//
//  Created by L.A. van de Guchte on 28/02/2018.
//  Copyright © 2018 L.A. van de Guchte. All rights reserved.
//

import UIKit

// This class inherits from the ACT-R core file Model.swift and is therefore the head file for regulating the cognitive model.

class CognitiveModel: Model {
    
    var game = Game()
    
    func storeCard (card_number: Int) {
        let ch = generateNewChunk(string: "playedCard")
        ch.setSlot(slot: "num", value: String(card_number))
        dm.addToDM(ch)
    }
    
    func retrieveCard () {
        for ch in dm.chunks{
            print("retrieve \(ch.value.activation())")
        }
    }
    
    // AI decide whether it will lie or play the truth
    func decideStrat (current_card: Card) -> String {
        
        // Let AI play more random in the beginning than in the end.
        let randomprob = 70
        let randomDecision = randomprob - (7*current_card.tag_pyramid)
        let randVal = arc4random_uniform(100)
        
        if  randomDecision > randVal {
            return "play_random"
        }
        
        var AI_cards = game.cards_AI;
        var count_hist_AI = [Int](repeating: 0, count: 10)
        for i in 0..<AI_cards.count {
            count_hist_AI[AI_cards[i].value-1] += 1
            print(AI_cards[i].value)
        }
        
        //Make tmp_histogram that contains the frequencies of playable cards
        var lower_boundary = current_card.value-current_card.index_pyramid
        if lower_boundary < 1 { lower_boundary=1 }
        var upper_boundary = current_card.value+current_card.index_pyramid
        if upper_boundary > 10 { upper_boundary=10 }
        
        //Check if tmp_histogram is empty
        let tmp_count_hist_AI = count_hist_AI[ lower_boundary-1...upper_boundary-1 ]
        var tmp_empty = false
        
        print(tmp_count_hist_AI)
        
        for val in tmp_count_hist_AI {
            if val != 0 {
                tmp_empty = false
            }
        }
        
        print("tmp_empty: \(tmp_empty)")
        
        // If tmp_empty, play bullshit
        if tmp_empty {
            return "play_bullshit"
        } else {
            return "play_truth"
        }
    }
}


