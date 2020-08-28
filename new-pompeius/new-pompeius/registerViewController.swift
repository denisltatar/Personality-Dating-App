//
//  registerViewController.swift
//  new-pompeius
//
//  Created by Denis Tatar on 2020-08-27.
//  Copyright © 2020 Denis Tatar. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class registerViewController: UIViewController {
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Hid the error label
        errorLabel.alpha = 0
        
        // Initializing our data fields
        // usernameField.delegate = self
        firstNameField.delegate = self
        lastNameField.delegate = self
        passwordField.delegate = self
        emailField.delegate = self
    }
        
    // Check the fields and validate that the data is correct. If everything
    // if correct, this function returns nil, otherwise it returns the error message
    func validateFields() -> String? {
        // Check that all fields are filled in!
        if firstNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == " " ||
            lastNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == " " ||
            passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == " " ||
            emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == " " {
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
    
    
    @IBAction func registerButton(_ sender: Any) {
        // Validate the fields entered
        let error = validateFields()
        
        if error != nil {
             // There is an error, show the error message
            showError(error!)
        } else {
            // Create cleaned versions of the data
            // let username = usernameField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let firstName = firstNameField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            
            // Create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                // Check for errors
                if err != nil {
                    // There was an error in creating the user
                    self.showError("Email has been used already")
                } else {
                    // User was created successfully, store the information properly
                    let db = Firestore.firestore()
                    
                    db.collection("users").addDocument(data: ["firstName" : firstName, "lastName" : lastName, "uid" :  result!.user.uid]) { (error) in
                        
                        if error != nil {
                            self.showError("User's name could not be uploaded to database")
                        }
                    }
                    
                    
                    // Transition to the "my profile" view controller
                    self.transitionToNextView()
                }
            }
        }
    }
    
    
    // Function used to show the error message if one exists
    func showError (_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToNextView() {
        // Creating a reference to "myProfileViewController" within our storyboard
        let  myProfileViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.myProfileViewController) as? MyProfileViewController
        
        // Swap out the root view controller
        view.window?.rootViewController = myProfileViewController
        view.window?.makeKeyAndVisible()
    }
    
    
    
    @IBAction func registerWithGoogleButton(_ sender: Any) {
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.performSegue(withIdentifier: "toLogin", sender: self)
    }
    
    // Touch outside of text to dismiss keyboard (you can also hit "return")
    // https://www.youtube.com/watch?v=uVCFV668dSQ
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            // usernameField.resignFirstResponder()
            firstNameField.resignFirstResponder()
            lastNameField.resignFirstResponder()
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

