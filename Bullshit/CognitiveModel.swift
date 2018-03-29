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
    var model: Game!
    
    func determineStrat () -> String {
        
        //Select strategy
        
        var stratArr = ["truth","bullshit","random"]
        var strat = ""
        
        //TODO: Decrease bullshitprob per round
        var bullshitprob = 70
        
        if Int(arc4random_uniform(100)) < bullshitprob {
            strat = stratArr[0]
        } else {
            strat = stratArr[1]
        }
        
        
        
        // Bullshitten met minimaal dan 2 kaarten??
        // Bullshit met kaarten die volgens het spel kunnen
        // Gespeelde kaarten opslaan
        
        return strat
        
    }
    
    
    
}
