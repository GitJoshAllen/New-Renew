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
        let alertController = UIAlertController(title: "Close?", message: "All text will be lost.", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Yes", style: .Default, handler: {
            (action: UIAlertAction!) in
            self.dismissViewControllerAnimated(false, completion: nil)
        }))
        alertController.addAction(UIAlertAction(title: "No", style: .Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    var dataColumn:Int = 0
    var dataRow:Int = 0
    
    var numberOfItems = 0
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        producerTextField.text = farmer
        farmNumberTextField.text = farmNo
        tractNumberTextField.text = tractNo
        countyTextField.text = county
    }
    
    var farmer:String?
    var entity:String?
    var location:String?
    var acres:String?
    var farmNo:String?
    var tractNo:String?
    var county:String?
    
    var weightArray:[String] = []
    var percentArray:[String] = []
    
    var columnLocation:CGFloat = 0.0
    var rowLocation:CGFloat = 361.0
    var rowHeight:CGFloat = 50.0
    var offset:CGFloat = 49.0
    
    var previousWeight:String = ""
    var previousPercent:String = ""
    
    @IBAction func sendEmail(sender: UIButton) {
        if !MFMailComposeViewController.canSendMail() {
            return
        }
        
        var emailTitle = "Cane Harvest Report"
        
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
        messageBody2 += "<tr><td height=65 width=232></td><td align=center valign=middle>Cane Harvest Report</td></tr>"
        messageBody2 += "</table><br>"
        
        messageBody2 += "<table width=100% rules='all' style='border-color: #000; font: 10pt Arial;' border=1 cellpadding=3>"
        messageBody2 += "<tr><td valign=middle width=15% style='background: #fff;' align=center><strong>Producer Name:</strong></td><td valign=middle width=85% style='background: #fff;' colspan=10>" + producerTextField.text + "</td></tr>"
        messageBody2 += "<tr><td valign=middle width=15% style='background: #fff;' align=center><strong>County:</strong></td><td valign=middle width=85% style='background: #fff;' colspan=10>" + countyTextField.text + "</td></tr>"
        messageBody2 += "<tr><td valign=middle width=15% style='background: #fff;' align=center><strong>Farm #:</strong></td><td valign=middle width=85% style='background: #fff;' colspan=10>" + farmNumberTextField.text + "</td></tr>"
        messageBody2 += "<tr><td valign=middle width=15% style='background: #fff;' align=center><strong>Tract #:</strong></td><td valign=middle width=85% style='background: #fff;' colspan=10>" + tractNumberTextField.text + "</td></tr>"
        messageBody2 += "<tr><td valign=middle width=15% style='background: #fff;' align=center><strong>Acres Harvested:</strong></td><td valign=middle width=85% style='background: #fff;' colspan=10>" + acresHarvestedTextField.text + "</td></tr>"
        messageBody2 += "<tr><td valign=middle width=15% style='background: #fff;' align=center><strong>Harvest Date:</strong></td><td valign=middle width=85% style='background: #fff;' colspan=10>" + harvestDateTextField.text + "</td></tr>"
        messageBody2 += "<tr><td valign=middle width=15% style='background: #fff;' align=center><strong>Number of Bales:</strong></td><td valign=middle width=85% style='background: #fff;' colspan=10>" + numberOfBalesTextField.text + "</td></tr>"
        
        messageBody2 += "<tr><td valign=middle width=15% style='background: #fff;' align=center><strong>Total Tons:</strong></td><td valign=middle width=35% style='background: #fff;' colspan=4>" + totalTonsTextField.text + "</td>"
        messageBody2 += "<td valign=middle width=15% style='background: #fff;' align=center colspan=2><strong>Average Tons/Acre:</strong></td><td valign=middle width=35% style='background: #fff;' colspan=4>" + averageTonsTextField.text + "</td></tr>"
        messageBody2 += "<tr><td valign=middle width=15% style='background: #fff;' align=center><strong>Bale Type:</strong></td><td valign=middle width=35% style='background: #fff;' colspan=4>" + baleTypeTextField.text + "</td>"
        messageBody2 += "<td valign=middle width=15% style='background: #fff;' align=center colspan=2><strong>Number of Bales Sampled:</strong></td><td valign=middle width=35% style='background: #fff;' colspan=4>" + numberSampledTextField.text + "</td></tr>"
        
        var quotient = Int(ceil(Double(weightArray.count) / 5.0)) + 1
        messageBody2 += "<tr><td rowspan=" + String(quotient) + " align=center width=15% valign=middle style='background: #fff;'><strong>Sample Bale Readings:</strong></td>"
        
        messageBody2 += "<td align=center valign=middle width=12% style='background: #fff;'><strong>Weight</strong></td><td align=center valign=middle width=5% style='background: #fff;'><strong>%</strong></td><td align=center valign=middle width=12% style='background: #fff;'><strong>Weight</strong></td><td align=center valign=middle width=5% style='background: #fff;'><strong>%</strong></td><td align=center valign=middle width=12% style='background: #fff;'><strong>Weight</strong></td><td align=center valign=middle width=5% style='background: #fff;'><strong>%</strong></td><td align=center valign=middle width=12% style='background: #fff;'><strong>Weight</strong></td><td align=center valign=middle width=5% style='background: #fff;'><strong>%</strong></td><td align=center valign=middle width=12% style='background: #fff;'><strong>Weight</strong></td><td align=center valign=middle width=5% style='background: #fff;'><strong>%</strong></td></tr>"
        
        var remainder = 5 - (weightArray.count % 5)
        if weightArray.count > 0 {
            for index in 1...weightArray.count {
                if index % 5 == 1 {
                    messageBody2 += "<tr>"
                }
                messageBody2 += "<td align=center valign=middle width=12% style='background: #fff;'>1000</td><td align=center valign=middle width=5% style='background: #fff;'>5</td>"
                if index % 5 == 0 {
                    messageBody2 += "</tr>"
                }
            }
            if remainder != 5 {
                for index in 1...remainder {
                    messageBody2 += "<td align=center valign=middle width=12% style='background: #fff;'></td><td align=center valign=middle width=5% style='background: #fff;'></td>"
                }
            }
            if weightArray.count % 5 != 0 {
                messageBody2 += "</tr>"
            }
        }
        
        messageBody2 += "<tr><td valign=middle width=15% style='background: #fff;' align=center><strong>Average Bale Weight:</strong></td><td valign=middle width=85% style='background: #fff;' colspan=10>" + averageWeightTextField.text + "</td></tr>"
        messageBody2 += "<tr><td valign=middle width=15% style='background: #fff;' align=center><strong>Average Moisture:</strong></td><td valign=middle width=85% style='background: #fff;' colspan=10>" + averageMoistureTextField.text + "</td></tr>"
        messageBody2 += "<tr><td valign=middle width=15% style='background: #fff;' align=center><strong>Notes:</strong></td><td valign=top width=85% style='background: #fff;' colspan=10>" + "Notes" + "</td></tr>"
        
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
        
        mailComposer.addAttachmentData(pdfData, mimeType: mimeType, fileName: "CaneHarvestReport.pdf")
        
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
        if dataColumn == 0 && dataRow == 0 {
            rowLocation += offset
            //buttonFromTop.constant += offset
        }
        
        addLabel(CGFloat(16) + columnLocation, width: 93, text: newWeight)
        addLabel(CGFloat(92 + 16) + columnLocation, width: 93, text: newPercent)
        
        dataColumn += 1
        columnLocation += 184
        
        if dataColumn == 1 {
            buttonFromTop.constant += offset
        }
        
        if dataColumn > 3 {
            dataColumn = 0
            dataRow++
            
            rowLocation += offset
            //buttonFromTop.constant += offset
            columnLocation = 0.0
        }
        
        weightArray.append(newWeight)
        percentArray.append(newPercent)
        
        previousWeight = newWeight
        previousPercent = newPercent
        
        numberOfItems++
        
        if numberOfItems >= 40 {
            addButton.enabled = false
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
}
