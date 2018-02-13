//
//  SettingsViewController.swift
//  MoodProve
//
//  Created by Malik Graham on 2/13/18.
//  Copyright © 2018 Malik Graham. All rights reserved.
//

import Cocoa
import CoreLocation
import OAuthSwift
import SwiftyJSON

class SettingsViewController: NSViewController, CLLocationManagerDelegate {
    
    
    var locationManager: CLLocationManager!

    @IBAction func authenticateGoogle(_ sender: Any) {
        
        let response: JSON = MoodProveHTTP.getRequest(urlRequest: "http://localhost:8080/auth/google?userid=1")
        if let urlForAuthentication = response["Response"].string {
            if let url = URL(string: urlForAuthentication), NSWorkspace.shared().open(url) {
                print("Opening in default web browser...")
            }
        }
    }
    
    @IBAction func authenticateFacebook(_ sender: Any) {
        
        let oauthswift = OAuth2Swift(
            consumerKey:    MoodProveAPIKeys.FacebookClientID,
            consumerSecret: MoodProveAPIKeys.FacebookClientSecret,
            authorizeUrl:   "https://www.facebook.com/dialog/oauth",
            accessTokenUrl: "https://graph.facebook.com/oauth/access_token",
            responseType:   "code"
        )
        
        //self.oauthswift = oauthswift
        //oauthswift.authorizeURLHandler = getURLHandler()
        let state = generateState(withLength: 20)
        let _ = oauthswift.authorize(
            withCallbackURL: URL(string: "http://localhost:8080/auth/facebook")!, scope: "public_profile user_posts", state: state,
            success: { credential, response, parameters in
                //self.showTokenAlert(name: serviceParameters["name"], credential: credential)
                //self.testFacebook(oauthswift)
        }, failure: { error in
            print(error.localizedDescription, terminator: "")
        }
        )
        
    }
    @IBAction func authenticateAndGetLocation(_ sender: Any) {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        // Ask for Authorisation from the User.
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var currentLocation = locations[locations.count - 1]
        print("running to save location")
        let latitude = locationManager.location!.coordinate.latitude
        let longitude = locationManager.location!.coordinate.longitude
        MoodProveHTTP.getRequest(urlRequest: "http://localhost:8080/user/location?userid=1&latitude=\(latitude)&longitude=\(longitude)")
    }
    
    static func saveFacebookToken(fbToken: String) {
        // pull up userId from storage
        let userid = 1
        let response = MoodProveHTTP.getRequest(urlRequest: "http://localhost:8080/auth/facebook/saveToken?userid=\(userid)&token=\(fbToken)")
        print(response)
    }

}
