//
//  ViewController.swift
//  new-pompeius
//
//  Created by Denis Tatar on 2020-08-27.
//  Copyright © 2020 Denis Tatar. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class ViewController: UIViewController {

    @IBOutlet var googleSignInButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Initiating our textfields
        usernameField.delegate = self
        passwordField.delegate = self
        
        // Telling our view controller that this is where we want the option of signing in with Google to appear
        GIDSignIn.sharedInstance()?.presentingViewController = self;
        
    }

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func loginButton(_ sender: Any) {
        /*
        Auth.auth().signIn(withEmail: usernameField, password: passwordField) { (result, error) in
            if error != nil {
                // self.alertMessage = error?.localize
            }*/
        }
    @IBAction func loginGoogleButton(_ sender: Any) {
    }
    
    @IBAction func registerHereButton(_ sender: Any) {
        self.performSegue(withIdentifier: "toRegister", sender: self)
    }
    
    // Touch outside of text to dismiss keyboard (you can also hit "return")
    // https://www.youtube.com/watch?v=uVCFV668dSQ
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            usernameField.resignFirstResponder()
            passwordField.resignFirstResponder()
    }
    
    
}

// Helping with dismissing our keyboard through a tap
// https://www.youtube.com/watch?v=uVCFV668dSQ
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Getting rid of the actual keyboard
        textField.resignFirstResponder()
        return true
    }
}
