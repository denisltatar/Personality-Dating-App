//
//  ViewController.swift
//  new-pompeius
//
//  Created by Denis Tatar on 2020-08-27.
//  Copyright © 2020 Denis Tatar. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class ViewController: UIViewController {

    @IBOutlet var googleSignInButton: GIDSignInButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Hid the error label
        errorLabel.alpha = 0
        
        // GIDSignIn.sharedInstance().signInSilently()
        
        /*
        // Checking if the user actually signed in
        if GIDSignIn.sharedInstance()?.currentUser != nil {
            self.performSegue(withIdentifier: "toMessages", sender: self)
        } */
        
        // Initiating our textfields
        emailField.delegate = self
        passwordField.delegate = self
        
        // Telling our view controller that this is where we want the option of signing in with Google to appear
        GIDSignIn.sharedInstance()?.presentingViewController = self;
        
        
        // New Real-time Data Method
        // let ref = Database.database().reference()
        
        // ref.childByAutoId().setValue(["email" :emailField, "password" : passwordField])
        
    }
    
    // Check the fields and validate that the data is correct. If everything
    // if correct, this function returns nil, otherwise it returns the error message
    func validateFields() -> String? {
        // Check that all fields are filled in!
        if emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == " " ||
            passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == " " {
            return "Please fill in all fields."
        }
        
        // Saving the password into a string
        let cleanedPassword = passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        // Check if the password is secure
        if Utilities.isPasswordValid(cleanedPassword) == false {
            // Password is not secured enough
            return "Password must contain 8 charaters, a special character and a number."
        }
        return nil
    }
    
    
    
    @IBAction func loginButton(_ sender: Any) {
        // TODO: Validate Text Fields
        let error = validateFields()
        
        // Create cleaned versions of the text field
        let email = emailField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Signing in the user
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                // Couldn't login
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            } else {
                // Login successful!
                // Transition to the "my profile" view controller
                // TODO: CHANGE THE LOCATION OF THE NEXT VIEW CONTROLLER!
                self.transitionToNextView()
            }
        }
    }
    
    func transitionToNextView() {
        // Creating a reference to "myProfileViewController" within our storyboard
        let messagingViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.messagingViewController) as? MessagingViewController
        
        // Swap out the root view controller
        view.window?.rootViewController = messagingViewController
        view.window?.makeKeyAndVisible()
    }
    
    @IBAction func loginGoogleButton(_ sender: Any) {
    }
    
    @IBAction func registerHereButton(_ sender: Any) {
        self.performSegue(withIdentifier: "toRegister", sender: self)
    }
    
    // Touch outside of text to dismiss keyboard (you can also hit "return")
    // https://www.youtube.com/watch?v=uVCFV668dSQ
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            emailField.resignFirstResponder()
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
