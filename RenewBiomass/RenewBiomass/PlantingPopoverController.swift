//
//  PlantingPopoverController.swift
//  RenewBiomass
//
//  Created by Jason Carothers on 2/24/15.
//

import UIKit

protocol SendDataFromPopoverDelegate {
    func returnData(bag:String, trailer:String, bol:String, bagweight:String)
}

class PlantingPopoverController: UIViewController {
    
    var delegate:SendDataFromPopoverDelegate? = nil
    
    var sentBag:String?
    var sentTrailer:String?
    var sentBol:String?
    var sentBagweight:String?
    
    @IBOutlet weak var bagText: UITextField!
    @IBOutlet weak var trailerText: UITextField!
    @IBOutlet weak var bolText: UITextField!
    @IBOutlet weak var bagweightText: UITextField!
    
    @IBAction func addItem(sender: UIButton) {
        if delegate != nil {
            
            let returnBag:String = bagText.text
            let returnTrailer:String = trailerText.text
            let returnBol:String = bolText.text
            let returnBagweight:String = bagweightText.text

            delegate!.returnData(returnBag, trailer: returnTrailer, bol: returnBol, bagweight: returnBagweight)
            
            dismissViewControllerAnimated(false, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        bagText.text = sentBag
        trailerText.text = sentTrailer
        bolText.text = sentBol
        bagweightText.text = sentBagweight
    }
}
