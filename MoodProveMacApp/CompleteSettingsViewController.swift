//
//  CompleteSettingsViewController.swift
//  MoodProve
//
//  Created by Malik Graham on 2/14/18.
//  Copyright © 2018 Malik Graham. All rights reserved.
//

import Cocoa
import SwiftyJSON
import CoreLocation
import OAuthSwift

class CompleteSettingsViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate, CLLocationManagerDelegate {
    
    // MARK: - Member Variables
    
    var userId: String?
    
    var eventDescriptions: [String] = [String]()
    
    var eventTitles: [String] = [String]()
    
    var eventIds: [String] = [String]()
    
    var eventDates: [Int64] = [Int64]()
    
    var locationManager: CLLocationManager!
    
    var oauthswift: OAuth2Swift?
    
    // MARK: - Application functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        

        // Check if token was saved, if yes delete
        /* if let fbToken = UserDefaults.standard.string(forKey: "fbToken") {
            // Some String Value
            saveFacebookToken(fbToken: fbToken)
            UserDefaults.standard.removeObject(forKey: "fbToken")
            UserDefaults.standard.removeObject(forKey: "userid")
        }
        // Check if userId was saved, if yes delete
        if let _ = UserDefaults.standard.string(forKey: "userid") {
            UserDefaults.standard.removeObject(forKey: "userid")
        } */
        
        // Get unrated events
        // authenticateWithGoogle()
        
        
        // Hiding table slider components
        rateIndicator.isHidden = true
        rateSlider.isHidden = true
        
        // Hiding manual button for Google authentication
        //print(userId! + " authenticating with Google")
        if (isAuthenticatedWithGoogle()) {
            justAuthenticatedWithGoogleButton.isHidden = true
            justAuthenticatedWithGoogle.isHidden = true
            getAndDisplayUnratedEvents()
        }
    }
    
    // MARK: - Buttons
    
    @IBOutlet weak var justAuthenticatedWithGoogleButton: NSButton!
    
    // MARK: - Tables
    
    @IBOutlet weak var unratedEvents: NSTableView!
    
    // MARK: - Sliders
    
    @IBOutlet weak var rateSlider: NSSlider!

    // MARK: - labels
    
    @IBOutlet weak var justAuthenticatedWithGoogle: NSTextField!
    
    @IBOutlet weak var rateIndicator: NSTextField!
    
    // MARK: - Function outlets
    
    @IBAction func authenticateLocation(_ sender: Any) {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                print("No access")
                locationManager.startUpdatingLocation()
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                //print(locationManager.location!.coordinate.latitude)
                break
                
            }
        } else {
            print("Location services are not enabled")
        }
    }
    
    @IBAction func authenticateWithFacebook(_ sender: Any) {
        /*if (isAuthenticatedWithFacebook()) {
            return
        }*/
        
        
        let defaults = UserDefaults.standard
        defaults.set(userId!, forKey: "userid")
        oauthswift = OAuth2Swift(
            consumerKey:    MoodProveAPIKeys.FacebookClientID,
            consumerSecret: MoodProveAPIKeys.FacebookClientSecret,
            authorizeUrl:   "https://www.facebook.com/dialog/oauth",
            accessTokenUrl: "https://graph.facebook.com/oauth/access_token",
            responseType:   "code"
        )
        
        self.oauthswift?.allowMissingStateCheck = true
       /* let state = generateState(withLength: 20)
        let _ = oauthswift.authorize(
            withCallbackURL: URL(string: "http://localhost:8080/auth/facebook")!, scope: "public_profile user_posts", state: state,
            success: { credential, response, parameters in
                // Do things
                print("hellooooooooooooooooo")
        }, failure: { error in
            print(error.localizedDescription, terminator: "")
        }
        )*/
        
        let state = generateState(withLength: 20)
        let _ = oauthswift!.authorize(
            withCallbackURL: URL(string: "http://localhost:8080/auth/redirect")!, scope: "public_profile user_posts", state: state,
            success: { credential, response, parameters in
                // Do things
                print("testing")
                print(credential.oauthToken)
                print(credential.oauthTokenExpiresAt)
        }, failure: { error in
            print(error.localizedDescription, terminator: "")
        }
        )
        
        
        
        // self.view.window?.close()
    }
    
    @IBAction func authenticateGoogle(_ sender: Any) {
        authenticateWithGoogle()
    }
    
    @IBAction func justAuthenticateWithGoogleAction(_ sender: Any) {
        let prevSize = eventTitles.count
        getAndDisplayUnratedEvents()
        unratedEvents.reloadData()
        let curSize = eventTitles.count
        if (prevSize != curSize) {
            justAuthenticatedWithGoogleButton.isHidden = true
            justAuthenticatedWithGoogle.isHidden = true
        }
    }
    
    @IBAction func rate(_ sender: Any) {
        let splittedNumArray = rateSlider.stringValue.components(separatedBy: ".")
        rateIndicator.stringValue = "\(splittedNumArray[0])"
    }
    
    // MARK: - HTTP Call Methods
    
    func getAndDisplayUnratedEvents() {
        let path = "/event/unratedevents?userid=\(userId!)"
        let response = MoodProveHTTP.getRequest(urlRequest: MoodProveHTTP.moodProveDomain + path)
        
        for (_, json) in response["events"] {
            eventIds.append(json["eventid"].stringValue)
            eventTitles.append(json["eventTitle"].stringValue)
            eventDescriptions.append(json["eventDescription"].stringValue)
            if let date = json["date"].int64 {
                print("here")
                eventDates.append(date)
            }
            else {
                eventDates.append(0)
            }
        }
        
    }
    
    // Completing authentication
    func authenticateWithGoogle() {
        let response: JSON = MoodProveHTTP.getRequest(urlRequest: "http://localhost:8080/auth/google?userid=\(userId!)")
        if let urlForAuthentication = response["Response"].string {
            if let url = URL(string: urlForAuthentication), NSWorkspace.shared().open(url) {
                print("Opening in default web browser...")
            }
        }
    }
    
    // Ask if user is authenticated
    func isAuthenticatedWithGoogle() -> Bool {
        let response: JSON = MoodProveHTTP.getRequest(urlRequest: MoodProveHTTP.moodProveDomain + "/auth/checkAuthWithGoogle?userid=\(userId!)")
        if response["Result"] == "true" {
            return true
        }
        
        return false
    }
    
    func isAuthenticatedWithFacebook() -> Bool {
        let response: JSON = MoodProveHTTP.getRequest(urlRequest: MoodProveHTTP.moodProveDomain + "/auth/checkAuthWithFacebook?userid=\(userId!)")
        if response["Result"] == "true" {
            return true
        }
        
        return false
    }
    
    func saveFacebookToken(fbToken: String) {
        // pull up userId from storage
        let response = MoodProveHTTP.getRequest(urlRequest: "http://localhost:8080/auth/facebook/saveToken?userid=\(userId!)&token=\(fbToken)")
    }
    
    // MARK: - Table Implementation
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return eventTitles.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let eventTitle = eventTitles[row]
        let eventDescription = eventDescriptions[row]
        
        if tableColumn?.identifier == "eventTitle" {
            if let cell = tableView.make(withIdentifier: "eventTitleCell", owner: self) as? NSTableCellView {
                cell.textField?.stringValue = eventTitle
                return cell
            }
        }
        else {
            if let cell = tableView.make(withIdentifier: "eventDescriptionCell", owner: self) as? NSTableCellView {
                cell.textField?.stringValue = eventDescription
                return cell
            }
        }
        
        return nil
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        rateIndicator.isHidden = false
        rateSlider.isHidden = false
    }
    
    // MARK: - Location Functions
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var currentLocation = locations[locations.count - 1]
        print("running to save location")
        let latitude = locationManager.location!.coordinate.latitude
        let longitude = locationManager.location!.coordinate.longitude
        MoodProveHTTP.getRequest(urlRequest: "http://localhost:8080/user/location?userid=\(userId!)&latitude=\(latitude)&longitude=\(longitude)")
    }
    
    override func keyDown(with event: NSEvent) {
        if (event.keyCode == 36) {
            if (unratedEvents.selectedRow >= 0) {
                let selectedId = eventIds[unratedEvents.selectedRow]
                let date = eventDates[unratedEvents.selectedRow]
                let splittedNumArray = rateSlider.stringValue.components(separatedBy: ".")
                let rate = splittedNumArray[0]
            
                // remove items
                eventTitles.remove(at: unratedEvents.selectedRow)
                eventDescriptions.remove(at: unratedEvents.selectedRow)
                eventDates.remove(at: unratedEvents.selectedRow)
                eventIds.remove(at: unratedEvents.selectedRow)
            
            
                
                // Retrieve and set the new data
                // getAndDisplayUnratedEvents()
                unratedEvents.reloadData()
                
                
                let path = "/event/rate?userid=\(userId)&eventid=\(selectedId)&date=\(date)&rating=\(rate)"
                print(MoodProveHTTP.moodProveDomain + path)
                MoodProveHTTP.getRequest(urlRequest: MoodProveHTTP.moodProveDomain + path)
            }
        }
    }
    
    
}
