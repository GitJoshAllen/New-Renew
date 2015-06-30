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
    
    @IBOutlet weak var averagePlants: UILabel!
    @IBOutlet weak var averageTillers: UILabel!
    @IBOutlet weak var averageHeight: UILabel!
    
    var plantsArray:[String] = []
    var tillersArray:[String] = []
    var heightArray:[String] = []
    
    var columnLocation:CGFloat = 99.0
    var rowLocation:CGFloat = 311.0
    var rowHeight:CGFloat = 48.0
    var offset:CGFloat = 47.0
    var rowWidth:CGFloat = 48.0
    
    var dataColumn:Int = 0
    var dataRow:Int = 0
    
    var numberOfColumns = 0
    
    var averageOfPlants:Double = 0.0
    var averageOfTillers:Double = 0.0
    var averageOfHeight:Double = 0.0
    
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
        
//        switch result.value {
//        case MFMailComposeResultCancelled.value:
//            println("Mail cancelled")
//        case MFMailComposeResultSaved.value:
//            println("Mail saved")
//        case MFMailComposeResultSent.value:
//            println("Mail sent")
//        case MFMailComposeResultFailed.value:
//            println("Failed to send: \(error.localizedDescription)")
//        default: break
//            
//        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showScoutingPopover" {
            let ppc:ScoutingPopoverController = segue.destinationViewController as! ScoutingPopoverController
            ppc.delegate = self
            ppc.sentPlants = previousPlants
            ppc.sentTillers = previousTillers
            ppc.sentHeight = previousHeight
        }
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
        addColumn(plants, newTillers: tillers, newHeight: height)
        dismissViewControllerAnimated(false, completion: nil)
    }
    
    func addLabel(y:CGFloat, width:CGFloat, text:String) {
        var label = UILabel(frame: CGRectMake(columnLocation, y, width, rowHeight))
        label.layer.borderWidth = 1
        label.text = text
        label.textAlignment = .Center
        scoutingView.addSubview(label)
    }
    
    func addColumn(newPlants:String, newTillers:String, newHeight:String) {
        
        addLabel(rowLocation, width: rowWidth, text: newPlants)
        addLabel(rowLocation + offset, width: rowWidth, text: newTillers)
        addLabel(rowLocation + offset * 2, width: rowWidth, text: newTillers)
        
        columnLocation += offset
        
        
        plantsArray.append(newPlants)
        tillersArray.append(newTillers)
        heightArray.append(newHeight)
        
        previousPlants = newPlants
        previousTillers = newTillers
        previousHeight = newHeight
        
        numberOfColumns++
        
        recalculateAverages()
        
        if numberOfColumns >= 12 {
            addButton.enabled = false
        }
    }
    
    func recalculateAverages() {
        averageOfPlants = sum(plantsArray) / Double(numberOfColumns)
        averageOfTillers = sum(tillersArray) / Double(numberOfColumns)
        averageOfHeight = sum(heightArray) / Double(numberOfColumns)
        
        averagePlants.text = String(stringInterpolationSegment: Double(round(averageOfPlants*100)/100))
        averageTillers.text = String(stringInterpolationSegment: Double(round(averageOfTillers*100)/100))
        averageHeight.text = String(stringInterpolationSegment: Double(round(averageOfHeight*100)/100))
    }
    
    func sum(array:[String]) -> Double {
        var sumOfElements:Double = 0.0
        for index in 0...array.count - 1 {
            sumOfElements += (array[index] as NSString).doubleValue
        }
        return sumOfElements
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
