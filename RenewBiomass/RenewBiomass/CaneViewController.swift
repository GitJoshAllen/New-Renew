//
//  CaneViewController.swift
//  RenewBiomass
//
//  Created by Jason Carothers on 6/12/15.
//  Copyright (c) 2015 iCarothers. All rights reserved.
//

import UIKit

class CaneViewController: UIViewController {
    
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
