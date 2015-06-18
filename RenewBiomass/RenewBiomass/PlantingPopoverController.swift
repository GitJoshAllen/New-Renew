//
//  PlantingPopoverController.swift
//  RenewBiomass
//
//  Created by Jason Carothers on 2/24/15.
//

import UIKit

protocol SendDataFromPopoverDelegate {
    func returnData(bag:String, trailer:String, whbol:String, bagweight:String)
}

class PlantingPopoverController: UIViewController {
    
    var delegate:SendDataFromPopoverDelegate? = nil
    
    var sentBag:String?
    var sentTrailer:String?
    var sentWhbol:String?
    var sentBagweight:String?
    
    @IBOutlet weak var bagText: UITextField!
    @IBOutlet weak var trailerText: UITextField!
    @IBOutlet weak var whbolText: UITextField!
    @IBOutlet weak var bagweightText: UITextField!
    
    @IBAction func addItem(sender: UIButton) {
        if delegate != nil {
            
            let returnBag:String = bagText.text
            let returnTrailer:String = trailerText.text
            let returnWhbol:String = whbolText.text
            let returnBagweight:String = bagweightText.text

            delegate!.returnData(returnBag, trailer: returnTrailer, whbol: returnWhbol, bagweight: returnBagweight)
            
            //dismissViewControllerAnimated(false, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        bagText.text = sentBag
        trailerText.text = sentTrailer
        whbolText.text = sentWhbol
        bagweightText.text = sentBagweight
    }
}
