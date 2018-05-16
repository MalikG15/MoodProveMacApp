//
//  ReportMoodViewController.swift
//  MoodProve
//
//  Created by Malik Graham on 5/15/18.
//  Copyright © 2018 Malik Graham. All rights reserved.
//

import Cocoa

class ReportMoodViewController: NSViewController {
    
    var userId: String?
    
    let moodModifiersOptions = ["--", "anxious", "calm", "confused", "overwhelmingly"]
    
    let baseMoodsOptions = ["--", "happy", "mad", "neutral", "sad", "stressed"]

    @IBOutlet weak var moodModifiers: NSPopUpButton!
    
    @IBOutlet weak var baseMoods: NSPopUpButton!
    
    @IBOutlet weak var currentMoodLabel: NSTextField!
    
    @IBAction func reportMood(_ sender: Any) {
        
    }
    
    @IBAction func tapModifiers(_ sender: Any) {
        let selection = moodModifiers.titleOfSelectedItem!
        if (selection != "--") {
            let currentMoodLabelContents = currentMoodLabel.stringValue
            for index in 0..<moodModifiersOptions.count {
                if ((currentMoodLabelContents.range(of: moodModifiersOptions[index])) != nil) {
                    currentMoodLabel.stringValue = currentMoodLabelContents.replacingOccurrences(of: moodModifiersOptions[index], with: selection)
                    return
                }
            }
            currentMoodLabel.stringValue += " " + selection
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
    
}
