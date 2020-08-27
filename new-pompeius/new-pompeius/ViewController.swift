//
//  ViewController.swift
//  new-pompeius
//
//  Created by Denis Tatar on 2020-08-27.
//  Copyright © 2020 Denis Tatar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func loginButton(_ sender: Any) {
    }
    @IBAction func loginGoogleButton(_ sender: Any) {
    }
    @IBAction func registerHereButton(_ sender: Any) {
        print("Here was tapped")
    }
}

