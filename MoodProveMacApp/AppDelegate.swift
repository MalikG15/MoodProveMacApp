//
//  AppDelegate.swift
//  MoodProveMacApp
//
//  Created by Malik Graham on 12/28/17.
//  Copyright © 2017 Malik Graham. All rights reserved.
//

import Cocoa
import OAuthSwift

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
     var main: NSWindowController!

    func applicationDidFinishLaunching(_ aNotification: NSNotification) {
        NSAppleEventManager.shared().setEventHandler(self, andSelector:#selector(AppDelegate.handleGetURL(event:withReplyEvent:)), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
    }
    
    func handleGetURL(event: NSAppleEventDescriptor!, withReplyEvent: NSAppleEventDescriptor!) {
        if let urlString = event.paramDescriptor(forKeyword: AEKeyword(keyDirectObject))?.stringValue, let url = URL(string: urlString) {
            
            var urlString = String(describing: url)
            let countOfBaseUrl = "lawrence.moodprovemacapp://".characters.count
            if (urlString.characters.count > countOfBaseUrl) {
                let index = urlString.index(urlString.startIndex, offsetBy: countOfBaseUrl)
                let fbToken = urlString.substring(from: index)
                SettingsViewController.saveFacebookToken(fbToken: fbToken)
            }
            
            /*print(url)
            main = NSStoryboard(name : "Main", bundle: nil).instantiateController(withIdentifier: "OAuthResponseWindow") as! NSWindowController
            let mainVc = NSStoryboard(name:"Main", bundle: nil).instantiateController(withIdentifier: "OAuthResponseView") as! NSViewController
            main.window?.contentViewController = mainVc
            main.window?.makeKeyAndOrderFront(nil)*/
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

