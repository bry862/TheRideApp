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
    
   
    
    @State var test_msg = String()
    @State var requestArray: [requestObject] = []

    
    var body: some View {
        
        VStack{
            
            //Driver Display Name
            HStack {
                Image(systemName: "person.fill")
                Text(driver.name)
            }
            
            Spacer(minLength: 10)
            Text("Availabe Request's Near You:")
            
            ScrollView {
                
                ForEach (requestArray, id: \.requestID){ req in
                    
                    HStack {
                        Text("\(req.requestID)")
                        
                        Button (action: {
                            acceptRequest(req)
                        }) {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
                
                
        }.onAppear{
            listenForRequest()
        }
            
            
            
    }
    
    //MARK: HomePage Functions
    func listenForRequest () -> Void {
     
        Database.database().reference().child("Request").observe(.childAdded) { snapshot in
       
        
            guard let dict = snapshot.value as? [String: Any] else { return }
            
            
            //Swift type
            
            var newRquest = requestObject()
            
            if let id_string = (dict["Request ID"] as? String) {
              
                
                newRquest.requestID = id_string
                
                requestArray.append(newRquest)
           
            }
            
            
            
            
        }
        
    }
    
    func acceptRequest(_ acceptedRequest: requestObject) {
        
        //Adjust the array
        requestArray.removeAll()
        
        requestArray.append(acceptedRequest)
        
        //Adjust the path in firebase
        Database.database().reference().child("Request").child("\(acceptedRequest.requestID)").child("Request Information").child("Current Status").setValue(true)
        
        //Adjust the path in firebase
        Database.database().reference().child("Request").child("\(acceptedRequest.requestID)").child("Request Information").child("Assigned Driver").setValue("\(driver.name)")
        
        
    }
    

        
        
}



