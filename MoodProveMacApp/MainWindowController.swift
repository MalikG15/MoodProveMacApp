//
//  MainWindow.swift
//  MoodProve
//
//  Created by Malik Graham on 1/4/18.
//  Copyright © 2018 Malik Graham. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {

    @IBOutlet weak var mainWindow: NSWindow!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        self.window?.setContentSize(NSSize.init(width: 1920, height: 1080))
    }

}
