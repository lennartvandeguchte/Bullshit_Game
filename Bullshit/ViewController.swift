//
//  ViewController.swift
//  Bullshit
//
//  Created by L.A. van de Guchte on 21/02/2018.
//  Copyright © 2018 L.A. van de Guchte. All rights reserved.
///Users/s2408287/Desktop/rps.actr

import UIKit

var current_pyramid_card: Card?

class ViewController: UIViewController{
    var game = Game()
    var model = CognitiveModel()
    
    @IBOutlet var player_cards_buttons: Array<UIButton>?
    @IBOutlet weak var num_cards_AI: UILabel!
    @IBOutlet weak var num_cards_player: UILabel!
   
   
    override func viewDidLoad() {
        super.viewDidLoad()
        model.loadModel(fileName: "bullshit")
        
        // Do any additional setup after loading the view, typically from a nib.
        // Show which cards the player has
        for i in 0..<game.cards_player.count{
            var card = game.cards_player[i]
            let card_name = "\(card.value)_\(card.symbol)"
            print(card_name)
            player_cards_buttons![i].setImage(UIImage(named: card_name)!, for: [])
            card.isFaceUp = true
            player_cards_buttons![i].tag = i
        }
        
        // Set the counters for number of cards AI and player
        num_cards_AI.text = "Ai's Cards: \(game.cards_AI.count)"
        num_cards_player.text = "Own Cards: \(game.cards_player.count)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // Highlight the players card when selected
    @IBAction func select_players_card(_ sender: UIButton) {
        if sender.isSelected == false {
            sender.frame.origin.y = sender.frame.origin.y - 20
            sender.isSelected = true
        }else{
            sender.frame.origin.y = sender.frame.origin.y + 20
            sender.isSelected = false
        }
    }
    
    // Put pyramid card upside down when touch and indicate it as the current pyramid card to play with
    @IBAction func touch_pyramid_card(_ sender: UIButton) {
        let card_identifier = Int(sender.accessibilityIdentifier!)
        current_pyramid_card = game.cards_pyramid[card_identifier!-1]
        print("Current pyramid card: \(current_pyramid_card!) \(card_identifier!)")
        
        if current_pyramid_card?.isFaceUp==false && current_pyramid_card?.isInPyramid==false{
            let card_name = "\(current_pyramid_card!.value)_\(current_pyramid_card!.symbol)"
            print(card_name)
            sender.setImage(UIImage(named: card_name)!, for: [])
        
            game.cards_pyramid[card_identifier!-1].isFaceUp = true
            game.cards_pyramid[card_identifier!-1].isInPyramid = true
            current_pyramid_card = game.cards_pyramid[card_identifier!-1]
            current_pyramid_card!.position_y = Int(sender.frame.origin.y)
            current_pyramid_card!.position_x = Int(sender.frame.origin.x)
        }
    }
    
    // When cards are selected let the player decide which claim he/she wants to make
    @IBAction func players_turn(_ sender: Any) {
        var highlighted_cards = [Card]()
        for i in 0..<player_cards_buttons!.count{
            if player_cards_buttons![i].isSelected == true {
                highlighted_cards.append(game.cards_player[i])
                player_cards_buttons![i].isSelected = false
                print("\(highlighted_cards[highlighted_cards.endIndex-1].value)")
                player_cards_buttons![i].frame.origin.y = CGFloat(current_pyramid_card!.position_y+10)
                player_cards_buttons![i].frame.origin.x = CGFloat(current_pyramid_card!.position_x)
            }
        } 
        
        // Show pop up view
        let popOverVC = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "claimPopUpID") as! claimPopUpViewController
        popOverVC.numberOfCards_text = "Number of Cards Selected: \(highlighted_cards.count)"
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        
    }
    
    
    
    
    func AIs_turn(){
        
        
    }
    
    
    
}
