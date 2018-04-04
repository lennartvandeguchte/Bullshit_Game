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
    
    
    /// ----Set variables----- ////////////////////////////////////////
    var game = Game()
    var model = CognitiveModel()

    
    var current_count_button: UIButton?
    @IBOutlet var player_cards_buttons: Array<UIButton>?
    @IBOutlet var pyramid_cards_buttons: [UIButton]!
    @IBOutlet var AI_cards_buttons: Array<UIButton>?
    
    @IBOutlet weak var call_bullshit: UIButton!
    
    @IBOutlet weak var num_cards_AI: UILabel!
    @IBOutlet weak var num_cards_player: UILabel!
    @IBOutlet weak var AI_says: UILabel!
    @IBOutlet weak var AI_plays: UILabel!
    
    @IBOutlet weak var pyramid_stackView: UIStackView!
    
    @IBOutlet weak var main_view: UIImageView!
    @IBOutlet weak var pyramid_4_view: UIStackView!
    @IBOutlet weak var pyramid_3_view: UIStackView!
    @IBOutlet weak var pyramid_2_view: UIStackView!
    
    @IBOutlet weak var players_cards_stackview: UIStackView!
    @IBOutlet weak var AI_cards_stackview: UIStackView!
    
    var claimed_cards_player = [Int](repeating: 0, count: 9)
    var card_value_to_play = 0
    var amount_cards_to_play = 0
    var should_be_current_pyramid_card = 1
    
    let numbers = ["zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten"]
    
    /// --- LOAD VIEW -----/////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        model.loadModel(fileName: "bullshit")
        model.run()
        game.viewController = self
        
        // Change buttons
        for button in pyramid_cards_buttons{
            button.layer.cornerRadius = 8;
            button.clipsToBounds = true;
            button.isEnabled = false
        }
        
        let button = self.view.viewWithTag(should_be_current_pyramid_card) as! UIButton
        button.isEnabled = true
        
        for button in player_cards_buttons!{
            button.layer.cornerRadius = 8;
            button.clipsToBounds = true;
        }
        for button in AI_cards_buttons!{
            button.layer.cornerRadius = 8;
            button.clipsToBounds = true;
        }
        

        
        // Show the cards of the player
        for i in 0..<game.cards_player.count{
            var card = game.cards_player[i]
            let card_name = "\(card.value)_\(card.symbol)"
            player_cards_buttons![i].setImage(UIImage(named: card_name)!, for: [])
            card.isFaceUp = true
            player_cards_buttons![i].tag = i
        }
        
        // Set the counters for number of cards AI and player
        num_cards_AI.text = "AI's Cards: \(game.cards_AI.count)"
        num_cards_player.text = "Your Cards: \(game.cards_player.count)"
        
        // Randomize which player starts the game
        if(Int(arc4random_uniform(UInt32(10))) > 5){
            for i in 0..<pyramid_cards_buttons.count{
                if pyramid_cards_buttons[i].tag == 1{
                    pyramid_cards_buttons[i].sendActions(for: .touchUpInside)
                    break
                }
            }
            AIs_turn()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //////////---START GAME ---//////////////////////////////////
    
    // Put pyramid card upside down when touch and indicate it as the current pyramid card to play with
    @IBAction func touch_pyramid_card(_ sender: UIButton) {
        
        // Get identifier of touched card
        let card_identifier = Int(sender.accessibilityIdentifier!)
        print("JOoooooo")
        print(should_be_current_pyramid_card)
        if game.cards_pyramid[card_identifier!-1].tag_pyramid == should_be_current_pyramid_card {
            print(game.cards_pyramid[card_identifier!-1].tag_pyramid)
            current_pyramid_card = game.cards_pyramid[card_identifier!-1]
        }
        // When a pyramid card is not yet touched, show the card
        if current_pyramid_card?.isFaceUp==false && current_pyramid_card?.isInPyramid==false && game.cards_pyramid[card_identifier!-1].tag_pyramid == should_be_current_pyramid_card {
            
            UIView.animate(withDuration: 0.25, animations: {
                sender.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            })
            
            let card_name = "\(current_pyramid_card!.value)_\(current_pyramid_card!.symbol)"
            sender.setImage(UIImage(named: card_name)!, for: [])
            
            game.cards_pyramid[card_identifier!-1].isFaceUp = true
            game.cards_pyramid[card_identifier!-1].isInPyramid = true
            current_pyramid_card = game.cards_pyramid[card_identifier!-1]
            
            //Get positions of current pyramid card and save them
            let positions: CGPoint
            switch current_pyramid_card!.index_pyramid{
            case 1:
                positions = main_view.convert(sender.center, from:pyramid_4_view)
                
            case 2:
                positions = main_view.convert(sender.center, from:pyramid_3_view)
            case 3:
                positions = main_view.convert(sender.center, from:pyramid_2_view)
            case 4:
                positions = main_view.convert(sender.center, from:pyramid_stackView)
            default:
                positions = main_view.convert(sender.center, from:pyramid_stackView)
            }
            print(positions)
            current_pyramid_card!.position_y = Int(positions.y)
            current_pyramid_card!.position_x = Int(positions.x)
            current_cards_on_table = []
        }
        
        
    }
    
    ///////////////---PLAYERS's TURN----/////////////////////////////////////////////////////
    
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
    
    // When cards are selected let the player decide which claim he/she wants to make by using a pop-up view
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
    
    /// Executed when the player has cancelled his claim
    func player_cancelled(){
        //player_cards_buttons![i].isSelected = false
    }
    
    /// Executed when a player has made a claim in the pop up window
    func player_made_claim(claimed_value: Int){
        var index: Array<Int>
        index = []
        
        // Count the amount of cards the player selected
        for i in 0..<player_cards_buttons!.count{
            if player_cards_buttons![i].isSelected == true {
                index.append(i)
                claimed_cards_player[claimed_value-2] += 1
                player_cards_buttons![i].isSelected = false
            }
        }
        
        // Remove the selected cards from players hand and update amount of cards of player
        for i in index{
            current_cards_on_table.append(game.cards_player[i])
        }
        
        for i in index.reversed(){
            game.cards_player.remove(at: i)
            player_cards_buttons![i].removeFromSuperview()
            player_cards_buttons?.remove(at: i)
        }
        
        num_cards_player.text = "Own Cards: \(game.cards_player.count)"
        
        //Show the amount of cards played on the table
        add_table_card_button(index: current_pyramid_card!.tag_pyramid, amount: index.count)
        
        // Count the amount of same valued cards as the current pyramid card of which the AI knows
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
        
        // The AI decides if he calss bullshit or not
        game.AI_decide_if_bullshit(diff_num_cards: (game.cards_AI.count - game.cards_player.count), pyramid_level: current_pyramid_card!.tag_pyramid, amount_cards_known: amount_cards_known_by_AI , amount_cards_claimed: claimed_cards_player[claimed_value-2], claimed_value: claimed_value, claimed_amount: index.count)
        
        
        AIs_turn()
    }
    
    
    ////////---- AI's TURN----///////////////////////////////////////////////////////
    
    // Store card amounts in the Cognitive model

    func AIs_turn(){
        var bullshit_card_value_AI: Int? = nil
        
        
        if ((current_pyramid_card!.pyramid_card_gone == true && current_pyramid_card!.tag_pyramid != 10) || current_pyramid_card!.pyramid_card_played == true) {
            for i in 0..<pyramid_cards_buttons.count{
                if pyramid_cards_buttons[i].tag == current_pyramid_card!.tag_pyramid+1{
                    should_be_current_pyramid_card += 1
                    let button = self.view.viewWithTag(should_be_current_pyramid_card) as! UIButton
                    button.isEnabled = true
                    pyramid_cards_buttons[i].sendActions(for: .touchUpInside)
                    break
                }
            }
        }else if ((current_pyramid_card!.pyramid_card_gone == true && current_pyramid_card!.tag_pyramid == 10) || current_pyramid_card!.pyramid_card_played == true) {
            finalize_game()
        }
        
        if current_cards_on_table.count >= 1{
            should_be_current_pyramid_card += 1
            let button = self.view.viewWithTag(should_be_current_pyramid_card) as! UIButton
            button.isEnabled = true
        }
        var lower_boundary = current_pyramid_card!.value-current_pyramid_card!.index_pyramid
        if lower_boundary < 2{lower_boundary = 2}
        var upper_boundary = current_pyramid_card!.value+current_pyramid_card!.index_pyramid
        if upper_boundary > 10{upper_boundary=10}
    
        var count_hist_AI = [Int](repeating: 0, count: 9)
        var cards_out_of_range = [Card]()
        var cards_in_range = [Card]()
        for i in 0..<game.cards_AI.count{
            count_hist_AI[game.cards_AI[i].value-2] += 1
            print(game.cards_AI[i].value)
            
            if game.cards_AI[i].value >= lower_boundary && game.cards_AI[i].value <= upper_boundary{
                cards_in_range.append(game.cards_AI[i])
            }else{
                cards_out_of_range.append(game.cards_AI[i])
            }
        }
        print("count hist \(count_hist_AI)")
        
        let AIs_decision = model.decideStrat(current_card: current_pyramid_card!) // This needs to be changed to the decision of the cognitive model
        print("Decisioin of AI: \(AIs_decision)")
        
        if AIs_decision == "play_truth" {
            let tmp_count_hist_AI = count_hist_AI[lower_boundary-2...upper_boundary-2]
            card_value_to_play = tmp_count_hist_AI.index(of: tmp_count_hist_AI.max()!)!+2
            if card_value_to_play == 0{
                card_value_to_play = count_hist_AI.index(of: count_hist_AI.max()!)!+2
                bullshit_card_value_AI = Int(arc4random_uniform(UInt32(upper_boundary-lower_boundary)))+lower_boundary
            }
            amount_cards_to_play = count_hist_AI.max()!
            print(card_value_to_play)
            
            model.storeCard(card_number: card_value_to_play)
            model.retrieveCard()
            
            print(count_hist_AI.max()!)
            
            play_cards_AI(bullshit_card_value_AI: bullshit_card_value_AI)
            
        } else if AIs_decision == "play_bullshit"{
            var identified_cards_AI = [Card]()
            // If the AI has less cards than the player do a small bluff else do a big bluff

            if(cards_out_of_range.isEmpty){
                let randomIndex = Int(arc4random_uniform(UInt32(cards_in_range.count)))
                identified_cards_AI.append(cards_in_range[randomIndex])
            }else{
                let randomIndex = Int(arc4random_uniform(UInt32(cards_out_of_range.count)))
                bullshit_card_value_AI = Int(arc4random_uniform(UInt32(upper_boundary-lower_boundary)))+lower_boundary
                identified_cards_AI.append(cards_out_of_range[randomIndex])
                cards_out_of_range.remove(at: randomIndex)
            }
            
            if(game.cards_AI.count > game.cards_player.count && cards_out_of_range.count >= 1){
                let randomIndex = Int(arc4random_uniform(UInt32(cards_out_of_range.count)))
                bullshit_card_value_AI = Int(arc4random_uniform(UInt32(upper_boundary-lower_boundary)))+lower_boundary
                identified_cards_AI.append(cards_out_of_range[randomIndex])
                cards_out_of_range.remove(at: randomIndex)
            }
            
            play_identified_cards_AI(bullshit_card_value_AI: bullshit_card_value_AI, identified_cards_AI: identified_cards_AI)
            
             
            
        }else if AIs_decision == "play_random"{
            var keepgoing = true
            while keepgoing == true{
                let random_index = Int(arc4random_uniform(9))
                print(random_index)
                if(count_hist_AI[random_index] > 0){
                    card_value_to_play = random_index+2
                    amount_cards_to_play = count_hist_AI[random_index]
                    
                    if(card_value_to_play >= lower_boundary && card_value_to_play <= upper_boundary){
                        play_cards_AI(bullshit_card_value_AI: nil)
                    }else{
                        bullshit_card_value_AI = Int(arc4random_uniform(UInt32(upper_boundary-lower_boundary)))+lower_boundary
                        play_cards_AI(bullshit_card_value_AI: bullshit_card_value_AI)
                    }
                    keepgoing = false
                }
            }
        }
       
    }
    
    func play_identified_cards_AI(bullshit_card_value_AI: Int?, identified_cards_AI: [Card]){
       
        for i in 0..<identified_cards_AI.count{
            for j in 0..<game.cards_AI.count{
                if game.cards_AI[j].value == identified_cards_AI[i].value{
                    current_cards_on_table.append(game.cards_AI[j])
                    game.cards_AI.remove(at: j)
                    num_cards_AI.text = "AI's Cards: \(game.cards_AI.count)"
                    AI_cards_buttons![i].removeFromSuperview()
                    AI_cards_buttons?.remove(at: i)
                    break
                    
                }
            }
        }
        
        add_table_card_button(index: current_pyramid_card!.tag_pyramid, amount: identified_cards_AI.count)
        
        if(bullshit_card_value_AI == nil){
            if(identified_cards_AI.count > 1 || identified_cards_AI.count < 1){
            AI_plays.text = "AI plays: I am playing \(numbers[identified_cards_AI.count]) \(card_value_to_play)'s"
            }else{
                AI_plays.text = "AI plays: I am playing \(numbers[identified_cards_AI.count]) \(card_value_to_play)"
            }
        }else{
            AI_plays.text = "AI plays: I am playing \(numbers[identified_cards_AI.count]) \(bullshit_card_value_AI!)'s"
        }
        
    }
    
    
    func play_cards_AI(bullshit_card_value_AI: Int?){
     
        for i in 0..<amount_cards_to_play{
            for j in 0..<game.cards_AI.count{
                if game.cards_AI[j].value == card_value_to_play{
                    current_cards_on_table.append(game.cards_AI[j])
                    game.cards_AI.remove(at: j)
                    num_cards_AI.text = "AI's Cards: \(game.cards_AI.count)"
                    if(AI_cards_buttons!.endIndex != 0){
                        AI_cards_buttons![i].removeFromSuperview()
                        AI_cards_buttons?.remove(at: i)
                    }
                    break
                }
            }
        }
        
        print("AI's really played \(amount_cards_to_play) \(card_value_to_play)'s")
        add_table_card_button(index: current_pyramid_card!.tag_pyramid, amount: amount_cards_to_play)
        
        if(bullshit_card_value_AI == nil){
            if(amount_cards_to_play > 1 || amount_cards_to_play < 1){
            AI_plays.text = "AI says: I am playing \(numbers[amount_cards_to_play]) \(card_value_to_play)'s"
            }else{
                AI_plays.text = "AI plays: I am playing \(numbers[amount_cards_to_play]) \(card_value_to_play)"
            }
        }else{
            AI_plays.text = "AI plays: I am playing \(numbers[amount_cards_to_play]) \(bullshit_card_value_AI!)'s"
        }
        
        if current_pyramid_card!.tag_pyramid == 10 && current_pyramid_card!.pyramid_card_played == true{
            print("FINZALIZE")
            finalize_game()
        }
    }
    
    ////////----- BULLSHIT OR NOT -----//////////////////////////////////////////////////////
    // Bullshit called is true
    func true_bullshit_called(player_or_AI: String){
        var counter = 1
        for _ in 0..<current_cards_on_table.count{
            if(player_or_AI == "AI"){
                game.cards_player.append(current_cards_on_table[current_cards_on_table.endIndex-1])
            }else{
                game.cards_AI.append(current_cards_on_table[current_cards_on_table.endIndex-1])
            }
            current_cards_on_table.remove(at: current_cards_on_table.endIndex-1)
            counter += 1
        }
        print("counter: \(counter)")
        
        if player_or_AI == "AI"{
            game.cards_player.append(current_pyramid_card!)
        }else{
            game.cards_AI.append(current_pyramid_card!)
        }
        print(current_pyramid_card!.tag_pyramid)
      
        for i in 0..<pyramid_cards_buttons.count{
            print(pyramid_cards_buttons[i].tag)
            if pyramid_cards_buttons[i].tag == current_pyramid_card!.tag_pyramid{
                //pyramid_cards_buttons[i].isHidden = true
                pyramid_cards_buttons[i].alpha = 0
                current_count_button!.isHidden = true
                print(pyramid_cards_buttons[i].tag)
            }
        }
        
        if player_or_AI == "AI"{
            add_card_players_hand(number_of_cards: counter)
        }else{
            add_card_AI_hand(number_of_cards: counter)
        }
        current_pyramid_card!.pyramid_card_gone = true
        
        if player_or_AI == "player" {
            should_be_current_pyramid_card += 1
            let button = self.view.viewWithTag(should_be_current_pyramid_card) as! UIButton
            button.isEnabled = true
        }
        
        if current_pyramid_card!.tag_pyramid == 10 && current_pyramid_card!.pyramid_card_played == true{
            print("FINZALIZE")
            finalize_game()
        }

    }
    
    // Bullshit called is false
    func false_bullshit_called(player_or_AI: String){
        var counter = 1
        for _ in 0..<current_cards_on_table.count{
            if player_or_AI == "AI"{
                game.cards_AI.append(current_cards_on_table[current_cards_on_table.endIndex-1])
            }else{
                game.cards_player.append(current_cards_on_table[current_cards_on_table.endIndex-1])
            }
            current_cards_on_table.remove(at: current_cards_on_table.endIndex-1)
            counter += 1
        }
       
        
        if player_or_AI == "AI"{
            game.cards_AI.append(current_pyramid_card!)
        }else{
            game.cards_player.append(current_pyramid_card!)
        }
        
        for i in 0..<pyramid_cards_buttons.count{
            print("TAG")
            print(pyramid_cards_buttons[i].tag)
            if pyramid_cards_buttons[i].tag == current_pyramid_card!.tag_pyramid{
                pyramid_cards_buttons[i].alpha = 0
                current_count_button!.isHidden = true
                print(pyramid_cards_buttons[i].tag)
            }
        }
        
        if player_or_AI == "AI"{
            add_card_AI_hand(number_of_cards: counter)
        }else{
            add_card_players_hand(number_of_cards: counter)
        }
        
        current_pyramid_card!.pyramid_card_gone = true
        
        if player_or_AI == "player" {
            should_be_current_pyramid_card += 1
            let button = self.view.viewWithTag(should_be_current_pyramid_card) as! UIButton
            button.isEnabled = true
        }
        
        
        if current_pyramid_card!.tag_pyramid == 10{
            print("FINZALIZE")
            finalize_game()
        }
    }
    
    
    @IBAction func player_called_bullshit(_ sender: UIButton) {
        
        let bullshit = game.check_if_bullshit(claimed_value: card_value_to_play, claimed_amount: amount_cards_to_play)
        
        if bullshit{
            true_bullshit_called(player_or_AI: "player")
        }else{
            false_bullshit_called(player_or_AI: "player")
        }
    }
    
    ///////---Finalize Game---/////////////////////////////////
    
    func finalize_game(){
        let difference = game.cards_AI.count - game.cards_player.count
        
        // Show pop up view
        let finalPopUp = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "finalPopUpID") as! bluffCallPopUpViewController
        finalPopUp.viewController = self
        
        if difference > 0{
            // AI wins
            finalPopUp.winner_text = "YOU WIN!"
        } else if difference < 0{
            // player wins
            finalPopUp.winner_text = "AI WINS"
        } else {
            // draw
            finalPopUp.winner_text = "DRAW"
        }
        
        self.addChildViewController(finalPopUp)
        finalPopUp.view.frame = self.view.frame
        self.view.addSubview(finalPopUp.view)
        finalPopUp.didMove(toParentViewController: self)
    }
    
    
    /////// ADDITIONAL FUNCTIONS //////////////////////////////////////////////
    
    // Update the AI says text window
    func update_AI_says(says: String){
        AI_says.text = says
    }
    
    /// Add an counter button to the pyramid card for which the claim is made
    func add_table_card_button(index: Int, amount: Int){
      
        let existing_button = self.view.viewWithTag(20+current_pyramid_card!.tag_pyramid) as? UIButton
        
        if existing_button == nil{
            
            let button = UIButton(type: .custom)
            button.frame = CGRect(x: current_pyramid_card!.position_x-35, y: current_pyramid_card!.position_y-35, width: 70, height: 70)
            button.layer.cornerRadius = 0.5 * button.bounds.size.width
            button.clipsToBounds = true
            button.backgroundColor = UIColor.black
            button.setTitle("\(amount)", for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 50)
            button.tag = 20+current_pyramid_card!.tag_pyramid
            view.addSubview(button)
            self.current_count_button = button
        }else{
            let current_amount = Int(existing_button!.currentTitle!)
            existing_button!.setTitle("\(current_amount!+amount)", for: .normal)
            current_pyramid_card!.pyramid_card_played = true
        }
        
        
    }
    
    // Add cards to the players hand
    func add_card_players_hand(number_of_cards: Int){
        for i in 0..<number_of_cards{
            if(!player_cards_buttons!.isEmpty){
                let button = player_cards_buttons?[player_cards_buttons!.endIndex-1].duplicate(forControlEvents: [.touchUpInside])
                let card_name = "\(game.cards_player[game.cards_player.endIndex-i-1].value)_\(game.cards_player[game.cards_player.endIndex-i-1].symbol)"
                button!.setImage(UIImage(named: card_name)!, for: [])
                button!.layer.cornerRadius = 8;
                button!.clipsToBounds = true;
                player_cards_buttons?.append(button!)
                players_cards_stackview.addArrangedSubview(button!)
            }else{
                let button = player_cards_buttons?[player_cards_buttons!.endIndex].duplicate(forControlEvents: [.touchUpInside])
                let card_name = "\(game.cards_player[game.cards_player.endIndex-i-1].value)_\(game.cards_player[game.cards_player.endIndex-i-1].symbol)"
                button!.setImage(UIImage(named: card_name)!, for: [])
                button!.layer.cornerRadius = 8;
                button!.clipsToBounds = true;
                player_cards_buttons?.append(button!)
                players_cards_stackview.addArrangedSubview(button!)
            }
        }
        num_cards_player.text = "Own Cards: \(game.cards_player.count)"
    }
    
    // Add cards to the AI's hand
    func add_card_AI_hand(number_of_cards: Int){
        for _ in 0..<number_of_cards{
            if(!AI_cards_buttons!.isEmpty){
                let button = AI_cards_buttons?[AI_cards_buttons!.endIndex-1].duplicate(forControlEvents: [.touchUpInside])
                button!.setImage(UIImage(named: "back")!, for: [])
                button!.layer.cornerRadius = 8;
                button!.clipsToBounds = true;
                AI_cards_buttons?.append(button!)
                AI_cards_stackview.addArrangedSubview(button!)
            }else{
                let button = AI_cards_buttons?[AI_cards_buttons!.endIndex]//.duplicate(forControlEvents: [.touchUpInside])
                button!.setImage(UIImage(named: "back")!, for: [])
                button!.layer.cornerRadius = 8;
                button!.clipsToBounds = true;
                AI_cards_buttons?.append(button!)
                AI_cards_stackview.addArrangedSubview(button!)
            }
            
        num_cards_AI.text = "Own Cards: \(game.cards_AI.count)"
    }
    }
}


extension UIButton {
    
    /// Creates a duplicate of the terget UIButton
    /// The caller specified the UIControlEvent types to copy across to the duplicate
    ///
    /// - Parameter controlEvents: UIControlEvent types to copy
    /// - Returns: A UIButton duplicate of the original button
    func duplicate(forControlEvents controlEvents: [UIControlEvents]) -> UIButton? {
        
        // Attempt to duplicate button by archiving and unarchiving the original UIButton
        let archivedButton = NSKeyedArchiver.archivedData(withRootObject: self)
        guard let buttonDuplicate = NSKeyedUnarchiver.unarchiveObject(with: archivedButton) as? UIButton else { return nil }
        
        // Copy targets and associated actions
        self.allTargets.forEach { target in
            
            controlEvents.forEach { controlEvent in
                
                self.actions(forTarget: target, forControlEvent: controlEvent)?.forEach { action in
                    buttonDuplicate.addTarget(target, action: Selector(action), for: controlEvent)
                }
            }
        }
        
        return buttonDuplicate
    }
}

