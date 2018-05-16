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
