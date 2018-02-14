//
//  RegisterViewController.swift
//  MoodProve
//
//  Created by Malik Graham on 2/10/18.
//  Copyright © 2018 Malik Graham. All rights reserved.
//

import Cocoa
import SwiftyJSON

class RegisterViewController: NSViewController {
    
    var openMain: NSWindow?
    
    let options = ["4:00", "5:00", "6:00", "7:00", "8:00", "9:00", "10:00", "12:00"]

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
        else if (password.stringValue != passwordConfirmation.stringValue) {
            warning.isHidden = false
            warning.stringValue = "Your passwords do not match!"
            password.stringValue = ""
            password.stringValue = ""
            return
        }
        warning.isHidden = true
        
        let path = "/user/add?name=\(name.stringValue)&email=\(email.stringValue)&password=\(password.stringValue)&timeOfCheckIn=\(wakeUpTime.titleOfSelectedItem!)"
        print(MoodProveHTTP.moodProveDomain + path)
        let res = MoodProveHTTP.getRequest(urlRequest: MoodProveHTTP.moodProveDomain + path)
        handleRegistration(json: res, name: name.stringValue)
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
    
    func handleRegistration(json: JSON, name: String) {
        if (json == JSON.null) {
            return
        }
        
        let storyboard = NSStoryboard(name: "Main",bundle: nil)
        let mainViewController: MainViewController = storyboard.instantiateController(withIdentifier: "mainView") as! MainViewController
        mainViewController.userId = json["result"].stringValue
        mainViewController.name = name
        mainViewController.newUser = true
        openMain = NSWindow(contentViewController: mainViewController)
        openMain?.makeKeyAndOrderFront(self)
        let vc = NSWindowController(window: openMain)
        vc.showWindow(self)
        self.view.window?.close()
    }
    
}
