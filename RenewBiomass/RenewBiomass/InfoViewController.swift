//
//  InfoViewController.swift
//  RenewBiomass
//
//  Created by Jason Carothers on 2/11/15.
//

import UIKit

class InfoViewController: UIViewController {
    
    @IBOutlet var farmerLabel:UILabel!
    @IBOutlet var entityLabel:UILabel!
    @IBOutlet var locationLabel:UILabel!
    @IBOutlet var acresLabel:UILabel!
    
    var farmer:String?
    var entity:String?
    var location:String?
    var acres:String?
    
    //added 1.3
    var county:String?
    var contactNo:String?
    var email:String?
    //end 1.3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        farmerLabel.text = farmer
        entityLabel.text = entity
        locationLabel.text = location
        acresLabel.text = acres
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
