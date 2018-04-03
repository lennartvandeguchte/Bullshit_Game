//
//  bluffCallPopUpViewController.swift
//  Bullshit
//
//  Created by Lisa Deckers on 16/03/2018.
//  Copyright © 2018 L.A. van de Guchte. All rights reserved.
//

import UIKit

class bluffCallPopUpViewController: UIViewController {
    var viewController: ViewController?
    
    var winner_text: String?
    @IBOutlet weak var believe_claim: UIButton!
    @IBOutlet weak var call_bullshit: UIButton!
    
    @IBOutlet weak var winner_label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
    
        winner_label.text = winner_text!
        self.showAnimate()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func believeClaim(_ sender: UIButton) {
        self.removeAnimate()
    }
    
    @IBAction func bluffClaim(_ sender: UIButton) {
        self.removeAnimate()
    }
    
    func showAnimate(){
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate(){
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
