# Overview
This is MyRide, an app in development that is to replicate a ride ordering app. I started and developed the app using 
Apple's Developer Documentation, Apple's Swift Guidelines, and overflow discussion. 

MyRide demonstrates my understanding of front-end, backend, and frameworks within Apple's mobile development environment for iOS. From following iOS development guidelines to designing 
UI components to enhance user experience, MyRide shows growth and learning within mobile development.  

# Key Features
- Interactive map using Apple Maps via the MapKit framework
- Map centers according to the user's live location, due to XCode limitations location is simulated to a café in New York.
  The starting location is defaulted to Nague, Dominican Republic, and only updated if permission to use location was granted. 
- Dropoff location does a query on Apple's map database and displays the location within a radius around the user's location.
  Radius is manually measured to be a 0.4-degree area to filter location results. 
- Use SwiftUI for displaying views and incorporating UIKit views via UIViewRepresentable

# Architecture
- Frontend is handled by SwiftUI with states that update to views. Different views were created to separate logic and functionality,
  and those views are strategically connected via binding variables.
- Use of binding variables to create custom UI components, like the type bar, highlights, and moves description text on click, while storing user-typed information for later use in location searches. 
- Location is handled via the CoreLocation framework. Working side by side with
  the project's info.plist file, the project meets all of Apple's safety guidelines for using a device's location services. For this to be possible, a custom info. A plist file was needed.
  This requires plist keys like 'NSLocationAlwaysUsageDescription', to allow the use of the device's location.
- Backend is handled by Google Firebase's RealTime database, storing user information.
  This requires the installation of the Firebase SDK and integration of a GoogleService info.plist file
- Practiced version control workflow, keeping commits organized and working around repository syncing issues, further sharpening my version control capabilities.

# Struggles
The first main struggle was following Apple's guidelines for using a device's location services. If one wants to use such services, one needs to create their own info.plist file. 
However, when you create your own plist file, there are certain configurations that are no longer auto-generated. This was chaotic at first because each time I ran the app, a new configuration
was "missing". So I had to take many trips to StackOverflow. 
The next challenge was giving life to the User interface. Default views like "Text" and "TextField" are practical but dull. To inspire myself, I would go to applications like "Yahoo Finance"
and "Merill Edge" to see how the User Interface was handled on those apps, and try to replicate some ideas. 

# What is Next?
I have many ideas to further develop this application. The goal is to develop a full system where not only can a user be a passenger and request a ride from one location to another, but
also have users be able to be drivers, "accepting" ride requests from passengers. This requires heavy use of FireAbse RealTime Database, as well as clean organization in the database's
JSON tree.

  
