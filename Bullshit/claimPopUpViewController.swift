//
//  claimPopUpViewController.swift
//  Bullshit
//
//  Created by Lisa Deckers on 16/03/2018.
//  Copyright © 2018 L.A. van de Guchte. All rights reserved.
//

import UIKit

class claimPopUpViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var numberOfCards: UILabel?
    @IBOutlet weak var claimSelector: UIPickerView!
    
    var numberOfCards_text: String?
    var claimData: [String] = [String]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        self.showAnimate()
        self.claimSelector.delegate = self
        self.claimSelector.dataSource = self
        
        
        // Display number of selected cards
        numberOfCards!.text = numberOfCards_text
        
        //create list of options for claim
        let value = current_pyramid_card!.value
        let index = current_pyramid_card!.index_pyramid
        
        for i in (value-index)...(value+index){
            if(i>=2 && i<=10){
                claimData.append(String(i))
            }
        }

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelClaimPopUp(_ sender: UIButton) {
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
    
    //number of columns for picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //number of rows for picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return claimData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return claimData[row]
    }
    
    

    @IBAction func claim(_ sender: UIButton) {
        
        
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
