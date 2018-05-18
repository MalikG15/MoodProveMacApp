//
//  ReportMoodViewController.swift
//  MoodProve
//
//  Created by Malik Graham on 5/15/18.
//  Copyright © 2018 Malik Graham. All rights reserved.
//

import Cocoa
import SwiftyJSON

class ReportMoodViewController: NSViewController {
    
    var userId: String?
    
    let moodModifiersOptions = ["--", "anxious", "calm", "confused", "overwhelmingly"]
    
    let baseMoodsOptions = ["--", "happy", "mad", "neutral", "sad", "stressed"]

    @IBOutlet weak var moodModifiers: NSPopUpButton!
    
    @IBOutlet weak var baseMoods: NSPopUpButton!
    
    @IBOutlet weak var currentMoodLabel: NSTextField!
    
    @IBAction func reportMood(_ sender: Any) {
        let selection = baseMoods.titleOfSelectedItem!
        if (selection != "--") {
            let modifierSelection = moodModifiers.titleOfSelectedItem!
            //var JsonObject: JSON = []
            var moodString = ""
            if (modifierSelection != "--") {
               // placing '%20' since it represents a space and 
               // so that the predicted mood can be sent via http
               moodString = modifierSelection + "%20" + selection
            }
            else {
                moodString = selection
            }
            print(moodString)
            executeReportMoodRequest(mood: moodString)
        }
    }
    
    @IBAction func tapModifiers(_ sender: Any) {
        let selection = moodModifiers.titleOfSelectedItem!
        let currentMoodLabelContents = currentMoodLabel.stringValue
        if (selection != "--") {
            for index in 0..<moodModifiersOptions.count {
                if ((currentMoodLabelContents.range(of: moodModifiersOptions[index])) != nil) {
                    currentMoodLabel.stringValue = currentMoodLabelContents.replacingOccurrences(of: moodModifiersOptions[index], with: selection)
                    return
                }
            }
            // if a modifier was not present, we just add it after 'was:'
            let labelComponents = currentMoodLabel.stringValue.components(separatedBy: " ")
            var updatedString = ""
            for index in 0..<labelComponents.count {
                if (labelComponents[index] == "was:") {
                    updatedString += labelComponents[index]
                    updatedString += " " + selection
                }
                else {
                    if (index < labelComponents.count - 1) {
                        updatedString += labelComponents[index] + " "
                    }
                    else {
                        updatedString += labelComponents[index]
                    }
                }
            }
            currentMoodLabel.stringValue = updatedString
        }
        // remove modifier if -- is selected
        else {
            for index in 0..<moodModifiersOptions.count {
                if ((currentMoodLabelContents.range(of: moodModifiersOptions[index])) != nil) {
                    currentMoodLabel.stringValue = currentMoodLabelContents.replacingOccurrences(of: moodModifiersOptions[index], with: "")
                    return
                }
            }
        }
    }

    @IBAction func tapBaseMoods(_ sender: Any) {
        let selection = baseMoods.titleOfSelectedItem!
        if (selection != "--") {
            let currentMoodLabelContents = currentMoodLabel.stringValue
            for index in 0..<baseMoodsOptions.count {
                if ((currentMoodLabelContents.range(of: baseMoodsOptions[index])) != nil) {
                    currentMoodLabel.stringValue = currentMoodLabelContents.replacingOccurrences(of: baseMoodsOptions[index], with: selection)
                    return
                }
            }
            currentMoodLabel.stringValue += " " + selection
            // Location of the option "--"
            baseMoods.removeItem(at: 0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        buildPopUpButtons()
    }
    
    func buildPopUpButtons() {
        moodModifiers.removeAllItems()
        baseMoods.removeAllItems()
        moodModifiers.addItems(withTitles: moodModifiersOptions)
        baseMoods.addItems(withTitles: baseMoodsOptions)
    }
    
    func executeReportMoodRequest(mood: String) {
        let currentDateTime = Int(Date().timeIntervalSince1970)
        let domain = MoodProveHTTP.moodProveDomain
        _ = MoodProveHTTP.getRequest(urlRequest: domain + "/predicted/checkIn?userid=\(userId!)&timestamp=\(currentDateTime)&mood=\(mood)")
        self.view.window?.close()
    }
    
}
