//
//  MyProfileViewController.swift
//  new-pompeius
//
//  Created by Denis Tatar on 2020-08-28.
//  Copyright © 2020 Denis Tatar. All rights reserved.
//

import UIKit
import Firebase
// import FirebaseDatabase

class MyProfileViewController: UIViewController {

    @IBOutlet weak var occupationTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    // Creating our reference which we'll need to grab data from current user
    // var ref: DatabaseReference?
    var usersRef: DatabaseReference?
    
    // Used for moving data over userDocId to be specific
    var currentUserDocId:String = ""
    @IBOutlet weak var textLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Hidding the error label
        errorLabel.alpha = 0
        
        occupationTextField.delegate = self

        // ref = Database.database().reference()
        usersRef = Database.database().reference().child("users")
        
        // Used for moving over data from 'registerViewController'
        textLabel?.text = currentUserDocId
        
        print("String value of currentUserDocId:" + currentUserDocId)
        
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
            let occupation = occupationTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                        
            // Grabbing the current user's data
            let user = Auth.auth().currentUser
            
            // Accessing the user's UID
            // let uid = user!.uid
            
            
            // Checking if the current user is still logged in
            // TODO: Finish the else case here!!
            if user != nil {
                // User is signed in.
                
                // var reference: DatabaseReference?
                print("We are about to update Firebase with the occupation: " + occupation)
                // usersRef?.child(uid).setValue(["occupation" : occupation])
                
                
                
                
                // Accessing the database
                let db = Firestore.firestore()
                
                
                
                
                // Assessing the current user's data so that we can add to it.
                // let userRef = rootRef.child("users").child(user.uid)
                // Grabbing the path of the current user so we can add to it!
                // let userRef = Database.database().reference().child("users").child(user.uid)
                
                // Adding to the user's UID
                // self.db.child("users").child(user!.uid).setValue(["occupation": occupation])
                
                // Grabbing the current user's document value (from 'registerViewController')
                // let userDocId = db.collection("users").document().documentID
    
                print("currentUserDocId is: " + currentUserDocId)
                // db.collection("users").document(userDocId).updateData(["occupation" : occupation])
                
                // If the document does not exist, it will be created. If the document does exist, its contents will be overwritten
                // with the newly provided data, unless you specify that the data should be merged into the existing document, as follows:
                db.collection("users").document(currentUserDocId).setData(["occupation" : occupation], merge: true)
                
                // db.collection("users").getDocuments(completion: <#T##FIRQuerySnapshotBlock##FIRQuerySnapshotBlock##(QuerySnapshot?, Error?) -> Void#>)
                /*
                // Adding more information to that current user!
                db.collection(userRef).addDocument(data: ["occupation" : occupation]) { (error) in
                                       
                    if error != nil {
                        self.showError("User's name could not be uploaded to database")
                    }
                } */
                
              
            }
            
            // Transition to the "my profile" view controller
            // self.transitionToNextView()
        }
    }
    
    
    
    
    
    // Touch outside of text to dismiss keyboard (you can also hit "return")
    // https://www.youtube.com/watch?v=uVCFV668dSQ
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            // usernameField.resignFirstResponder()
            occupationTextField.resignFirstResponder()
    }
}


// Helping with dismissing our keyboard through a tap
// https://www.youtube.com/watch?v=uVCFV668dSQ
extension MyProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Getting rid of the actual keyboard
        textField.resignFirstResponder()
        return true
    }
}

