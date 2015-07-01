//
//  ScoutingPopoverController.swift
//  RenewBiomass
//
//  Created by Jason Carothers on 6/26/15.
//  Copyright (c) 2015 iCarothers. All rights reserved.
//

import UIKit

protocol SendDataFromScoutingPopoverDelegate {
    func returnFieldData(plants:String, tillers:String, height:String)
}

class ScoutingPopoverController: UIViewController {
    
    var delegate:SendDataFromScoutingPopoverDelegate? = nil
    
    var sentPlants:String?
    var sentTillers:String?
    var sentHeight:String?
    
    var isValid:Bool = true
    
    @IBOutlet weak var plantsText: UITextField!
    @IBOutlet weak var tillersText: UITextField!
    @IBOutlet weak var heightText: UITextField!
    
    @IBAction func addItem(sender: UIButton) {
        self.plantsText.resignFirstResponder()
        self.tillersText.resignFirstResponder()
        self.heightText.resignFirstResponder()
        
        if delegate != nil {
            
            let returnPlants:String = plantsText.text
            let returnTillers:String = tillersText.text
            let returnHeight:String = heightText.text
            
            if isValid {
                delegate!.returnFieldData(returnPlants, tillers: returnTillers, height: returnHeight)
                dismissViewControllerAnimated(false, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        plantsText.text = sentPlants
        tillersText.text = sentTillers
        heightText.text = sentHeight
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
