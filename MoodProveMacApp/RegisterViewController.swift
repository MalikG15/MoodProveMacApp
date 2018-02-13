//
//  RegisterViewController.swift
//  MoodProve
//
//  Created by Malik Graham on 2/10/18.
//  Copyright © 2018 Malik Graham. All rights reserved.
//

import Cocoa

class RegisterViewController: NSViewController {

    @IBOutlet weak var name: NSTextField!
    
    @IBOutlet weak var email: NSTextField!
    
    @IBOutlet weak var password: NSSecureTextField!
    
    @IBOutlet weak var passwordConfirmation: NSSecureTextField!
    
    @IBOutlet weak var wakeUpTime: NSPopUpButton!
    
    @IBAction func register(_ sender: Any) {
        
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        if let subView = view.window?.windowController as? SubWindowController {
            subView.moveToLogin()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
