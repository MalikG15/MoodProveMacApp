//
//  MainWindow.swift
//  MoodProve
//
//  Created by Malik Graham on 1/4/18.
//  Copyright © 2018 Malik Graham. All rights reserved.
//

import Cocoa

class MainWindow: NSWindowController {

    @IBOutlet weak var mainWindow: NSWindow!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        if let screen = NSScreen.main() {
            mainWindow.setFrame(screen.visibleFrame, display: true, animate: true)
        }
    }

}
