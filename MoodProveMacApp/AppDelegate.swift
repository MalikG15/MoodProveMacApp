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
    
     var completeSettingsWindow: NSWindowController!

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
                
                // Saving facebook token locally
                // then retrieving it when CompleteSettings is
                // recreated and setting userId when the window is reloaded too
                let defaults = UserDefaults.standard
                defaults.set(fbToken, forKey: "fbToken")
                completeSettingsWindow = NSStoryboard(name : "Main", bundle: nil).instantiateController(withIdentifier: "completeSettingsWindow") as! CompleteSettingsWindowController
                let completeSettingsView = NSStoryboard(name:"Main", bundle: nil).instantiateController(withIdentifier: "completeSettingsView") as! CompleteSettingsViewController
                if let userId = defaults.string(forKey: "userid") {
                    completeSettingsView.userId = userId
                }
                completeSettingsWindow.window?.contentViewController = completeSettingsView
                completeSettingsWindow.window?.makeKeyAndOrderFront(nil)
                
    
            }
            NSApp.activate(ignoringOtherApps: true)
            
            
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

