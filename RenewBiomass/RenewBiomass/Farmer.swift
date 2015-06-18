//
//  Farmer.swift
//  RenewBiomass
//
//  Created by Jason Carothers on 6/10/15.
//  Copyright (c) 2015 iCarothers. All rights reserved.
//

import Foundation
import CoreData

class Farmer:NSManagedObject {
    
    @NSManaged var firstName:String!
    @NSManaged var lastName:String!
    @NSManaged var address:String!
    @NSManaged var city:String!
    @NSManaged var state:String!
    @NSManaged var zipCode:NSNumber!
    @NSManaged var phoneNumber:String!
    @NSManaged var email:String!
    @NSManaged var farmNo:NSNumber!
    @NSManaged var tractNo:NSNumber!
    @NSManaged var contactNumber:NSNumber!
    @NSManaged var acres:NSNumber!
    @NSManaged var county:String!
}
