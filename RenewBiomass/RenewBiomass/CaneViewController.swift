//
//  CaneViewController.swift
//  RenewBiomass
//
//  Created by Jason Carothers on 2/23/15.
//

import UIKit
import MessageUI

class CaneViewController: UIViewController, UIPopoverPresentationControllerDelegate, SendDataFromCanePopoverDelegate, MFMailComposeViewControllerDelegate {
    
    @IBAction func cancel(sender: UIButton) {
        let alertController = UIAlertController(title: "Cancel?", message: "All text will be lost.", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Yes", style: .Default, handler: {
            (action: UIAlertAction!) in
            self.dismissViewControllerAnimated(false, completion: nil)
        }))
        alertController.addAction(UIAlertAction(title: "No", style: .Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet var caneView: UIView!
    @IBOutlet weak var buttonFromTop: NSLayoutConstraint!
    
    @IBOutlet weak var producerTextField: UITextField!
    @IBOutlet weak var countyTextField: UITextField!
    @IBOutlet weak var farmNumberTextField: UITextField!
    @IBOutlet weak var tractNumberTextField: UITextField!
    @IBOutlet weak var acresHarvestedTextField: UITextField!
    @IBOutlet weak var harvestDateTextField: UITextField!
    @IBOutlet weak var numberOfBalesTextField: UITextField!
    @IBOutlet weak var totalTonsTextField: UITextField!
    @IBOutlet weak var averageTonsTextField: UITextField!
    @IBOutlet weak var baleTypeTextField: UITextField!
    @IBOutlet weak var numberSampledTextField: UITextField!
    @IBOutlet weak var averageWeightTextField: UITextField!
    @IBOutlet weak var averageMoistureTextField: UITextField!
    
    var farmer:String?
    var entity:String?
    var location:String?
    var acres:String?
    var farmNo:String?
    var tractNo:String?
    var county:String?
    
    var weightArray:[String] = []
    var percentArray:[String] = []
    
    var rowLocation:CGFloat = 263.0
    var rowHeight:CGFloat = 50.0
    var offset:CGFloat = 49.0
    
    var previousWeight:String = ""
    var previousPercent:String = ""
    
    @IBAction func sendEmail(sender: UIButton) {
        if !MFMailComposeViewController.canSendMail() {
            return
        }
        
        var emailTitle = "Farmer: " + farmer!
        emailTitle += " Entity: " + entity!
        emailTitle += " Location: " + location!
        emailTitle += " Acres: " + acres!
        //        var messageBody = "<table rules='all' style='border-color: #fff; width: 100%' cellpadding=2>"
        //        messageBody += "<tr><td class=class1 style='background: #fff;'><strong>Bag Tag #</strong></td><td style='background: #fff;'><strong>Trailer #</strong></td><td style='background: #fff;'><strong>WH BOL #</strong></td><td style='background: #fff;'><strong>Bag Weight</strong></td></tr>"
        //        for (var i = 0; i<bagArray.count; i++) {
        //            messageBody += "<tr><td style='width:25%;'>" + bagArray[i] + "</td><td style='width:25%;'>" + trailerArray[i] + "</td><td style='width:25%;'>" + whbolArray[i] + "</td><td style='width:25%;'>" + bagweightArray[i] + "</td></tr>"
        //        }
        //        messageBody += "</table>"
        
        var messageBody = ""
        
        let toRecipients = ["jasonneutron@yahoo.com"]
        
        // Initialize the mail composer and populate the mail content
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self;
        mailComposer.setSubject(emailTitle)
        mailComposer.setMessageBody(messageBody, isHTML: true)
        mailComposer.setToRecipients(toRecipients)
        
        // Determine the MIME type
        var mimeType = "application/pdf"
        
        // 1. Create a print formatter
        var messageBody2 =  "<table width=100% rules='all' style='border-color: #000; font: 12pt Arial;' border=1 cellpadding=0>"
        
        
        messageBody2 += "<tr><td width=60% style='background: #fff;'>"
        messageBody2 += "<strong>Date: </strong>" + producerTextField.text //dateTextField
        messageBody2 += "</td><td width=40% style='background: #fff;'>"
        messageBody2 += "<strong>Soil Temp: </strong>" + producerTextField.text + "</td></tr>" //soilTempTextField
        messageBody2 += "<tr><td width=60% style='background: #fff;'>"
        messageBody2 += "<strong>Planter Operator: </strong>" + producerTextField.text + "</td><td width=40% style='background: #fff;'><strong>" //plantOperatorTextField
        messageBody2 += "Planter #: </strong>" + producerTextField.text + "</td></tr>"
        messageBody2 += "</table><br>" //planterNumberTextField
        
        
        messageBody2 += "<table width=100% rules='all' style='border: #000 0px 0px 1px 0px; font: 12pt Arial;' cellpadding=0>"
        messageBody2 += "<tr><td width=60% style='background: #fff;'>"
        messageBody2 += "Producer Name: " + producerTextField.text + "</td><td width=20% style='background: #fff;'>" //producerNameTextField
        messageBody2 += "Farm: " + farmNumberTextField.text + "</td><td width=20% style='background: #fff;'>"
        messageBody2 += "Tract: " + tractNumberTextField.text + "</td></tr>"
        messageBody2 += "</table><br>"
        
        
        messageBody2 += "<table width=100% rules='all' style='border-color: #000; font: 10pt Lucida Grande;' border=1 cellpadding=0>"
        messageBody2 += "<tr><td width=10% style='background: #fff;'><strong>Bag Tag #</strong></td><td width=10% style='background: #fff;'><strong>Trailer #</strong></td><td width=10% style='background: #fff;'><strong>WH BOL #</strong></td><td width=10% style='background: #fff;'><strong>Bag Weight</strong></td><td width=20% style='background: #fff;'><strong>Total # of acres planted today</strong></td><td width=20% style='background: #fff;'><strong>Total #s Today</strong></td><td width=20% style='background: #fff;'><strong>Notes</strong></td></tr>"
        
        messageBody2 += "<tr><td style='background: #fff;'>" + weightArray[0] + "</td><td style='background: #fff;'>" + weightArray[0] + "</td><td style='background: #fff;'>" + weightArray[0] + "</td><td style='background: #fff;'>" + weightArray[0] + "</td><td rowspan="
        
        var n = self.weightArray.count
        var x = producerTextField.text //totalNumbersTextField
        var y = producerTextField.text //totalAcresTextField
        messageBody2 += String(n) + " style='background: #fff;'>"
        messageBody2 += y + "</td><td rowspan="
        messageBody2 += String(n) + " style='background: #fff;'>"
        messageBody2 += x + "</td><td rowspan="
        messageBody2 += String(n) + " style='background: #fff;'>Notes</td></tr>"
        
        //        messageBody2 += "<tr><td style='background: #fff;'>112341</td><td style='background: #fff;'><strong>223422</strong></td><td style='background: #fff;'>323433</td><td style='background: #fff;'>423444</td></tr>"
        
        for (var i = 1; i<weightArray.count; i++) {
            messageBody2 += "<tr><td>" + weightArray[i] + "</td><td>" + weightArray[i] + "</td><td>" + weightArray[i] + "</td><td>" + weightArray[i] + "</td></tr>"
        }
        
        //        messageBody2 += "<tr><td style='background: #fff;'>" + totalAcresTextField.text + "/td><td style='background: #fff;'><strong>" + totalNumbersTextField.text + "</strong></td><td style='background: #fff;'></td><td style='background: #fff;'>423444</td></tr>"
        
        messageBody2 += "</table>"
        //
        //        let fmt = UIMarkupTextPrintFormatter(markupText: messageBody2)
        //
        //        // 2. Assign print formatter to UIPrintPageRenderer
        //        let render = UIPrintPageRenderer()
        //        render.addPrintFormatter(fmt, startingAtPageAtIndex: 0)
        //
        //        // 3. Assign paperRect and printableRect
        //        let page = CGRect(x: 0, y: 0, width: 612, height: 792)
        //        let printable = CGRectInset(page, 0, 0)
        //        render.setValue(NSValue(CGRect: page), forKey: "paperRect")
        //        render.setValue(NSValue(CGRect: printable), forKey: "printableRect")
        //
        //        // 4. Create PDF context and draw
        //        let pdfData = NSMutableData()
        //        UIGraphicsBeginPDFContextToData(pdfData, CGRectZero, nil)
        //
        //        for i in 1...render.numberOfPages() {
        //            UIGraphicsBeginPDFPage();
        //            let bounds = UIGraphicsGetPDFContextBounds()
        //            render.drawPageAtIndex(i - 1, inRect: bounds)
        //        }
        //
        //        UIGraphicsEndPDFContext();
        //
        //        mailComposer.addAttachmentData(pdfData, mimeType: mimeType, fileName: "DailyPlantingReport.pdf")
        mailComposer.setMessageBody(messageBody2, isHTML: true)
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showCanePopover" {
            let ppc:CanePopoverController = segue.destinationViewController as! CanePopoverController
            ppc.delegate = self
            ppc.sentWeight = previousWeight
            ppc.sentPercent = previousPercent
        }
    }
    
    func returnCaneData(weight: String, percent: String) {
        addRow(weight, newPercent: percent)
        dismissViewControllerAnimated(false, completion: nil)
    }
    
    func addLabel(x:CGFloat, width:CGFloat, text:String) {
        var label = UILabel(frame: CGRectMake(x, rowLocation, width, rowHeight))
        label.layer.borderWidth = 1
        label.text = text
        label.textAlignment = .Center
        caneView.addSubview(label)
    }
    
    func addRow(newWeight:String, newPercent:String) {
        rowLocation += offset
        
        //addButton.frame.origin.y += offset
        buttonFromTop.constant += offset
        
        addLabel(16, width: 185, text: newWeight)
        addLabel(200, width: 185, text: newPercent)
        
        weightArray.append(newWeight)
        percentArray.append(newPercent)
        
        previousWeight = newWeight
        previousPercent = newPercent
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        producerTextField.text = farmer
        farmNumberTextField.text = farmNo
        tractNumberTextField.text = tractNo
    }
}
