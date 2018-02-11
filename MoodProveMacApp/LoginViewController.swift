//
//  LoginViewController.swift
//  MoodProve
//
//  Created by Malik Graham on 2/10/18.
//  Copyright © 2018 Malik Graham. All rights reserved.
//

import Cocoa

class LoginViewController: NSViewController {

    @IBAction func Transition(_ sender: Any) {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let controller: NSViewController = storyboard.instantiateController(withIdentifier: "OAuthResponseView") as! NSViewController
        let window = NSApp.windows[0]
        window.contentViewController = controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
