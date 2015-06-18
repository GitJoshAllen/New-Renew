//
//  PlantingViewController.swift
//  RenewBiomass
//
//  Created by Jason Carothers on 2/23/15.
//

import UIKit
import MessageUI

class PlantingViewController: UIViewController, UIPopoverPresentationControllerDelegate, SendDataFromPopoverDelegate, MFMailComposeViewControllerDelegate {
    
    @IBAction func cancel(sender: UIButton) {
        let alertController = UIAlertController(title: "Cancel?", message: "All text will be lost.", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Yes", style: .Default, handler: {
            (action: UIAlertAction!) in
                self.dismissViewControllerAnimated(false, completion: nil)
        }))
        alertController.addAction(UIAlertAction(title: "No", style: .Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBOutlet var addButton:UIButton!
    @IBOutlet var plantingView: UIView!
    @IBOutlet weak var buttonFromTop: NSLayoutConstraint!
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var plantOperatorTextField: UITextField!
    @IBOutlet weak var planterNumberTextField: UITextField!
    @IBOutlet weak var producerNameTextField: UITextField!
    @IBOutlet weak var farmNumberTextField: UITextField!
    @IBOutlet weak var tractNumberTextField: UITextField!
    @IBOutlet weak var totalAcresTextField: UITextField!
    @IBOutlet weak var totalNumbersTextField: UITextField!
    @IBOutlet weak var soilTempTextField: UITextField!
    
    var farmer:String?
    var entity:String?
    var location:String?
    var acres:String?
    var farmNo:String?
    var tractNo:String?
    
    var bagArray:[String] = []
    var trailerArray:[String] = []
    var whbolArray:[String] = []
    var bagweightArray:[String] = []
    
    var rowLocation:CGFloat = 263.0
    var rowHeight:CGFloat = 50.0
    var offset:CGFloat = 49.0
    
    var previousBag:String = ""
    var previousTrailer:String = ""
    var previousWHBOL:String = ""
    var previousBagweight:String = ""
    
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
        messageBody2 += "<strong>Date: </strong>" + dateTextField.text
        messageBody2 += "</td><td width=40% style='background: #fff;'>"
        messageBody2 += "<strong>Soil Temp: </strong>" + soilTempTextField.text + "</td></tr>"
        messageBody2 += "<tr><td width=60% style='background: #fff;'>"
        messageBody2 += "<strong>Planter Operator: </strong>" + plantOperatorTextField.text + "</td><td width=40% style='background: #fff;'><strong>"
        messageBody2 += "Planter #: </strong>" + planterNumberTextField.text + "</td></tr>"
        messageBody2 += "</table><br>"
        
        
        messageBody2 += "<table width=100% rules='all' style='border: #000 0px 0px 1px 0px; font: 12pt Arial;' cellpadding=0>"
        messageBody2 += "<tr><td width=60% style='background: #fff;'>"
        messageBody2 += "Producer Name: " + producerNameTextField.text + "</td><td width=20% style='background: #fff;'>"
        messageBody2 += "Farm: " + farmNumberTextField.text + "</td><td width=20% style='background: #fff;'>"
        messageBody2 += "Tract: " + tractNumberTextField.text + "</td></tr>"
        messageBody2 += "</table><br>"
        
        
        messageBody2 += "<table width=100% rules='all' style='border-color: #000; font: 10pt Lucida Grande;' border=1 cellpadding=0>"
        messageBody2 += "<tr><td width=10% style='background: #fff;'><strong>Bag Tag #</strong></td><td width=10% style='background: #fff;'><strong>Trailer #</strong></td><td width=10% style='background: #fff;'><strong>WH BOL #</strong></td><td width=10% style='background: #fff;'><strong>Bag Weight</strong></td><td width=20% style='background: #fff;'><strong>Total # of acres planted today</strong></td><td width=20% style='background: #fff;'><strong>Total #s Today</strong></td><td width=20% style='background: #fff;'><strong>Notes</strong></td></tr>"
        
        messageBody2 += "<tr><td style='background: #fff;'>" + bagArray[0] + "</td><td style='background: #fff;'>" + trailerArray[0] + "</td><td style='background: #fff;'>" + whbolArray[0] + "</td><td style='background: #fff;'>" + bagweightArray[0] + "</td><td rowspan="
        
        var n = self.bagArray.count
        var x = totalNumbersTextField.text
        var y = totalAcresTextField.text
        messageBody2 += String(n) + " style='background: #fff;'>"
        messageBody2 += y + "</td><td rowspan="
        messageBody2 += String(n) + " style='background: #fff;'>"
        messageBody2 += x + "</td><td rowspan="
        messageBody2 += String(n) + " style='background: #fff;'>Notes</td></tr>"
        
//        messageBody2 += "<tr><td style='background: #fff;'>112341</td><td style='background: #fff;'><strong>223422</strong></td><td style='background: #fff;'>323433</td><td style='background: #fff;'>423444</td></tr>"
        
        for (var i = 1; i<bagArray.count; i++) {
            messageBody2 += "<tr><td>" + bagArray[i] + "</td><td>" + trailerArray[i] + "</td><td>" + whbolArray[i] + "</td><td>" + bagweightArray[i] + "</td></tr>"
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
        if segue.identifier == "showPlantingPopover" {
            let ppc:PlantingPopoverController = segue.destinationViewController as! PlantingPopoverController
            ppc.delegate = self
            ppc.sentBag = previousBag
            ppc.sentTrailer = previousTrailer
            ppc.sentWhbol = previousWHBOL
            ppc.sentBagweight = previousBagweight
        }
    }
    
    func returnData(bag: String, trailer: String, whbol: String, bagweight: String) {
        addRow(bag, newTrailer: trailer, newWhbol: whbol, newBagweight: bagweight)
        dismissViewControllerAnimated(false, completion: nil)
    }
    
    func addLabel(x:CGFloat, width:CGFloat, text:String) {
        var label = UILabel(frame: CGRectMake(x, rowLocation, width, rowHeight))
        label.layer.borderWidth = 1
        label.text = text
        label.textAlignment = .Center
        plantingView.addSubview(label)
    }
    
    func addRow(newBag:String, newTrailer:String, newWhbol:String, newBagweight:String) {
        rowLocation += offset
        
        //addButton.frame.origin.y += offset
        buttonFromTop.constant += offset
        
        addLabel(16, width: 185, text: newBag)
        addLabel(200, width: 185, text: newTrailer)
        addLabel(384, width: 184, text: newWhbol)
        addLabel(567, width: 185, text: newBagweight)
        
        bagArray.append(newBag)
        trailerArray.append(newTrailer)
        whbolArray.append(newWhbol)
        bagweightArray.append(newBagweight)
        
        previousBag = newBag
        previousTrailer = newTrailer
        previousWHBOL = newWhbol
        previousBagweight = newBagweight
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        plantOperatorTextField.text = farmer
        farmNumberTextField.text = farmNo
        tractNumberTextField.text = tractNo
    }
}
