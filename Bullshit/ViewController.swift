//
//  ViewController.swift
//  Bullshit
//
//  Created by L.A. van de Guchte on 21/02/2018.
//  Copyright © 2018 L.A. van de Guchte. All rights reserved.
//

import UIKit


class ViewController: UIViewController{
    var game = Game()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    @IBAction func touch_pyramid_card(_ sender: UIButton) {
        let card_identifier = Int(sender.accessibilityIdentifier!)
        let card = game.cards_pyramid[card_identifier!-1]
        print("\(card_identifier!)")
        
        if card.isFaceUp==false && card.isInPyramid==false{
            let card_name = "\(card.value)_\(card.symbol)"
            print(card_name)
            sender.setImage(UIImage(named: card_name)!, for: [])
        
            game.cards_pyramid[card_identifier!-1].isFaceUp = true
            game.cards_pyramid[card_identifier!-1].isInPyramid = true
        }
        
    }
    
    
    
}
