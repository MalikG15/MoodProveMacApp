//
//  SubWindowController.swift
//  MoodProve
//
//  Created by Malik Graham on 2/10/18.
//  Copyright © 2018 Malik Graham. All rights reserved.
//

import Cocoa

class SubWindowController: NSWindowController {

    @IBOutlet weak var subView: NSWindow!
    
    var registerVC: RegisterViewController?
    var loginVC: LoginViewController?
    
    override func windowDidLoad() {
        super.windowDidLoad()
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        /*var windowFrame = window?.frame
        windowFrame!.size = NSMakeSize(500, 300)
        window?.setFrame(windowFrame!, display: true)*/
        self.window?.setContentSize(NSSize.init(width: 500, height: 300))
        loginVC = contentViewController as? LoginViewController
    }
    
    func moveToRegister() {
        if registerVC == nil {
            registerVC = storyboard?.instantiateController(withIdentifier: "registerVC") as? RegisterViewController
        }
        var windowFrame = window?.frame
        windowFrame!.size = NSMakeSize(500, 450)
        window?.setFrame(windowFrame!, display: true)
        window?.contentView = registerVC?.view
    }
    
    func moveToLogin() {
        var windowFrame = window?.frame
        windowFrame!.size = NSMakeSize(500, 300)
        window?.setFrame(windowFrame!, display: true)
        window?.contentView = loginVC?.view
    }
    
}
