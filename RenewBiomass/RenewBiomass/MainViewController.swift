//
//  ViewController.swift
//  RenewBiomass
//
//  Created by Jason Carothers on 2/10/15.
//

import UIKit
import CloudKit
import CoreData

class MainViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    var overlayView = UIView(frame: UIScreen.mainScreen().bounds)
    var spinner:UIActivityIndicatorView = UIActivityIndicatorView()
    var farmers:[CKRecord] = []
    let defaults = NSUserDefaults.standardUserDefaults()
    var farmer:Farmer!
    var fetchedResultsController:NSFetchedResultsController!
    
    var firstNameStrings:[String] = []
    var lastNameStrings:[String] = []
    var addressStrings:[String] = []
    var cityStrings:[String] = []
    var stateStrings:[String] = []
    var zipCodeStrings:[String] = []
    var tractNoStrings:[String] = []
    
    //these were added 1.3
    var farmNoStrings:[String] = []
    var countyStrings:[String] = []
    var acresStrings:[String] = []
    var phoneNumberStrings:[String] = []
    var emailStrings:[String] = []
    var contactNoStrings:[String] = []
    //end 1.3
    
    var farmerRow:Int!
    var entityRow:Int!
    var locationRow:Int!
    var acresRow:Int!
    var tractRow:Int!
    
    var farmerPickerStrings:[String]!
    var farmerPicker:UIPickerView = UIPickerView()
    
    var entityPickerStrings:[String]!
    var entityPicker:UIPickerView = UIPickerView()
    
    var locationPickerStrings:[String]!
    var locationPicker:UIPickerView = UIPickerView()
    
    var acresPickerStrings:[String]!
    var acresPicker:UIPickerView = UIPickerView()
    
    @IBOutlet weak var rhizome: UIButton!
    @IBOutlet weak var scouting: UIButton!
    @IBOutlet weak var planting: UIButton!
    @IBOutlet weak var cane: UIButton!
    
    @IBOutlet weak var farmerText:UITextField!
    @IBOutlet weak var entityText:UITextField!
    @IBOutlet weak var locationText:UITextField!
    @IBOutlet weak var acresText:UITextField!
    
    var lineArray:[String]!
    
    func saveToCoreData() {
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext {
            
            for each in 1...lineArray.count - 1 {
                if each != 0 {
                    var columnArray:[String] = lineArray[each].componentsSeparatedByString(",")
            
                    farmer = NSEntityDescription.insertNewObjectForEntityForName("Farmer", inManagedObjectContext: managedObjectContext) as! Farmer
                    farmer.firstName = columnArray[0]
                    farmer.lastName = columnArray[1]
                    farmer.address = columnArray[2]
                    farmer.city = columnArray[3]
                    farmer.state = columnArray[4]
                    farmer.zipCode = columnArray[5].toInt()
                    farmer.phoneNumber = columnArray[6]
                    farmer.email = columnArray[7]
                    farmer.farmNo = columnArray[8].toInt()
                    farmer.tractNo = columnArray[9].toInt()
                    farmer.county = columnArray[10]
                    farmer.acres = (columnArray[11] as NSString).doubleValue
                    farmer.contactNumber = columnArray[12].toInt()
                    var error:NSError?
                    if managedObjectContext.save(&error) != true {
                        println("insert error: \(error!.localizedDescription)")
                        return
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let upload: AnyObject = defaults.objectForKey("uploadedToCloudKit") {
            // Already inserted into CoreData
        } else {
            if let file = NSBundle.mainBundle().pathForResource("farmers3", ofType: "csv") {
                var error:NSError?
                var content = String(contentsOfFile: file, encoding: NSUTF8StringEncoding, error: &error)
                lineArray = content!.componentsSeparatedByString("\r\n")
                saveToCoreData()
            }
            defaults.setObject("UPLOADED", forKey: "uploadedToCloudKit")
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        reloadData()
    }
    
    func reloadData() {
        self.farmerText.enabled = false
        self.farmerText.text = ""
        self.entityText.enabled = false
        self.entityText.text = ""
        self.locationText.enabled = false
        self.locationText.text = ""
        self.acresText.enabled = false
        self.acresText.text = ""
        
        self.overlayView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        spinner.activityIndicatorViewStyle = .WhiteLarge
        spinner.center = self.overlayView.center
        spinner.hidesWhenStopped = true
        self.overlayView.addSubview(spinner)
        self.spinner.startAnimating()
        self.view.addSubview(self.overlayView)
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "dismissKeyboard"))
        
        setUpPickerViews()
        
//        if let date = defaults.objectForKey("cloudKitDate") as? NSDate {
//            
//        } else {
//            let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)
//            let components = NSDateComponents()
//            components.year = 2015
//            components.month = 6
//            components.day = 1 //midnight on 06/01/2015
//            var newDate = calendar!.dateFromComponents(components)
//            defaults.setObject(newDate, forKey: "cloudKitDate")
//        }
//        self.getRecordsFromCloud()
//        defaults.setObject(NSDate(), forKey: "cloudKitDate")
        
        self.spinner.stopAnimating()
        self.overlayView.removeFromSuperview()
        self.loadDataInFarmerPicker()
    }
    
    func setUpPickerViews() {
        self.farmerText.enabled = false
        self.entityText.enabled = false
        self.locationText.enabled = false
        self.acresText.enabled = false
        
        self.rhizome.enabled = false
        self.scouting.enabled = false
        self.planting.enabled = false
        self.cane.enabled = false
        
        self.farmerText.delegate = self
        self.entityText.delegate = self
        self.locationText.delegate = self
        self.acresText.delegate = self
        
        farmerPickerStrings = [""]
        entityPickerStrings = [""]
        locationPickerStrings = [""]
        acresPickerStrings = [""]
        
        farmerPicker.tag = 0
        farmerPicker.delegate = self
        farmerPicker.dataSource = self
        farmerPicker.backgroundColor = .whiteColor()
        self.farmerText.inputView = farmerPicker
        
        entityPicker.tag = 1
        entityPicker.delegate = self
        entityPicker.dataSource = self
        entityPicker.backgroundColor = .whiteColor()
        self.entityText.inputView = entityPicker
        
        locationPicker.tag = 2
        locationPicker.delegate = self
        locationPicker.dataSource = self
        locationPicker.backgroundColor = .whiteColor()
        self.locationText.inputView = locationPicker
        
        acresPicker.tag = 3
        acresPicker.delegate = self
        acresPicker.dataSource = self
        acresPicker.backgroundColor = .whiteColor()
        self.acresText.inputView = acresPicker
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return self.farmerPickerStrings.count
        } else if pickerView.tag == 1 {
            return self.entityPickerStrings.count
        } else if pickerView.tag == 2 {
            return self.locationPickerStrings.count
        } else if pickerView.tag == 3 {
            return self.acresPickerStrings.count
        } else {
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if pickerView.tag == 0 {
            return farmerPickerStrings[row]
        } else if pickerView.tag == 1 {
            return entityPickerStrings[row]
        } else if pickerView.tag == 2 {
            return locationPickerStrings[row]
        } else if pickerView.tag == 3 {
            return acresPickerStrings[row]
        } else {
            return ""
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row != 0 {
            if pickerView.tag == 0 {
                
                self.farmerText.resignFirstResponder()
                farmerText.text = farmerPickerStrings[row]
                farmerRow = row
                self.entityText.enabled = false
                self.entityText.text = ""
                self.locationText.enabled = false
                self.locationText.text = ""
                self.acresText.enabled = false
                self.acresText.text = ""
                
                self.addressStrings = []
                self.cityStrings = []
                self.stateStrings = []
                self.zipCodeStrings = []
                self.tractNoStrings = []
                
                loadDataInEntityPicker(firstNameStrings[farmerRow - 1], lastName: lastNameStrings[farmerRow - 1])
            } else if pickerView.tag == 1 {
                self.entityText.resignFirstResponder()
                entityText.text = entityPickerStrings[row]
                entityRow = row
                
                self.locationText.enabled = false
                self.locationText.text = ""
                self.acresText.enabled = false
                self.acresText.text = ""
                
                self.addressStrings = []
                self.cityStrings = []
                self.stateStrings = []
                self.zipCodeStrings = []
                self.tractNoStrings = []
                
                loadDataInLocationPicker(firstNameStrings[farmerRow - 1], lastName: lastNameStrings[farmerRow - 1], farmNo: entityPickerStrings[entityRow])
            } else if pickerView.tag == 2 {
                self.locationText.resignFirstResponder()
                locationText.text = locationPickerStrings[row]
                locationRow = row
                tractRow = row - 1
                
                self.acresText.enabled = false
                self.acresText.text = ""
                
                self.tractNoStrings = []
                
                loadDataInAcresPicker(firstNameStrings[farmerRow - 1], lastName: lastNameStrings[farmerRow - 1], farmNo: entityPickerStrings[entityRow])
            } else if pickerView.tag == 3 {
                self.acresText.resignFirstResponder()
                acresText.text = acresPickerStrings[row]
                
                self.rhizome.enabled = true
                self.scouting.enabled = true
                self.planting.enabled = true
                self.cane.enabled = true
            } else {
                // do nothing
            }
        }
    }
    
    func loadDataInFarmerPicker() {
        farmerPickerStrings = [""]
        var fetchRequest = NSFetchRequest(entityName: "Farmer")
        let sortDescriptor = NSSortDescriptor(key: "firstName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext {
            if let fetchResults = managedObjectContext.executeFetchRequest(fetchRequest, error: nil) as? [Farmer] {
                for person in fetchResults {
                    self.farmerPickerStrings.append(person.firstName + " " + person.lastName)
                    self.firstNameStrings.append(person.firstName)
                    self.lastNameStrings.append(person.lastName)
                }
            }
        }
        farmerPicker.reloadAllComponents()
        farmerPicker.selectRow(0, inComponent: 0, animated: false)
        self.farmerText.enabled = true
    }
    
    func loadDataInEntityPicker(firstName:String, lastName:String) {
        entityPickerStrings = [""]
        var fetchRequest = NSFetchRequest(entityName: "Farmer")
        let sortDescriptor = NSSortDescriptor(key: "farmNo", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let predicate1 = NSPredicate(format: "firstName = %@", firstName)
        let predicate2 = NSPredicate(format: "lastName = %@", lastName)
        var compound = NSCompoundPredicate.andPredicateWithSubpredicates([predicate1, predicate2])
        fetchRequest.predicate = compound
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext {
            if let fetchResults = managedObjectContext.executeFetchRequest(fetchRequest, error: nil) as? [Farmer] {
                for person in fetchResults {
                    self.entityPickerStrings.append(String(stringInterpolationSegment: person.farmNo))
                }
            }
        }
        entityPicker.reloadAllComponents()
        entityPicker.selectRow(0, inComponent: 0, animated: false)
        self.entityText.enabled = true
    }
    
    func loadDataInLocationPicker(firstName:String, lastName:String, farmNo:String) {
        locationPickerStrings = [""]
        var fetchRequest = NSFetchRequest(entityName: "Farmer")
        let sortDescriptor = NSSortDescriptor(key: "address", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let predicate1 = NSPredicate(format: "firstName = %@", firstName)
        let predicate2 = NSPredicate(format: "lastName = %@", lastName)
        let predicate3 = NSPredicate(format: "farmNo = %@", farmNo)
        var compound = NSCompoundPredicate.andPredicateWithSubpredicates([predicate1, predicate2, predicate3])
        fetchRequest.predicate = compound
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext {
            if let fetchResults = managedObjectContext.executeFetchRequest(fetchRequest, error: nil) as? [Farmer] {
                for person in fetchResults {
                    self.locationPickerStrings.append(person.address + ", " + person.city + ", " + person.state + " " + String(stringInterpolationSegment: person.zipCode))
                    self.addressStrings.append(person.address)
                    self.cityStrings.append(person.city)
                    self.stateStrings.append(person.state)
                    self.zipCodeStrings.append(String(stringInterpolationSegment: person.zipCode))
                    
                    //added 1.3
                    self.contactNoStrings.append(String(stringInterpolationSegment: person.contactNumber))
                    self.countyStrings.append(person.county)
                    self.emailStrings.append(person.email)
                    self.phoneNumberStrings.append(person.phoneNumber)
                    //end 1.3
                }
            }
        }
        locationPicker.reloadAllComponents()
        locationPicker.selectRow(0, inComponent: 0, animated: false)
        self.locationText.enabled = true
    }
    
    func loadDataInAcresPicker(firstName:String, lastName:String, farmNo:String) {
        acresPickerStrings = [""]
        var fetchRequest = NSFetchRequest(entityName: "Farmer")
        let sortDescriptor = NSSortDescriptor(key: "acres", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let predicate1 = NSPredicate(format: "firstName = %@", firstName)
        let predicate2 = NSPredicate(format: "lastName = %@", lastName)
        let predicate3 = NSPredicate(format: "farmNo = %@", farmNo)
        var compound = NSCompoundPredicate.andPredicateWithSubpredicates([predicate1, predicate2, predicate3])
        fetchRequest.predicate = compound
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext {
            if let fetchResults = managedObjectContext.executeFetchRequest(fetchRequest, error: nil) as? [Farmer] {
                for person in fetchResults {
                    self.acresPickerStrings.append(String(stringInterpolationSegment: person.acres))
                    self.tractNoStrings.append(String(stringInterpolationSegment: person.tractNo))
                }
            }
        }
        acresPicker.reloadAllComponents()
        acresPicker.selectRow(0, inComponent: 0, animated: false)
        self.acresText.enabled = true
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "mainViewToTabViewRhizome") {
            if let destinationController = segue.destinationViewController as? TabBarController {
                destinationController.farmer = farmerText.text
                destinationController.entity = entityText.text
                destinationController.location = locationText.text
                destinationController.acres = acresText.text
                destinationController.farmNo = entityText.text
                destinationController.tractNo = tractNoStrings[tractRow]
                destinationController.optionSelected = "Rhizome"
                
                //added 1.3
                destinationController.contactNo = contactNoStrings[tractRow]
                destinationController.county = countyStrings[tractRow]
                destinationController.email = emailStrings[tractRow]
                //end 1.3
            }
        }
        if (segue.identifier == "mainViewToTabViewScouting") {
            if let destinationController = segue.destinationViewController as? TabBarController {
                destinationController.farmer = farmerText.text
                destinationController.entity = entityText.text
                destinationController.location = locationText.text
                destinationController.acres = acresText.text
                destinationController.farmNo = entityText.text
                destinationController.tractNo = tractNoStrings[tractRow]
                destinationController.optionSelected = "Scouting"
                
                //added 1.3
                destinationController.contactNo = contactNoStrings[tractRow]
                destinationController.county = countyStrings[tractRow]
                destinationController.email = emailStrings[tractRow]
                //end 1.3
            }
        }
        if (segue.identifier == "mainViewToTabViewPlanting") {
            if let destinationController = segue.destinationViewController as? TabBarController {
                destinationController.farmer = farmerText.text
                destinationController.entity = entityText.text
                destinationController.location = locationText.text
                destinationController.acres = acresText.text
                destinationController.farmNo = entityText.text
                destinationController.tractNo = tractNoStrings[tractRow]
                destinationController.optionSelected = "Planting"
                
                //added 1.3
                destinationController.contactNo = contactNoStrings[tractRow]
                destinationController.county = countyStrings[tractRow]
                destinationController.email = emailStrings[tractRow]
                //end 1.3
            }
        }
        if (segue.identifier == "mainViewToTabViewCane") {
            if let destinationController = segue.destinationViewController as? TabBarController {
                destinationController.farmer = farmerText.text
                destinationController.entity = entityText.text
                destinationController.location = locationText.text
                destinationController.acres = acresText.text
                destinationController.farmNo = entityText.text
                destinationController.tractNo = tractNoStrings[tractRow]
                destinationController.county = ""
                destinationController.optionSelected = "Cane"
                
                //added 1.3
                destinationController.contactNo = contactNoStrings[tractRow]
                destinationController.county = countyStrings[tractRow]
                destinationController.email = emailStrings[tractRow]
                //end 1.3
            }
        }
    }
    
    func getRecordsFromCloud() {
        var combinedDate:NSDate!
        let cloudContainer = CKContainer.defaultContainer()
        let publicDatabase = CKContainer.defaultContainer().publicCloudDatabase
        
        if let date = defaults.objectForKey("cloudKitDate") as? NSDate {
            combinedDate = date
        } else {
            let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)
            let components = NSDateComponents()
            components.year = 2015
            components.month = 6
            components.day = 1 //midnight on 06/01/2015
            var newDate = calendar!.dateFromComponents(components)
            combinedDate = newDate
            defaults.setObject(newDate, forKey: "cloudKitDate")
        }
        
        let predicate = NSPredicate(format: "modificationDate > %@", combinedDate)
        let query = CKQuery(recordType: "Farmer", predicate: predicate)
        
        //OPERATIONAL API BELOW
//        let queryOperation = CKQueryOperation(query: query)
//        queryOperation.queuePriority = .VeryHigh
//        queryOperation.resultsLimit = 1000
//        queryOperation.recordFetchedBlock = { (record:CKRecord!) -> Void in
//            if let farmerRecord = record {
//                self.farmers.append(farmerRecord)
//            }
//        }
//        queryOperation.queryCompletionBlock = { (cursor:CKQueryCursor!, error:NSError!) -> Void in
//            if error != nil {
//                println("Failed to get data from iCloud - \(error.localizedDescription)")
//            } else {
//                println("Successfully retrieved the data from iCloud")
//                dispatch_async(dispatch_get_main_queue(), {
//                    println(self.farmers.count)
//                    self.addFarmersToCoreData()
//                    self.spinner.stopAnimating()
//                    self.overlayView.removeFromSuperview()
//                    self.loadDataInFarmerPicker()
//                })
//            }
//        }
//        publicDatabase.addOperation(queryOperation)
        
        //CONVENIENCE API BELOW
        publicDatabase.performQuery(query, inZoneWithID: nil, completionHandler: {
            results, error in
            if error == nil {
                self.farmers = results as! [CKRecord]
                dispatch_async(dispatch_get_main_queue(), {
                    println(self.farmers.count)
                    self.addFarmersToCoreData()
                    self.spinner.stopAnimating()
                    self.overlayView.removeFromSuperview()
                    self.loadDataInFarmerPicker()
                })
            } else {
                println(error)
            }
        })
    }
    
    func addFarmersToCoreData() {
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext {
            for record in farmers {
                farmer = NSEntityDescription.insertNewObjectForEntityForName("Farmer", inManagedObjectContext: managedObjectContext) as! Farmer
                farmer.firstName = record.objectForKey("FirstName") as! String
                farmer.lastName = record.objectForKey("LastName") as! String
                farmer.address = record.objectForKey("Address") as! String
                farmer.city = record.objectForKey("City") as! String
                farmer.state = record.objectForKey("State") as! String
                farmer.zipCode = record.objectForKey("ZipCode") as! Int
                farmer.phoneNumber = record.objectForKey("PhoneNumber") as! String
                
                if let myEmail = record.objectForKey("Email") as? String {
                    farmer.email = myEmail
                } else {
                    farmer.email = ""
                }
                
                farmer.farmNo = record.objectForKey("FarmNo") as! Int
                farmer.tractNo = record.objectForKey("TractNo") as! Int
                farmer.acres = record.objectForKey("Acres") as! Double
                farmer.county = record.objectForKey("County") as! String
                farmer.contactNumber = record.objectForKey("ContactNumber") as! Int
                var error:NSError?
                if managedObjectContext.save(&error) != true {
                    println("insert error: \(error!.localizedDescription)")
                    return
                }
            }
        }
    }
}
