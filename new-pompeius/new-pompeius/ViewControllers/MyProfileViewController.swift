//
//  MyProfileViewController.swift
//  new-pompeius
//
//  Created by Denis Tatar on 2020-08-28.
//  Copyright © 2020 Denis Tatar. All rights reserved.
//

import UIKit
import Firebase

class MyProfileViewController: UIViewController {

    @IBOutlet weak var occupationTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Hidding the error label
        errorLabel.alpha = 0
    }
    
    // Function used to show the error message if one exists
    func showError (_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    // Check if occupation was empty
    func validateFields() -> String? {
        // Check that all fields are filled in!
        if occupationTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == " " {
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
            // let username = usernameField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let occupation = occupationTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                        
            // Grabbing the current user's data
            let user = Auth.auth().currentUser
            
            // Checking if the current user is still logged in
            // TODO: Finish the else case here!!
            if user != nil {
                // User is signed in.
                // Accessing the database
                let db = Firestore.firestore()
                
                // db.collection("users").getDocuments(completion: <#T##FIRQuerySnapshotBlock##FIRQuerySnapshotBlock##(QuerySnapshot?, Error?) -> Void#>)
                
                // Adding more information to that current user!
                db.collection("users").addDocument(data: ["occupation" : occupation]) { (error) in
                                       
                    if error != nil {
                        self.showError("User's name could not be uploaded to database")
                    }
                }
                
              
            }
            
            // Transition to the "my profile" view controller
            // self.transitionToNextView()
        }
    }
    
    
    
    
    
}
