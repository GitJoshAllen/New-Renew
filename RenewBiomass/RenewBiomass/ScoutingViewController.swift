//
//  ScoutingViewController.swift
//  RenewBiomass
//
//  Created by Jason Carothers on 6/12/15.
//  Copyright (c) 2015 iCarothers. All rights reserved.
//

import UIKit

class ScoutingViewController: UIViewController {
    
    var farmer:String?
    var county:String?
    var farmNo:String?
    var tractNo:String?
    var acres:String?
    
    @IBOutlet weak var producerText: UITextField!
    @IBOutlet weak var countyText: UITextField!
    @IBOutlet weak var farmNoText: UITextField!
    @IBOutlet weak var tractNoText: UITextField!
    @IBOutlet weak var acresText: UITextField!
    @IBOutlet weak var assessorText: UITextField!
    @IBOutlet weak var dateText: UITextField!
    
    @IBAction func cancel(sender: UIButton) {
        let alertController = UIAlertController(title: "Cancel?", message: "All text will be lost.", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Yes", style: .Default, handler: {
            (action: UIAlertAction!) in
            self.dismissViewControllerAnimated(false, completion: nil)
        }))
        alertController.addAction(UIAlertAction(title: "No", style: .Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        producerText.text = farmer
        countyText.text = county
        farmNoText.text = farmNo
        tractNoText.text = tractNo
        acresText.text = acres
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
