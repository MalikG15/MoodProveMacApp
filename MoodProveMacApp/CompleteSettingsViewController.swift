//
//  CompleteSettingsViewController.swift
//  MoodProve
//
//  Created by Malik Graham on 2/14/18.
//  Copyright © 2018 Malik Graham. All rights reserved.
//

import Cocoa

class CompleteSettingsViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    var userId: String?
    
    var eventsDescriptions: [String:String]?
    
    var eventTitles: [String:String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        // Get unrated events
        // getAndDisplayUnratedEvents()
        
        
    }
    
    func getAndDisplayUnratedEvents() {
        let path = "/events?\(userId!)"
        let response = MoodProveHTTP.getRequest(urlRequest: MoodProveHTTP.moodProveDomain + path)
        
        
    }
    
    // MARK: - Table Implementation
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return (eventTitles?.count)!
    }
    
    
}
