//
//  MyProfile2ViewController.swift
//  new-pompeius
//
//  Created by Denis Tatar on 2020-09-02.
//  Copyright © 2020 Denis Tatar. All rights reserved.
//

import UIKit
import Firebase

class MyProfile2ViewController: UIViewController {

    @IBOutlet weak var currentResidenceTextField: UITextField!
    @IBOutlet weak var employmentTextField: UITextField!
    @IBOutlet weak var religiousnessTextField: UITextField!
    @IBOutlet weak var citizenshipTextField: UITextField!
    @IBOutlet weak var preferenceTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Hidding the error label
        errorLabel.alpha = 0
        
        // Initializing our textfields
        currentResidenceTextField.delegate = self
        employmentTextField.delegate = self
        religiousnessTextField.delegate = self
        citizenshipTextField.delegate = self
        preferenceTextField.delegate = self
        
    }
    
    // Function used to show the error message if one exists
    func showError (_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.performSegue(withIdentifier: "backToProfile", sender: self)
    }
    
    // Check if any fields were empty
    func validateFields() -> String? {
        // Check that all fields are filled in!
        if currentResidenceTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == " " ||
            employmentTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == " " ||
            religiousnessTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == " " ||
            citizenshipTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == " " ||
            preferenceTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == " " {
            return "Please fill in all fields."
        }
        
        return nil
    }
    
    @IBAction func continueButton(_ sender: Any) {
        // Validate the fields entered
        let error = validateFields()
        
        if error != nil {
             // There is an error, show the error message
            showError(error!)
        } else {
            // Create cleaned versions of the data
            let currentResidence = currentResidenceTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let employment = employmentTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let religion = religiousnessTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let citizenship = citizenshipTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let agePreference = preferenceTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                        
            // Grabbing the current user's data
            let user = Auth.auth().currentUser
            
            
            // Checking if the current user is still logged in
            // TODO: Finish the else case here!!
            if user != nil {
                // User is signed in.
                // Accessing the database
                let db = Firestore.firestore()
                
                // Adding more data to the current user's data
                db.collection("users").document("new").setData(["current residence" : currentResidence, "employment" : employment, "religion standard" : religion, "citizenship" : citizenship, "age preference" : agePreference], merge: true)
            }
            
            // Transitioning to the next view controller
            self.performSegue(withIdentifier: "toSurveyIntro", sender: self)
    }
}
    
    
    
    
    // Touch outside of text to dismiss keyboard (you can also hit "return")
    // https://www.youtube.com/watch?v=uVCFV668dSQ
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            // usernameField.resignFirstResponder()
            currentResidenceTextField.resignFirstResponder()
            employmentTextField.resignFirstResponder()
            religiousnessTextField.resignFirstResponder()
            citizenshipTextField.resignFirstResponder()
            preferenceTextField.resignFirstResponder()
        }
    
}



// Helping with dismissing our keyboard through a tap
// https://www.youtube.com/watch?v=uVCFV668dSQ
extension MyProfile2ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Getting rid of the actual keyboard
        textField.resignFirstResponder()
        return true
    }
}

