//
//  CompleteSettingsViewController.swift
//  MoodProve
//
//  Created by Malik Graham on 2/14/18.
//  Copyright © 2018 Malik Graham. All rights reserved.
//

import Cocoa
import SwiftyJSON

class CompleteSettingsViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    // MARK: - Member Variables
    
    var userId: String = "4b107e32-0a2d-46ee-970b-4331ecd8eca5"
    
    var eventDescriptions: [String] = [String]()
    
    var eventTitles: [String] = [String]()
    
    var eventIds: [String] = [String]()
    
    var eventDates: [Int64] = [Int64]()
    
    // MARK: - Application functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        // Get unrated events
        // authenticateWithGoogle()
        
        
        // Hiding table slider components
        rateIndicator.isHidden = true
        rateSlider.isHidden = true
        
        // Hiding manual button for Google authentication
        if (isAuthenticatedWithGoogle()) {
            justAuthenticatedWithGoogleButton.isHidden = true
            justAuthenticatedWithGoogle.isHidden = true
            getAndDisplayUnratedEvents()
        }
    }
    
    // MARK: - Buttons
    
    @IBOutlet weak var justAuthenticatedWithGoogleButton: NSButton!
    
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
    
    // MARK: - Tables
    
    @IBOutlet weak var unratedEvents: NSTableView!
    
    // MARK: - Sliders
    
    @IBOutlet weak var rateSlider: NSSlider!

    // MARK: - labels
    
    @IBOutlet weak var justAuthenticatedWithGoogle: NSTextField!
    
    @IBOutlet weak var rateIndicator: NSTextField!
    
    // MARK: - Function outlets
    
    @IBAction func authenticateGoogle(_ sender: Any) {
        authenticateWithGoogle()
    }
    
    @IBAction func rate(_ sender: Any) {
        let splittedNumArray = rateSlider.stringValue.components(separatedBy: ".")
        rateIndicator.stringValue = "\(splittedNumArray[0])"
    }
    
    // MARK: - HTTP Call Methods
    
    func getAndDisplayUnratedEvents() {
        let path = "/event/unratedevents?userid=\(userId)"
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
        let response: JSON = MoodProveHTTP.getRequest(urlRequest: "http://localhost:8080/auth/google?userid=\(userId)")
        if let urlForAuthentication = response["Response"].string {
            if let url = URL(string: urlForAuthentication), NSWorkspace.shared().open(url) {
                print("Opening in default web browser...")
            }
        }
    }
    
    // Ask if user is authenticated
    func isAuthenticatedWithGoogle() -> Bool {
        let response: JSON = MoodProveHTTP.getRequest(urlRequest: MoodProveHTTP.moodProveDomain + "/auth/checkAuthWithGoogle?userid=\(userId)")
        if response["Result"] == "true" {
            return true
        }
        
        return false
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
