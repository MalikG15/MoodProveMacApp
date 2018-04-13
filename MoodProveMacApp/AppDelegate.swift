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
            print(urlString)
            OAuthSwift.handle(url: url)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

