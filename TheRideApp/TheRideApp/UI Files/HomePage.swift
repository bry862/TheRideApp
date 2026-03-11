//
//  HomePage.swift
//  TheRideApp
//
//  Created by Brayhan Morrobel on 12/25/25.
//

/*
 HomePage.
 The page where the passenger picks its drop off location and sees the map.
 */

import SwiftUI
import CoreLocation
import MapKit
import Firebase

//MARK: LoginPage
//This view is for passenegr to log in.. Then call hoem page
struct LoginPage: View {
    
    
    @Binding var passenger: PassengerObjects//We will use the passanger object's request_id to navigate the JSon tree made for this specific request. This is safe, as no two users could have the same request_id.
    
   
    
    
    @Binding var loggedIn: Bool
    var body: some View {
        HStack{
            TextField ("Enter Name: ", text: $passenger.name)
            Button ("Log in"){
                if (passenger.name.isEmpty != true){
                    loggedIn = true
                }
            }

        }
        
        
    }
}


//MARK: HomePage
struct HomePage: View {
    
    
    @Binding var passenger: PassengerObjects //The passenger object that will be passed to views. Contains all information of one passenger.
  
    
    
    //High Value Variables
    @State var GlobalLocationManager = LocationClass1() //Manage Location services, and geocoding
    @State var LocationsArray: [LocationObjects] = [] //Array to display the search result locations and passenger live location on map
    
    @State var PassengerCurrentLocation: MKMapItem? //The  live location of the passenger
    @State var PassengerDropoffLocation: MKMapItem? //The location the passenger chose to be their drop off
   
    
   
    

    
    
    @State var map_size_: CGFloat = 300
    

    @State var pickup = "" //pickup name used in InfoField
    @State var dropoff = "" //dropoff name used in Infofield
    @State var requestAccpeted = false //Bool to update when a driver picks a passengers request. Will be used to display driver info on InfoUI.
    
    
    //InfoUI Variables
    @State var InfoUIHeight: CGFloat = 200
    @State var dragOffset:CGSize = .zero
    @State var endOffSet: CGSize = .zero
    
    
    
    var body: some View {
        
        //MARK: Main Zstack
        ZStack{ GeometryReader {geo in
            
            
            
            //MARK: VStack1
            //Has: Map view, Pickup, Dropoff views, scrowllview, & check marks
            VStack {
                Text ("Hello, \(passenger.name)!")
                
                
                //Map view
                TheMapView(LocationArray: $LocationsArray, PassengerCurrentLocation:  $PassengerCurrentLocation, PassengerDropOffLocation: $PassengerDropoffLocation, GlobalLocationManager: $GlobalLocationManager)
                    
                    .frame(width: geo.size.width-10 , height: map_size_) // Enlarge with an animation by changing map_size_ on button press.
                    .cornerRadius(20)
                    .padding(.bottom)
                    .position(
                        x: geo.size.width/2,
                        y: geo.size.height/5
                    )
                    
                
                //Pickup, Dropoff info views, and pickup, droppoff name labels
                VStack {
                    infoField(title: "Pickup", text: $pickup, disabledBool: true)
                        
                    HStack{
                        infoField(title: "Dropoff", text: $dropoff, disabledBool: false).padding(.leading,48)
                        
                        //Button and arrow
                        ZStack {
                            RoundedRectangle(cornerRadius: 8).fill(.blue).frame(width: 40, height: 30)
                            
                            //Search for dropoff button
                            Button (action: {
                                LocationsArray.removeAll() //The array will be populated with new results.
                                if (!dropoff.isEmpty) {
                                    
                                    //First, get PassengerCurrentLocation using the infromation form LocationFile. We will add this to the LocationsArray.
                                    let placemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: GlobalLocationManager.getPassengerLocationObject().coordinate.latitude, longitude: GlobalLocationManager.getPassengerLocationObject().coordinate.longitude))
                                    
                                    PassengerCurrentLocation = MKMapItem(placemark: placemark)
                                    PassengerCurrentLocation?.name = GlobalLocationManager.getPassengerLocationPlacemark().name
                                    
                                    //Get pickup name to display on InfoField
                                    pickup = GlobalLocationManager.getPassengerLocationPlacemark().name!
                                    
                                    //Now call the fucntion that will find the dropoff locations base don the users search result.
                                    findLocations(near: CLLocation(latitude: PassengerCurrentLocation!.placemark.coordinate.latitude, longitude: PassengerCurrentLocation!.placemark.coordinate.longitude), named: dropoff)
                                    
                                    
                                    
                                }
                            }) {
                                Image(systemName: "arrow.right").foregroundColor(.white)
                            }
                            
                            
                            
                            
                            
                        }
                    }
                    
                    
                    //Pick up and dropoff labels
                    HStack{
                        Image(systemName: "mappin.and.ellipse")
                        Text ("Pick-up: \(pickup)")
                    }
                    
                    HStack{
                        Image(systemName: "flag.fill")
                        Text ("Choose a dropoff location:")
                    }
                    
                }
                
                
                
                //Scrollvoew contiaing all the search results and the checkmarks to choose a location
                ScrollView{
                    
                    
                    VStack {
                        
                        ForEach ($LocationsArray, id: \.id){ $location in
                            
                            HStack {
                                Text(location.name)
                                
                                //Theres a button for each location. When button is clicked -> that specific location is used.
                                Button (action: {
                                    
                                    
                                    selectLocation(location) //Select that one location
                                    
                                    //Now we will store this location that was chosen in the @State PassengerDropOffLocation
                                    
                                    let placemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
                                    
                                    
                                    
                                    
                                    
                                    PassengerDropoffLocation = MKMapItem(placemark: placemark)
                                    
                                    
                                    
                                    
                                    let dropoff_location_as_CLLocation = CLLocation(latitude: (PassengerDropoffLocation?.placemark.coordinate.latitude)!, longitude: (PassengerDropoffLocation?.placemark.coordinate.longitude)!)
                                    
                                    //Reverse geocode correctly turns the drop_off_location_as_CLLocation to a human address.
                                    GlobalLocationManager.callReverseGeocode (TargetLocation: dropoff_location_as_CLLocation) { (x: [CLPlacemark]?, y: (any Error)?) in
                                        
                                        if (x?.first?.name != nil){
                                            
                                            
                                            
                                            guard let name = x?.first?.name else { return }
                                            DispatchQueue.main.async {
                                                PassengerDropoffLocation?.name = name
                                                callAddRequest (forUser: passenger, from: PassengerCurrentLocation!, to: PassengerDropoffLocation!)
                                                
                                            }
                                            
                                            
                                            
                                            
                                        }
                                        
                                        
                                        
                                        
                                        
                                    }
                                    
                                    
                                    
                                    
                                    
                                    
                                }) {
                                    Image(systemName: "checkmark")
                                }
                            }
                            
                            
                        }
                        
                        
                    }
                    
                }.frame(height: 200)
                

                    
                
                
                
                
                
                
            }
            
            
            
            
            //MARK: InfoUI Call VStack
            VStack{ GeometryReader{ geo in
                
                //My bottom sheet
                InfoUI(passenger: $passenger, endOffSet: $endOffSet, requestAccepted: $requestAccpeted)
                    .frame(width: geo.size.width , height: 800,  alignment: .bottom,)
                    .cornerRadius(20)
                    .contentShape(Rectangle())
                    .position(
                        x:geo.size.width/2,
                        y:geo.size.height*1.4 + (endOffSet.height + dragOffset.height)
                    )
                    .ignoresSafeArea()
                   
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged{ value in
                                
                                if (value.translation.height < 0){
                                    
                                    if (value.translation.height < -450){
                                        dragOffset.height = -450
                                        
                                    } else {
                                        dragOffset.height = value.translation.height
                                    }
                                
                                } else { //meainign its positive, dragging down
                                    if (value.translation.height > 690){
                                        dragOffset.height = 690
                                    } else {
                                        dragOffset.height = value.translation.height
                                    }
                                }
                            
                                
                                
                                print(value.translation.height)
                                
                            }
                        
                            .onEnded{value in
                                if (value.translation.height < -50){
                                    endOffSet.height = -600
                                }
                                
                                else if (value.translation.height > 50){
                                    endOffSet.height = 0
                                }
                                
                                dragOffset = .zero
                            }
                        
                        
                        
                        
                        
                            
                            
                            
                    )
                
            }
                
                
                
            }
                
                
        }
        
       
        }//End main ZStack
            
    }
    

    
    //MARK: HomePage View Functions
    //@brief: Wrapper function to write in database
    func callAddRequest(forUser: PassengerObjects, from: MKMapItem, to: MKMapItem){
        passenger.request_id = DataBaseManager.shared.addRequest(forUser: forUser, from: from, to: to)
        
        
        listenForRequestupdate()
        
    }
    
    //@brief compare:  A functiom that determines if a location is within the range we want(I set to be 0.2 degrees radius
    func compare (_ coordinate_in_question: CLLocationCoordinate2D, withRefferenceTo: CLLocation) -> Bool {
        let ReigonN: [String:(Double, Double)] = [
            
            
            "a": (withRefferenceTo.coordinate.latitude + 0.2, withRefferenceTo.coordinate.longitude - 0.2),
            "b": (withRefferenceTo.coordinate.latitude - 0.2, withRefferenceTo.coordinate.longitude + 0.2)
        ]
        
        // latitude: 19.37313, longitude: -69.85623
        
        
        //Condition 1, phi
        if ((coordinate_in_question.latitude <= ReigonN["a"]!.0) && (coordinate_in_question.latitude >= ReigonN["b"]!.0)){
            
            //Condition 2, lamda
            if ((coordinate_in_question.longitude >= ReigonN["a"]!.1) && (coordinate_in_question.longitude <= ReigonN["b"]!.1)) {
                return true
            }
    
        }
        
        return false
    }
    
    
    /*
     
     @brief: This function looks for locations near a specific location with a specific name
     
     @param near: a CLLocation object representing the location of interest, around which we will search for locations with the
     name "named"
     
     @param named: a String representing the name of the locations we are looking for.
     
     */
    func findLocations (near user_current_location: CLLocation?,named target_location: String) -> Void {
        
        
        if LocationsArray.isEmpty {
            print ("Emptied out the array")
        }else {
            print ("error clearing")
        }
        
        let request = MKLocalSearch.Request()
        
        var center = CLLocationCoordinate2D()
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        
        if (user_current_location != nil){
            center.latitude = user_current_location!.coordinate.latitude
            center.longitude = user_current_location!.coordinate.longitude
            
        } else {
            print ("Error with user_current_location in findLocations")
            return
        }
        let region = MKCoordinateRegion(center: center, span: span)
        
        request.region = region
        request.naturalLanguageQuery = target_location
        request.resultTypes = .pointOfInterest
        
        let search = MKLocalSearch(request: request)
        
        search.start(completionHandler: { (result: MKLocalSearch.Response?, errorMessage: Error?) in
            if errorMessage != nil {
                print ("Error Searching")
                return
            }
            
            for item in result!.mapItems {
                
                if (compare(item.placemark.coordinate, withRefferenceTo: user_current_location!)) {
                    
                    var newLocation = LocationObjects()
                    newLocation.name = item.name!
                    newLocation.latitude = item.placemark.coordinate.latitude
                    newLocation.longitude = item.placemark.coordinate.longitude
                    
                   
                    LocationsArray.append(newLocation)
                
                }else {
                    print ("Not Added")
                }
            }
        })
      
    }
    
    //@brief: Clears the LocationsArray and keeps only the item passed as a parameter.
    func selectLocation (_ LocationToChoose: LocationObjects) -> Void {
        
        LocationsArray.removeAll()
        LocationsArray.append(LocationToChoose)
        
        }
    
    //@brief: update the requestAccepted State variable accordign to our data base
    func listenForRequestupdate () {
        
        if (passenger.request_id?.description != nil){
            
            Database.database().reference().child("Request").child(passenger.request_id!.description).child("Request Information").child("Current Status").observe(.value) { snapshot in
                
                
                if let tempBool = snapshot.value as? Bool {
                 
                    requestAccpeted = tempBool
                    print (requestAccpeted)
                }
            }
        }
    }
    
    
}


//MARK: Info-UI
struct InfoUI: View {
    
    @Binding var passenger: PassengerObjects
    @Binding var endOffSet: CGSize
    @Binding var requestAccepted: Bool
    
    @State var call_driver_information_view = false;
    @State var call_my_information_view = false;
    @State var call_destination_information_view = false;
    
    
    
    var body: some View {
        
        ZStack{ GeometryReader{ geo in
            
            Rectangle()
                .fill(.thinMaterial)
            
            HStack{
                
                
                
                VStack{
                  
                    Button(action: {
                        call_driver_information_view.toggle()
                        
                        call_my_information_view = false;
                        call_destination_information_view = false;
                        
                        endOffSet.height = -600
                        
                    })
                    {
                        Image(systemName: "bicycle")
                    }
                    .font(.system(size: 30))
                    .disabled(!requestAccepted)
                    
                }
                
                
                VStack{
                    Text("X mins away")
                        .font(.system(size:10))
                    Image(systemName: "arrowshape.right")
                    
                  
                    
                }.padding(.horizontal,10)
                
                VStack{
               
                    Button(action: {
                        call_my_information_view.toggle()
                        
                        call_driver_information_view = false;
                        call_destination_information_view = false;
                        
                        endOffSet.height = -600
                        
                    }) {
                        Image(systemName: "person")
                    }
                    .font(.system(size: 30))
                    
                    
                }
                
                VStack{
                    Text("Y mins away")
                        .font(.system(size:10))
                    Image(systemName: "arrowshape.right")
                    
                }.padding(.horizontal,10)
                
                VStack{
                    Button(action: {
                        call_destination_information_view.toggle()
                        
                        call_driver_information_view = false;
                        call_my_information_view = false;
                        
                        endOffSet.height = -600
                        
                    }) {
                        Image(systemName: "flag")
                    }
                    .font(.system(size: 30))
                    .disabled(!requestAccepted)
                }
            }
            .frame(width: geo.size.width, height: geo.size.height, alignment: .top)
            .padding(.top,40)
            
            Divider()
            
            //Calling the different views in the user InfoUI
            VStack{
                if (call_driver_information_view){
                     myDriverInformation(passenger: $passenger)
                        .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                }
            }
            
            VStack{
                if (call_my_information_view){
                     myOwnInformation(passenger: $passenger)
                        .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                }
            }
            
            VStack{
                if (call_destination_information_view){
                    myDestinationInformation(passenger: $passenger)
                        .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                }
            }
            
            
            
           
            
            
            
            
            
            }
        }
        
        
        
        
        
        
        
            
            
    }
}

