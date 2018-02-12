//
//  RegisterViewController.swift
//  MoodProve
//
//  Created by Malik Graham on 2/10/18.
//  Copyright © 2018 Malik Graham. All rights reserved.
//

import Cocoa

class RegisterViewController: NSViewController {

    @IBAction func loginClicked(_ sender: Any) {
        if let subView = view.window?.windowController as? SubWindowController {
            subView.moveToLogin()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        //self.view.window?.setFrame(NSRect(x:0,y:0,width:1000,height:300), display: true)
    }
    
}
