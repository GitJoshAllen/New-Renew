//
//  TabBarController.swift
//  RenewBiomass
//
//  Created by Jason Carothers on 2/11/15.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var farmer:String?
    var entity:String?
    var location:String?
    var acres:String?
    var farmNo:String?
    var tractNo:String?
    var county:String?
    var optionSelected:String?
    
    //added 1.3
    var email:String?
    var contactNo:String?
    //end 1.3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        if let controller = viewControllers![0] as? RhizomeViewController {
        }
        
        if let controller = viewControllers![1] as? ScoutingViewController {
            controller.farmer = farmer
            controller.acres = acres
            controller.farmNo = farmNo
            controller.tractNo = tractNo
            
            //added 1.3
            controller.county = county
            controller.email = email
            controller.contactNo = contactNo
            //end 1.3
        }
        
        if let controller = viewControllers![2] as? PlantingViewController {
            controller.farmer = farmer
            controller.entity = entity
            controller.location = location
            controller.acres = acres
            controller.farmNo = farmNo
            controller.tractNo = tractNo
            
            //added 1.3
            controller.county = county
            controller.email = email
            controller.contactNo = contactNo
            //end 1.3
        }
        
        if let controller = viewControllers![3] as? CaneViewController {
            controller.farmer = farmer
            controller.entity = entity
            controller.location = location
            controller.acres = acres
            controller.farmNo = farmNo
            controller.tractNo = tractNo
            controller.county = county
            
            //added 1.3
            controller.email = email
            controller.contactNo = contactNo
            //end 1.3
        }
        
        if let controller = viewControllers![4] as? MapViewController {
            controller.farmer = farmer
            controller.entity = entity
            controller.location = location
            controller.acres = acres
            
            //added 1.3
            controller.county = county
            controller.email = email
            controller.contactNo = contactNo
            //end 1.3
        }
        
        if let controller = viewControllers![5] as? NotesViewController {
        }
        
        if let controller = viewControllers![6] as? InfoViewController {
            controller.farmer = farmer
            controller.entity = entity
            controller.location = location
            controller.acres = acres
            
            //added 1.3
            controller.county = county
            controller.email = email
            controller.contactNo = contactNo
            //end 1.3
        }
        
        if optionSelected == "Rhizome" {
            self.viewControllers?.removeAtIndex(3)
            self.viewControllers?.removeAtIndex(2)
            self.viewControllers?.removeAtIndex(1)
        } else if optionSelected == "Scouting" {
            self.viewControllers?.removeAtIndex(3)
            self.viewControllers?.removeAtIndex(2)
            self.viewControllers?.removeAtIndex(0)
        } else if optionSelected == "Planting" {
            self.viewControllers?.removeAtIndex(3)
            self.viewControllers?.removeAtIndex(1)
            self.viewControllers?.removeAtIndex(0)
        } else if optionSelected == "Cane" {
            self.viewControllers?.removeAtIndex(2)
            self.viewControllers?.removeAtIndex(1)
            self.viewControllers?.removeAtIndex(0)
        } else {
            self.viewControllers?.removeAtIndex(3)
            self.viewControllers?.removeAtIndex(2)
            self.viewControllers?.removeAtIndex(1)
            self.viewControllers?.removeAtIndex(0)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
