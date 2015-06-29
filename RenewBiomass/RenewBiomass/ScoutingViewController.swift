//
//  ScoutingViewController.swift
//  RenewBiomass
//
//  Created by Jason Carothers on 6/12/15.
//  Copyright (c) 2015 iCarothers. All rights reserved.
//

import UIKit
import MessageUI

class ScoutingViewController: UIViewController, UIPopoverPresentationControllerDelegate, SendDataFromScoutingPopoverDelegate, MFMailComposeViewControllerDelegate {
    
    var farmer:String?
    var county:String?
    var farmNo:String?
    var tractNo:String?
    var acres:String?
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet var scoutingView: UIView!
    
    @IBOutlet weak var producerText: UITextField!
    @IBOutlet weak var countyText: UITextField!
    @IBOutlet weak var farmNoText: UITextField!
    @IBOutlet weak var tractNoText: UITextField!
    @IBOutlet weak var acresText: UITextField!
    @IBOutlet weak var assessorText: UITextField!
    @IBOutlet weak var dateText: UITextField!
    
    var plantsArray:[String] = []
    var tillersArray:[String] = []
    var heightArray:[String] = []
    
    var columnLocation:CGFloat = 0.0
    var rowLocation:CGFloat = 371.0
    var rowHeight:CGFloat = 50.0
    var offset:CGFloat = 49.0
    
    var dataColumn:Int = 0
    var dataRow:Int = 0
    
    var previousPlants:String = ""
    var previousTillers:String = ""
    var previousHeight:String = ""
    
    @IBAction func sendEmail(sender: UIButton) {
        if !MFMailComposeViewController.canSendMail() {
            return
        }
        
        var emailTitle = "Field Assessment"
        
        let toRecipients = ["jasonneutron@yahoo.com"]
        
        // Initialize the mail composer and populate the mail content
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self;
        mailComposer.setSubject(emailTitle)
        mailComposer.setMessageBody("", isHTML: true)
        mailComposer.setToRecipients(toRecipients)
        
        // Determine the MIME type
        var mimeType = "application/pdf"
        
        // 1. Create a print formatter
        var messageBody2 = ""
        
        let fmt = UIMarkupTextPrintFormatter(markupText: messageBody2)
        
        // 2. Assign print formatter to UIPrintPageRenderer
        let render = UIPrintPageRenderer()
        render.addPrintFormatter(fmt, startingAtPageAtIndex: 0)
        
        // 3. Assign paperRect and printableRect
        let page = CGRect(x: 0, y: 0, width: 612, height: 792)
        let printable = CGRectInset(page, 0, 0)
        render.setValue(NSValue(CGRect: page), forKey: "paperRect")
        render.setValue(NSValue(CGRect: printable), forKey: "printableRect")
        
        // 4. Create PDF context and draw
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, CGRectZero, nil)
        
        let myImage = UIImage(named: "logo")
        let rect = CGRectMake(0.0, 0.0, 216.0, 64.65)
        
        UIGraphicsBeginPDFPageWithInfo(page, nil)
        let bounds = UIGraphicsGetPDFContextBounds()
        render.drawPageAtIndex(0, inRect: bounds)
        myImage?.drawInRect(rect)
        
        UIGraphicsEndPDFContext();
        
        mailComposer.addAttachmentData(pdfData, mimeType: mimeType, fileName: "FieldAssessment.pdf")
        
        // Present mail view controller on screen
        presentViewController(mailComposer, animated: true, completion: nil)
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        
        switch result.value {
        case MFMailComposeResultCancelled.value:
            println("Mail cancelled")
        case MFMailComposeResultSaved.value:
            println("Mail saved")
        case MFMailComposeResultSent.value:
            println("Mail sent")
        case MFMailComposeResultFailed.value:
            println("Failed to send: \(error.localizedDescription)")
        default: break
            
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancel(sender: UIButton) {
        let alertController = UIAlertController(title: "Close?", message: "All text will be lost.", preferredStyle: .Alert)
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
    
    func returnFieldData(plants:String, tillers:String, height:String) {
        addRow(plants, newTillers: tillers, newHeight: height)
        dismissViewControllerAnimated(false, completion: nil)
    }
    
    func addLabel(x:CGFloat, width:CGFloat, text:String) {
        var label = UILabel(frame: CGRectMake(x, rowLocation, width, rowHeight))
        label.layer.borderWidth = 1
        label.text = text
        label.textAlignment = .Center
        scoutingView.addSubview(label)
    }
    
    func addRow(newPlants:String, newTillers:String, newHeight:String) {
        if dataColumn == 0 && dataRow == 0 {
            rowLocation += offset
        }
        
        addLabel(CGFloat(16) + columnLocation, width: 93, text: newPlants)
        addLabel(CGFloat(92 + 16) + columnLocation, width: 93, text: newTillers)
        
        dataColumn += 1
        columnLocation += 184
        
        if dataColumn > 3 {
            dataColumn = 0
            dataRow++
            
            rowLocation += offset
            columnLocation = 0.0
        }
        
        plantsArray.append(newPlants)
        tillersArray.append(newTillers)
        
        previousPlants = newPlants
        previousTillers = newTillers
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
