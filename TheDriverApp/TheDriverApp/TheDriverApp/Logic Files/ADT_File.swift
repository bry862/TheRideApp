//
//  ADT_File.swift
//  TheDriverApp
//
//  Created by Brayhan Morrobel on 12/31/25.
//

import Foundation

//A requestObject wil be used to store a passengers request information once a driver pick it up
struct requestObject {
    
    var requestID = String ()
    var pickUp = (Double(), Double())
    var dropOff = (Double(), Double())
    var pickupName = String()
    var dropoffName = String()

}


//A driverObject has all these attributes. 
struct driverObject {
    
 
    var name = String()
    
}


