//
//  LoginViewController.swift
//  MoodProve
//
//  Created by Malik Graham on 2/10/18.
//  Copyright © 2018 Malik Graham. All rights reserved.
//

import Cocoa
import SwiftyJSON

class LoginViewController: NSViewController {

    @IBOutlet weak var password: NSSecureTextField!
    @IBOutlet weak var email: NSTextField!
    
    var openMain: NSWindow?
    
    
    @IBAction func login(_ sender: Any) {
        let emailText = email.stringValue
        let passwordText = password.stringValue
        if (emailText.isEmpty || passwordText.isEmpty) {
            return
        }
        let _ = MoodProveHTTP.moodProveDomain
        let path = "/user/login?email=\(emailText)&password=\(passwordText)"
        let res = MoodProveHTTP.getRequest(urlRequest: MoodProveHTTP.moodProveDomain + path)
        
        handleLoginRequest(json: res)
    }
    
    @IBAction func registerClicked(_ sender: Any) {
        if let subView = view.window?.windowController as? SubWindowController {
            subView.moveToRegister()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    func handleLoginRequest(json: JSON) {
        if (json == JSON.null || json["response"].stringValue == "Invalid Credentials") {
            print("Invalid Credentials")
            return
        }
        
        let storyboard = NSStoryboard(name: "Main",bundle: nil)
        let mainViewController: MainViewController = storyboard.instantiateController(withIdentifier: "mainView") as! MainViewController
        mainViewController.userId = json["userid"].stringValue
        mainViewController.name = json["name"].stringValue
        openMain = NSWindow(contentViewController: mainViewController)
        openMain?.makeKeyAndOrderFront(self)
        let vc = NSWindowController(window: openMain)
        vc.showWindow(self)
        self.view.window?.close()
        
    }
    
}
