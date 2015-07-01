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
    
    //added 1.3
    var contactNo:String?
    var email:String?
    //end 1.3
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet var scoutingView: UIView!
    
    var notes = ""
    
    func resignAll() {
        self.producerText.resignFirstResponder()
        self.countyText.resignFirstResponder()
        self.farmNoText.resignFirstResponder()
        self.tractNoText.resignFirstResponder()
        self.acresText.resignFirstResponder()
        self.assessorText.resignFirstResponder()
        self.dateText.resignFirstResponder()
    }
    
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
        resignAll()
        
        if let controller = self.tabBarController?.viewControllers![2] as? NotesViewController {
            if let myNotes = controller.textView?.text {
                notes = myNotes
            }
        }
        
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
        
        messageBody2 += "<table width=100% rules='all' style='border: #fff 0px; font: 15pt Arial;' border=0 cellpadding=0 cellspacing=0>"
        messageBody2 += "<tr><td height=54 width=232></td><td align=center valign=middle></td></tr>"
        messageBody2 += "<tr><td height=65 width=232></td><td align=center valign=middle>Field Assessment</td></tr>"
        messageBody2 += "</table><br>"
        
        messageBody2 += "<table width=100% rules='all' style='border-color: #000; font: 11pt Arial;' border=1 cellpadding=3>"
        messageBody2 += "<tr><td valign=middle width=60% style='background: #fff;' colspan=2><strong>Producer Name: </strong>" + producerText.text + "</td>"
        messageBody2 += "<td valign=middle width=40% style='background: #fff;'><strong>County: </strong>" + countyText.text + "</td></tr>"
        messageBody2 += "<tr><td valign=middle width=30% style='background: #fff;'><strong>Farm Number: </strong>" + farmNoText.text + "</td>"
        messageBody2 += "<td valign=middle width=30% style='background: #fff;'><strong>Tract Number: </strong>" + tractNoText.text + "</td>"
        messageBody2 += "<td valign=middle width=40% style='background: #fff;'><strong>Acres: </strong>" + acresText.text + "</td></tr>"
        messageBody2 += "</table><br>"
        
        messageBody2 += "<center><font style='font: 9pt Arial;'><strong>Population Count:</strong></font></center>"
        
        messageBody2 += "<table width=100% rules='all' style='border-color: #000; font: 9pt Arial;' border=1 cellpadding=3>"
        messageBody2 += "<tr><td align=center valign=middle width=11% style='background: #fff;'><strong>Sample</strong></td>"
        for index in 1...12 {
            messageBody2 += "<td align=center valign=middle width=6.5% style='background: #fff;'><strong>\(index)</strong></td>"
        }
        messageBody2 += "<td align=center valign=middle width=11% style='background: #fff;'><strong>Average</strong></td></tr>"
        
        var remainder = 12 - numberOfColumns
        if numberOfColumns > 0 {
            messageBody2 += "<tr><td align=center valign=middle width=11% style='background: #fff;'><strong>Plants</strong></td>"
            for index in 0...numberOfColumns - 1 {
                messageBody2 += "<td align=center valign=middle width=6.5% style='background: #fff;'>" + plantsArray[index] + "</td>"
            }
            for index in 1...remainder {
                messageBody2 += "<td align=center valign=middle width=6.5% style='background: #fff;'></td>"
            }
            messageBody2 += "<td align=center valign=middle width=11% style='background: #fff;'><strong>" + String(stringInterpolationSegment: Double(round(averageOfPlants*100)/100)) + "</strong></td>"
            messageBody2 += "</tr>"
            messageBody2 += "<tr><td align=center valign=middle width=11% style='background: #fff;'><strong>Tillers</strong></td>"
            for index in 0...numberOfColumns - 1 {
                messageBody2 += "<td align=center valign=middle width=6.5% style='background: #fff;'>" + plantsArray[index] + "</td>"
            }
            for index in 1...remainder {
                messageBody2 += "<td align=center valign=middle width=6.5% style='background: #fff;'></td>"
            }
            messageBody2 += "<td align=center valign=middle width=11% style='background: #fff;'><strong>" + String(stringInterpolationSegment: Double(round(averageOfTillers*100)/100)) + "</strong></td>"
            messageBody2 += "</tr>"
            messageBody2 += "<tr><td align=center valign=middle width=11% style='background: #fff;'><strong>Height</strong></td>"
            for index in 0...numberOfColumns - 1 {
                messageBody2 += "<td align=center valign=middle width=6.5% style='background: #fff;'>" + plantsArray[index] + "</td>"
            }
            for index in 1...remainder {
                messageBody2 += "<td align=center valign=middle width=6.5% style='background: #fff;'></td>"
            }
            messageBody2 += "<td align=center valign=middle width=11% style='background: #fff;'><strong>" + String(stringInterpolationSegment: Double(round(averageOfHeight*100)/100)) + "</strong></td>"
            messageBody2 += "</tr>"
        }
        messageBody2 += "</table><br>"
        
        messageBody2 += "<table width=100% rules='all' style='border-color: #000; font: 11pt Arial;' border=1 cellpadding=3>"
        messageBody2 += "<tr><td valign=middle align=center width=15% style='background: #fff;'><strong>Notes:</strong></td>"
        messageBody2 += "<td valign=top width=85% style='background: #fff;'>" + notes + "</td></tr>"
        messageBody2 += "</table>"
        
        messageBody2 += "<table width=100% rules='all' style='border-color: #000; font: 11pt Arial;' border=1 cellpadding=3>"
        messageBody2 += "<tr><td valign=middle width=60% style='background: #fff;'><strong>Assessor: </strong>" + assessorText.text + "</td>"
        messageBody2 += "<td valign=middle width=40% style='background: #fff;'><strong>Date: </strong>" + dateText.text + "</td></tr>"
        messageBody2 += "</table>"
        
//        messageBody2 += "<table width=100% rules='all' style='border-color: #000; font: 11pt Arial;' border=1 cellpadding=3>"
//        messageBody2 += "<tr><td align=center valign=middle width=15% style='background: #fff;'><strong>Bag Tag #</strong></td><td align=center valign=middle width=15% style='background: #fff;'><strong>Trailer #</strong></td><td align=center valign=middle width=15% style='background: #fff;'><strong>BOL #</strong></td><td align=center valign=middle width=15% style='background: #fff;'><strong>Bag Weight</strong></td><td align=center valign=middle width=20% style='background: #fff;'><strong>Total # of acres planted today</strong></td><td align=center valign=middle width=20% style='background: #fff;'><strong>Notes</strong></td></tr>"
//        
//        messageBody2 += "<tr><td align=center valign=middle style='background: #fff;'>" + bagArray[0] + "</td><td align=center valign=middle style='background: #fff;'>" + trailerArray[0] + "</td><td align=center valign=middle style='background: #fff;'>" + bolArray[0] + "</td><td align=center valign=middle style='background: #fff;'>" + bagweightArray[0] + "</td><td rowspan="
//        
//        var n = self.bagArray.count
//        var y = totalAcresTextField.text
//        messageBody2 += String(n) + " align=center valign=middle style='background: #fff;'>"
//        messageBody2 += y + "</td><td rowspan="
//        messageBody2 += String(n) + " valign=top style='background: #fff;'>Notes</td></tr>"
//        
//        for (var i = 1; i<bagArray.count; i++) {
//            messageBody2 += "<tr><td align=center valign=middle>" + bagArray[i] + "</td><td align=center valign=middle>" + trailerArray[i] + "</td><td align=center valign=middle>" + bolArray[i] + "</td><td align=center valign=middle>" + bagweightArray[i] + "</td></tr>"
//        }
//        
//        messageBody2 += "</table>"
        
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
        resignAll()
        
        if segue.identifier == "showScoutingPopover" {
            let ppc:ScoutingPopoverController = segue.destinationViewController as! ScoutingPopoverController
            ppc.delegate = self
            ppc.sentPlants = previousPlants
            ppc.sentTillers = previousTillers
            ppc.sentHeight = previousHeight
        }
    }
    
    @IBAction func cancel(sender: UIButton) {
        resignAll()
        
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
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "dismissKeyboard"))
        
        var datePicker:UIDatePicker = UIDatePicker()
        datePicker.datePickerMode = .Date
        datePicker.backgroundColor = .whiteColor()
        self.dateText.inputView = datePicker
        datePicker.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: .ValueChanged)
    }
    
    func handleDatePicker(sender: UIDatePicker) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateText.text = dateFormatter.stringFromDate(sender.date)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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
