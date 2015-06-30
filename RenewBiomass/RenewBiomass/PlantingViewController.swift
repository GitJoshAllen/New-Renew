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
        let alertController = UIAlertController(title: "Close?", message: "All text will be lost.", preferredStyle: .Alert)
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
    @IBOutlet weak var soilTempTextField: UITextField!
    
    var farmer:String?
    var entity:String?
    var location:String?
    var acres:String?
    var farmNo:String?
    var tractNo:String?
    
    var bagArray:[String] = []
    var trailerArray:[String] = []
    var bolArray:[String] = []
    var bagweightArray:[String] = []
    
    var rowLocation:CGFloat = 273.0
    var rowHeight:CGFloat = 40.0
    var offset:CGFloat = 39.0
    
    var previousBag:String = ""
    var previousTrailer:String = ""
    var previousBOL:String = ""
    var previousBagweight:String = ""
    
    var numberOfRows = 0
    
    @IBAction func sendEmail(sender: UIButton) {
        if !MFMailComposeViewController.canSendMail() {
            return
        }
        
        var emailTitle = "Daily Planting Report"
        
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
        
        messageBody2 += "<table width=100% rules='all' style='border: #fff 0px; font: 15pt Arial;' border=0 cellpadding=0 cellspacing=0>"
        messageBody2 += "<tr><td height=54 width=232></td><td align=center valign=middle></td></tr>"
        messageBody2 += "<tr><td height=65 width=232></td><td align=center valign=middle>Daily Planting Report</td></tr>"
        messageBody2 += "</table><br>"
        
        messageBody2 += "<table width=100% rules='all' style='border-color: #000; font: 11pt Arial;' border=1 cellpadding=3>"
        messageBody2 += "<tr><td valign=middle width=60% style='background: #fff;' colspan=4><strong>Date: </strong>" + dateTextField.text + "</td>"
        messageBody2 += "<td valign=middle width=40% style='background: #fff;' colspan=2><strong>Soil Temp: </strong>" + soilTempTextField.text + "</td></tr>"
        messageBody2 += "<tr><td valign=middle width=60% style='background: #fff;' colspan=4><strong>Planter Operator: </strong>" + plantOperatorTextField.text + "</td>"
        messageBody2 += "<td valign=middle width=40% style='background: #fff;' colspan=2><strong>Planter #: </strong>" + planterNumberTextField.text + "</td></tr>"
        messageBody2 += "<tr><td valign=middle width=60% style='background: #fff;' colspan=4><strong>Producer Name: </strong>" + producerNameTextField.text + "</td>"
        messageBody2 += "<td valign=middle width=20% style='background: #fff;'>Farm: " + farmNumberTextField.text + "</td><td valign=middle width=20% style='background: #fff;'>Tract: " + tractNumberTextField.text + "</td></tr>"
        
        messageBody2 += "<tr><td align=center valign=middle width=15% style='background: #fff;'><strong>Bag Tag #</strong></td><td align=center valign=middle width=15% style='background: #fff;'><strong>Trailer #</strong></td><td align=center valign=middle width=15% style='background: #fff;'><strong>BOL #</strong></td><td align=center valign=middle width=15% style='background: #fff;'><strong>Bag Weight</strong></td><td align=center valign=middle width=20% style='background: #fff;'><strong>Total # of acres planted today</strong></td><td align=center valign=middle width=20% style='background: #fff;'><strong>Notes</strong></td></tr>"
        
        messageBody2 += "<tr><td align=center valign=middle style='background: #fff;'>" + bagArray[0] + "</td><td align=center valign=middle style='background: #fff;'>" + trailerArray[0] + "</td><td align=center valign=middle style='background: #fff;'>" + bolArray[0] + "</td><td align=center valign=middle style='background: #fff;'>" + bagweightArray[0] + "</td><td rowspan="
        
        var n = self.bagArray.count
        var y = totalAcresTextField.text
        messageBody2 += String(n) + " align=center valign=middle style='background: #fff;'>"
        messageBody2 += y + "</td><td rowspan="
        messageBody2 += String(n) + " valign=top style='background: #fff;'>Notes</td></tr>"
        
        for (var i = 1; i<bagArray.count; i++) {
            messageBody2 += "<tr><td align=center valign=middle>" + bagArray[i] + "</td><td align=center valign=middle>" + trailerArray[i] + "</td><td align=center valign=middle>" + bolArray[i] + "</td><td align=center valign=middle>" + bagweightArray[i] + "</td></tr>"
        }
        
        messageBody2 += "</table>"
        
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
        let rect = CGRectMake(16.0, 40.0, 216.0, 64.65)
        
        //for i in 1...render.numberOfPages() {
            UIGraphicsBeginPDFPageWithInfo(page, nil)
            let bounds = UIGraphicsGetPDFContextBounds()
            render.drawPageAtIndex(0, inRect: bounds)
            myImage?.drawInRect(rect)
        //}
        UIGraphicsEndPDFContext();
        
        mailComposer.addAttachmentData(pdfData, mimeType: mimeType, fileName: "DailyPlantingReport.pdf")
        
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
        if segue.identifier == "showPlantingPopover" {
            let ppc:PlantingPopoverController = segue.destinationViewController as! PlantingPopoverController
            ppc.delegate = self
            ppc.sentBag = previousBag
            ppc.sentTrailer = previousTrailer
            ppc.sentBol = previousBOL
            ppc.sentBagweight = previousBagweight
        }
    }
    
    func returnData(bag: String, trailer: String, bol: String, bagweight: String) {
        addRow(bag, newTrailer: trailer, newBol: bol, newBagweight: bagweight)
        dismissViewControllerAnimated(false, completion: nil)
    }
    
    func addLabel(x:CGFloat, width:CGFloat, text:String) {
        var label = UILabel(frame: CGRectMake(x, rowLocation, width, rowHeight))
        label.layer.borderWidth = 1
        label.text = text
        label.textAlignment = .Center
        plantingView.addSubview(label)
    }
    
    func addRow(newBag:String, newTrailer:String, newBol:String, newBagweight:String) {
        rowLocation += offset
        
        //addButton.frame.origin.y += offset
        buttonFromTop.constant += offset
        
        addLabel(16, width: 185, text: newBag)
        addLabel(200, width: 185, text: newTrailer)
        addLabel(384, width: 184, text: newBol)
        addLabel(567, width: 185, text: newBagweight)
        
        bagArray.append(newBag)
        trailerArray.append(newTrailer)
        bolArray.append(newBol)
        bagweightArray.append(newBagweight)
        
        previousBag = newBag
        previousTrailer = newTrailer
        previousBOL = newBol
        previousBagweight = newBagweight
        
        numberOfRows++
        
        if numberOfRows >= 15 {
            addButton.enabled = false
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        producerNameTextField.text = farmer
        farmNumberTextField.text = farmNo
        tractNumberTextField.text = tractNo
    }
}
