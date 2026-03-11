//
//  UserInfoViews.swift
//  TheRideApp
//
//  Created by Brayhan Morrobel on 3/9/26.
//

import Foundation
import SwiftUI

//This view contains the information of the driver that took the users request
struct myDriverInformation: View{
    @Binding var passenger: PassengerObjects
    
    var body: some View{
        Text("Information on Driver")
    }
}


//Displays information on the current passenger
struct myOwnInformation: View {
    @Binding var passenger: PassengerObjects
    
    
    var body: some View{
        Text("My Own information")
        Text("My name: \(passenger.name)")
        Text("My request id: \(passenger.request_id?.description ?? "Make a request to see this information")")
    }
}

//Displays destination information
struct myDestinationInformation: View{
    @Binding var passenger: PassengerObjects
    
    var body: some View{
        Text("Destination Information")
    }
}
