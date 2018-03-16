//
//  ViewController.swift
//  Bullshit
//
//  Created by L.A. van de Guchte on 21/02/2018.
//  Copyright © 2018 L.A. van de Guchte. All rights reserved.
///Users/s2408287/Desktop/rps.actr

import UIKit

var current_pyramid_card = Card(identifier: 1)

class ViewController: UIViewController{
    var game = Game()
    var model = CognitiveModel()
    
    @IBOutlet var player_cards_buttons: Array<UIButton>?
    @IBOutlet weak var num_cards_AI: UILabel!
    @IBOutlet weak var num_cards_player: UILabel!
   
    @IBAction func claimPopUp(_ sender: UIButton) {
        let popOverVC = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "claimPopUpID") as! claimPopUpViewController
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.loadModel(fileName: "bullshit")
        // Do any additional setup after loading the view, typically from a nib.
        for i in 0..<game.cards_player.count{
            var card = game.cards_player[i]
            let card_name = "\(card.value)_\(card.symbol)"
            print(card_name)
            player_cards_buttons![i].setImage(UIImage(named: card_name)!, for: [])
            card.isFaceUp = true
        }
        
        num_cards_AI.text = "Ai's Cards: \(game.cards_AI.count)"
        num_cards_player.text = "Own Cards: \(game.cards_player.count)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    @IBAction func touch_pyramid_card(_ sender: UIButton) {
        let card_identifier = Int(sender.accessibilityIdentifier!)
        current_pyramid_card = game.cards_pyramid[card_identifier!-1]
        print("\(card_identifier!)")
        
        if current_pyramid_card.isFaceUp==false && current_pyramid_card.isInPyramid==false{
            let card_name = "\(current_pyramid_card.value)_\(current_pyramid_card.symbol)"
            print(card_name)
            sender.setImage(UIImage(named: card_name)!, for: [])
        
            game.cards_pyramid[card_identifier!-1].isFaceUp = true
            game.cards_pyramid[card_identifier!-1].isInPyramid = true
        }
        
    }
    
    
    func players_turn(){
        var highlighted_cards = [Card]()
        for i in 0..<game.cards_player.count{
            if game.cards_player[i].playersCardHighlighted == true {
                highlighted_cards.append(game.cards_player[i])
                game.cards_player[i].playersCardHighlighted = false
            }
        }
        
        if highlighted_cards.isEmpty == false{
            var card_value: Int
            
            // POP-UP MENU
            
            // highlighted cards have to be replaced from hand to pyramid
            
            // AI has to decide if it is bullshit or not.
            
        }else{
            return
        }
    }
    
    
    func AIs_turn(){
        
        
    }
    
    
    
}
