//
//  ViewController.swift
//  Bullshit
//
//  Created by L.A. van de Guchte on 21/02/2018.
//  Copyright © 2018 L.A. van de Guchte. All rights reserved.
///Users/s2408287/Desktop/rps.actr

import UIKit


var current_pyramid_card: Card?
var current_cards_on_table = [Card]()

class ViewController: UIViewController{
    
    
    /// Set variables ////////////////////////////////////////
    var game = Game()
    var model = CognitiveModel()
    
    var current_count_button: UIButton?
    @IBOutlet var player_cards_buttons: Array<UIButton>?
    @IBOutlet var pyramid_cards_buttons: [UIButton]!
    @IBOutlet var AI_cards_buttons: Array<UIButton>?
    
    @IBOutlet weak var num_cards_AI: UILabel!
    @IBOutlet weak var num_cards_player: UILabel!
    @IBOutlet weak var AI_says: UITextField!
    
    @IBOutlet weak var pyramid_stackView: UIStackView!
    
    @IBOutlet weak var main_view: UIImageView!
    @IBOutlet weak var pyramid_4_view: UIStackView!
    @IBOutlet weak var pyramid_3_view: UIStackView!
    @IBOutlet weak var pyramid_2_view: UIStackView!
    
    var claimed_cards_player = [Int](repeating: 0, count: 10)
    ////////////////////////////////////////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //model.loadModel(fileName: "bullshit")
        
        for button in pyramid_cards_buttons{
        button.layer.cornerRadius = 8;
        button.clipsToBounds = true;
        }
        
        
        for button in player_cards_buttons!{
            button.layer.cornerRadius = 8;
            button.clipsToBounds = true;
        }
        
        for button in AI_cards_buttons!{
            button.layer.cornerRadius = 8;
            button.clipsToBounds = true;
        }
        
        
        game.viewController = self
        AI_says.text = "AI Says:"
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
        game.cards_pyramid[card_identifier!-1].tag_pyramid = card_identifier!
        current_pyramid_card = game.cards_pyramid[card_identifier!-1]
      
        print("Current pyramid card: \(current_pyramid_card!) \(card_identifier!)")
    
        if current_pyramid_card?.isFaceUp==false && current_pyramid_card?.isInPyramid==false{
            let card_name = "\(current_pyramid_card!.value)_\(current_pyramid_card!.symbol)"
            print(card_name)
            sender.setImage(UIImage(named: card_name)!, for: [])
        
            game.cards_pyramid[card_identifier!-1].isFaceUp = true
            game.cards_pyramid[card_identifier!-1].isInPyramid = true
            current_pyramid_card = game.cards_pyramid[card_identifier!-1]
            
            //TODO: get positions of current pyramid card
            let positions: CGPoint
            switch current_pyramid_card!.index_pyramid{
            case 1:
                positions = main_view.convert(sender.center, from:pyramid_stackView)
            case 2:
                positions = main_view.convert(sender.center, from:pyramid_3_view)
            case 3:
                positions = main_view.convert(sender.center, from:pyramid_2_view)
            case 4:
                positions = main_view.convert(sender.center, from:pyramid_4_view)
            default:
                positions = main_view.convert(sender.center, from:pyramid_stackView)
            }
        
            current_pyramid_card!.position_y = Int(positions.y)
            current_pyramid_card!.position_x = Int(positions.x)
            print(positions.x)
            print(positions.y)
        }
    }
    
    // When cards are selected let the player decide which claim he/she wants to make
    @IBAction func claim_popup(_ sender: Any) {
        var count_highlighted_cards = 0
        for i in 0..<player_cards_buttons!.count{
            if player_cards_buttons![i].isSelected == true {
                count_highlighted_cards += 1
            }
        }
        
        // Show pop up view
        let popOverVC = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "claimPopUpID") as! claimPopUpViewController
        popOverVC.viewController = self
        popOverVC.numberOfCards_text = "Number of Cards Selected: \(count_highlighted_cards)"
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        
    }
    
    /// Executed when a player has made a claim in the pop up window
    func player_made_claim(claimed_value: Int){
        current_cards_on_table = []
        var index: Array<Int>
        index = []
        
        for i in 0..<player_cards_buttons!.count{
            if player_cards_buttons![i].isSelected == true {
                index.append(i)
                claimed_cards_player[claimed_value] += 1
                player_cards_buttons![i].isSelected = false
            }
        }
        
        for i in index{
            current_cards_on_table.append(game.cards_player[i])
            game.cards_player.remove(at: i)
            num_cards_player.text = "Own Cards: \(game.cards_player.count)"
            player_cards_buttons![i].removeFromSuperview()
            player_cards_buttons?.remove(at: i)
        }
        
        //Show the amount of cards played on the table
        add_table_card_button(index: current_pyramid_card!.tag_pyramid, amount: index.count)
        
        var amount_cards_known_by_AI = 0
        for i in 0..<game.cards_AI.count{
            if game.cards_AI[i].value == current_pyramid_card!.value{
                amount_cards_known_by_AI += 1
            }
        }
        
        for j in 0..<game.cards_played_by_AI.count{
            if game.cards_played_by_AI[j].value == current_pyramid_card!.value{
                amount_cards_known_by_AI += 1
            }
        }
        
        game.AI_decide_if_bullshit(diff_num_cards: (game.cards_AI.count - game.cards_player.count), pyramid_level: current_pyramid_card!.tag_pyramid, amount_cards_known: amount_cards_known_by_AI , amount_cards_claimed: claimed_cards_player[claimed_value], claimed_value: claimed_value, claimed_amount: index.count)
    }
    
    
    /// Executed when the player has cancelled his claim
    func player_cancelled(){
        //player_cards_buttons![i].isSelected = false
    }
    

    
    func add_card_players_hand(number_of_cards: Int){
    }
    
    func AIs_turn(){
    }
    
    func true_bullshit(){
        print("lalalala")
        var counter = 1
        for _ in 0..<current_cards_on_table.count{
            game.cards_player.append(current_cards_on_table[current_cards_on_table.endIndex-1])
            current_cards_on_table.remove(at: current_cards_on_table.endIndex-1)
            counter += 1
        }
        

        game.cards_player.append(current_pyramid_card!)
        print(current_pyramid_card!.tag_pyramid)
      
        for i in 0..<pyramid_cards_buttons.count{
            print(pyramid_cards_buttons[i].tag)
            if pyramid_cards_buttons[i].tag == current_pyramid_card!.tag_pyramid{
                pyramid_cards_buttons[i].isHidden = true
                current_count_button!.isHidden = true
                print(pyramid_cards_buttons[i].tag)
            }else if current_pyramid_card!.tag_pyramid == 1{
                pyramid_cards_buttons[9].isHidden = true
                current_count_button!.isHidden = true
            }
        }
        
        add_card_players_hand(number_of_cards: counter)
        
    }
    
    func false_bullshit(){
        
    }
    
    /////// ADDITIONAL FUNCTIONS //////////////////////////////////////////////
    
    // Update the AI says text window
    func update_AI_says(says: String){
        AI_says.text = says
    }
    
    /// Add an counter button to the pyramid card for which the claim is made
    func add_table_card_button(index: Int, amount: Int){
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: current_pyramid_card!.position_x-35, y: current_pyramid_card!.position_y-35, width: 70, height: 70)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.backgroundColor = UIColor.black
        button.setTitle("\(amount)", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 50)
        view.addSubview(button)
        
        self.current_count_button = button
    }
}
