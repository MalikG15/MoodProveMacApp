//
//  RegisterViewController.swift
//  MoodProve
//
//  Created by Malik Graham on 2/10/18.
//  Copyright © 2018 Malik Graham. All rights reserved.
//

import Cocoa

class RegisterViewController: NSViewController {
    
    let options = ["4:00 AM", "5:00 AM", "6:00 AM", "7:00 AM", "8:00 AM", "9:00 AM", "10:00 AM"]

    @IBOutlet weak var name: NSTextField!
    
    @IBOutlet weak var email: NSTextField!
    
    @IBOutlet weak var password: NSSecureTextField!
    
    @IBOutlet weak var passwordConfirmation: NSSecureTextField!
    
    @IBOutlet weak var wakeUpTime: NSPopUpButton!
    
    @IBOutlet weak var warning: NSTextField!
    
    @IBAction func wakeUpButtonSelected(_ sender: Any) {
        print(wakeUpTime.titleOfSelectedItem!)
    }
    
    
    @IBAction func register(_ sender: Any) {
        if (name.stringValue.isEmpty || email.stringValue.isEmpty
            || password.stringValue.isEmpty || passwordConfirmation.stringValue.isEmpty) {
            warning.isHidden = false
            warning.stringValue = "You left required input fields empty!"
            return
        }
        else if (password != passwordConfirmation) {
            warning.isHidden = false
            warning.stringValue = "Your passwords do not match!"
            return
        }
        warning.isHidden = true
        handleRegistration(name: name.stringValue, email: email.stringValue, password: password.stringValue, wakeUpTime: wakeUpTime.titleOfSelectedItem!)
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        if let subView = view.window?.windowController as? SubWindowController {
            subView.moveToLogin()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        warning.isHidden = true
        buildWakeUpTimeButton()
    }
    
    func buildWakeUpTimeButton() {
        wakeUpTime.removeAllItems()
        wakeUpTime.addItems(withTitles: options)
    }
    
    func handleRegistration(name: String, email: String, password: String, wakeUpTime: String) {
        print("Handling registration")
    }
    
}
