//
//  ViewController.swift
//  ToDoApp
//
//  Created by Florin Ionita on 1/3/18.
//  Copyright © 2018 mobile. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class AuthenticationViewController: UIViewController, GIDSignInUIDelegate {
        
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        GIDSignIn.sharedInstance().uiDelegate = self
        ActivityIndicatorManager.show(true)
        GIDSignIn.sharedInstance().signInSilently()
    }
    
}

