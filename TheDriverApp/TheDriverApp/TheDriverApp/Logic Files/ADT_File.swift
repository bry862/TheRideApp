//
//  ADT_File.swift
//  TheDriverApp
//
//  Created by Brayhan Morrobel on 12/31/25.
//

import Foundation

//A requestObject wil be used to store a passengers request information once a driver pick it up
struct requestObject {
    
    var passengerName = String ()
    var pickUp = (Double(), Double())
    var dropOff = (Double(), Double())
    var requestID = String ()
}


//A driverObject has all these attributes. 
struct driverObject {
    
    let id = UUID()
    var name = String()
    var requestInformation = requestObject()
}


