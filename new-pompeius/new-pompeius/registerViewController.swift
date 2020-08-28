//
//  registerViewController.swift
//  new-pompeius
//
//  Created by Denis Tatar on 2020-08-27.
//  Copyright © 2020 Denis Tatar. All rights reserved.
//

import UIKit
import Firebase

class registerViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Initializing our data fields
        usernameField.delegate = self
        passwordField.delegate = self
        emailField.delegate = self
    }

    @IBAction func registerButton(_ sender: Any) {
    }
    @IBAction func registerWithGoogleButton(_ sender: Any) {
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.performSegue(withIdentifier: "toLogin", sender: self)
    }
    
    // Touch outside of text to dismiss keyboard (you can also hit "return")
    // https://www.youtube.com/watch?v=uVCFV668dSQ
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            usernameField.resignFirstResponder()
            passwordField.resignFirstResponder()
            emailField.resignFirstResponder()
    }
}

// Helping with dismissing our keyboard through a tap
// https://www.youtube.com/watch?v=uVCFV668dSQ
extension registerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Getting rid of the actual keyboard
        textField.resignFirstResponder()
        return true
    }
}

