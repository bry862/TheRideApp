//
//  HomePage.swift
//  TheDriverApp
//  Created by Brayhan Morrobel on 12/31/25.
//

import SwiftUI
import Firebase

struct LoginPage: View {
    @Binding var driver: driverObject
    @Binding var loggedin: Bool
    

    @State var drivername = String()
    
    var body: some View {
        
        VStack{
            HStack{
                TextField("Enter Your Driver Name: ", text: $drivername)
                Button ("Log in"){
                    driver.name = drivername
                    if (!drivername.isEmpty) {
                        loggedin.toggle()
                    }
                }
            }
            
        }.padding()
        
        
    }
}


struct HomePage: View {
    @Binding var driver: driverObject
    
    @State var requestArray: [requestObject] = []
    @State var TheAcceptedRequest: requestObject = requestObject()
    
    @State var isExtended = false
    
    
    var body: some View {
        
        ZStack{
            GeometryReader{geo in
                
                //Name and scroll view fro availabe requests
                VStack{
                    
                    //Name
                    HStack {
                        Image(systemName: "person.fill")
                        Text(driver.name)
                    }
                    
                    Text("Availabe Request's Near You:")
                    
                    //Scroll view for availabe request
                    ScrollView {
                        
                        ForEach (requestArray, id: \.requestID){ req in
                            
                            HStack {
                                Text("From \(req.pickupName) to \(req.dropoffName)")
                                
                                Button (action: {
                                    acceptRequest(req)
                                    print(TheAcceptedRequest.pickupName)

                                    
                                   

                                }) {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                    
                }.frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                
              

                
                //slide up
                VStack{
                    slideUp(driver: $driver, TheAcceptedRequest: $TheAcceptedRequest,isExtended: $isExtended)
                        .frame(width: geo.size.width, height: isExtended ? geo.size.height/1.5 : 100)
                }
                   
                .frame(width: geo.size.width, height: geo.size.height, alignment: .bottom)
                .offset(y:50)
                .onTapGesture {
                    withAnimation (.spring()){
                        isExtended.toggle()
                    }
                }
               
            
            }
        }
            .onAppear{ //Called on ZStack//
                listenForRequest()
            }
        
    
            
    }
    
    //MARK: HomePage Functions
    func listenForRequest () -> Void {
        
        //Swift type
        
        var newRquest = requestObject()
     
        Database.database().reference().child("Request").observe(.childAdded) { snapshot in
       
        
            guard let dict = snapshot.value as? [String: Any] else { return }
            
            
         
            //Navigate the rest JSOn tree to fill in the rest of the values.
            if let id_string = (dict["Request ID"] as? String) {
              
                
                newRquest.requestID = id_string
                
                //Pick up coordinates:
                if let request_pick_up_lat = (dict["Pick up"] as? [String: Any])?["Lattitude"] as? Double {
                    newRquest.pickUp.0 = request_pick_up_lat
                }
                
                if let request_pick_up_lat = (dict["Pick up"] as? [String: Any])?["Longitude"] as? Double {
                    newRquest.pickUp.1 = request_pick_up_lat
                }
                
                //Drop off coordinates
                if let request_dropoff_lat = (dict["Drop off"] as? [String: Any])?["Lattitude"] as? Double {
                    newRquest.dropOff.0 = request_dropoff_lat
                }
                
                if let request_dropoff_lon = (dict["Drop off"] as? [String: Any])?["Longitude"] as? Double {
                    newRquest.pickUp.1 = request_dropoff_lon
                }
                
                //Names
                
                if let name = (dict["Pick up location"] as? String){
                    newRquest.pickupName = name
                }
                
                if let name = (dict["Drop off location"] as? String){
                    newRquest.dropoffName = name
                }
                
                
                requestArray.append(newRquest)
           
            }
            
            
            
            
        }
        
    }
    
  
    

    func acceptRequest(_ acceptedRequest: requestObject) {
        
        
        requestArray.removeAll() //Adjust the array, first clear it then add the selected request
        
        requestArray.append(acceptedRequest)
        
        TheAcceptedRequest = acceptedRequest
        
        //Adjust the path in firebase, request accepted = true
        Database.database().reference().child("Request").child("\(acceptedRequest.requestID)").child("Request Information").child("Current Status").setValue(true)
        
        //Adjust the path in firebase, assign driver name
        Database.database().reference().child("Request").child("\(acceptedRequest.requestID)").child("Request Information").child("Assigned Driver").setValue("\(driver.name)")
        
        
        
    }

    

        
        
}

struct slideUp: View{
    
    @Binding var driver: driverObject
    
    @Binding var TheAcceptedRequest: requestObject
    
    @Binding var isExtended: Bool
    
    var body: some View{
        ZStack{
            
            
            GeometryReader{geo in
                
                
                    
                
                Rectangle()
                    .fill(Material.thin)
                    .cornerRadius(10)
                VStack{
                    Capsule()
                    
                        .fill(.gray)
                        .cornerRadius(40)
                        .frame(width: 50, height: 5)
                        .padding(.top)
                }.frame(width: geo.size.width, height: geo.size.height, alignment: .top)
                
                
                //Driver name, request availabe label
                VStack{
                    if(isExtended){
                        Text("Pick up: \(TheAcceptedRequest.pickupName)")
                        Text("Drop off: \(TheAcceptedRequest.dropoffName)")
                        Text("Passangers Name: \(TheAcceptedRequest.requestignPassangerName)")
                        
                    }
                    
                   
                }
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                

                
                
                
                
                
            }
        }
    }
    

}

