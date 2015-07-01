//
//  CanePopoverController.swift
//  RenewBiomass
//
//  Created by Jason Carothers on 2/24/15.
//

import UIKit

protocol SendDataFromCanePopoverDelegate {
    func returnCaneData(weight:String, percent:String)
}

class CanePopoverController: UIViewController {
    
    var delegate:SendDataFromCanePopoverDelegate? = nil
    
    var sentWeight:String?
    var sentPercent:String?
    
    @IBOutlet weak var weightText: UITextField!
    @IBOutlet weak var percentText: UITextField!
    
    @IBAction func addItem(sender: UIButton) {
        self.weightText.resignFirstResponder()
        self.percentText.resignFirstResponder()
        
        if delegate != nil {
            
            let returnWeight:String = weightText.text
            let returnPercent:String = percentText.text

            delegate!.returnCaneData(returnWeight, percent: returnPercent)
            
            dismissViewControllerAnimated(false, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        weightText.text = sentWeight
        percentText.text = sentPercent
    }
}
