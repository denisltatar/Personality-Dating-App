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
import FirebaseStorage

class MyProfileViewController: UIViewController {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var occupationTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var countryOriginTextField: UITextField!
    @IBOutlet weak var countryRaisedTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    // Creating our reference which we'll need to grab data from current user
    // var ref: DatabaseReference?
    var usersRef: DatabaseReference?
    
    // Used for moving data over userDocId to be specific
    var currentUserDocId:String = ""
    
    @IBOutlet weak var textLabel: UILabel?
    
    
    // Creating a variable to store the profile image selected by the user
    var image: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupAvatar()
        
        // Hidding the error label
        errorLabel.alpha = 0
        
        occupationTextField.delegate = self
        ageTextField.delegate = self
        heightTextField.delegate = self
        genderTextField.delegate = self
        countryOriginTextField.delegate = self
        countryRaisedTextField.delegate = self

        // ref = Database.database().reference()
        usersRef = Database.database().reference().child("users")
        
        // Used for moving over data from 'registerViewController' and into a textLabel
        // textLabel?.text = currentUserDocId
    
        
    }
    
    // Function used to show the error message if one exists
    func showError (_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    // Check if any fields were empty
    func validateFields() -> String? {
        // Check that all fields are filled in!
        if occupationTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == " " ||
            ageTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == " " ||
            heightTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == " " ||
            genderTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == " " ||
            countryOriginTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == " " ||
            countryRaisedTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == " " {
            return "Please fill in all fields."
        }
        
        return nil
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        self.performSegue(withIdentifier: "backToRegister", sender: self)
    }
    
    // Function that helps set up our user's profile picture (also known as an avatar)
    // https://www.youtube.com/watch?v=0MrJFBGVuk4&ab_channel=Zero2Launch
    func setupAvatar() {
        avatar.layer.cornerRadius = 40
        avatar.clipsToBounds = true
        avatar.isUserInteractionEnabled = true
        // self is MyProfileViewController itself
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
        avatar.addGestureRecognizer(tapGesture)
    }
    
    // https://www.youtube.com/watch?v=0MrJFBGVuk4&ab_channel=Zero2Launch
    @objc func presentPicker() {
        let picker = UIImagePickerController()
        // Opens up our photo library
        picker.sourceType = .photoLibrary
        // Allow the user to edit the selected photo
        picker.allowsEditing = true
        //
        picker.delegate = self
        // self.present(picker, animated: true, completion: nil)
        self.present(picker, animated: true, completion: nil)
    }
    
    
    @IBAction func continueButton(_ sender: Any) {
        
        // Sending our profile image to Firestore
        guard let imageSelected = self.image else {
            print("Avatar is nil")
            return
        }
        
        // Saving our image into specific data type (jpeg data type)
        guard let imageData = imageSelected.jpegData(compressionQuality: 0.4) else {
            return
        }
        
        // Validate the fields entered
        let error = validateFields()
    
        if error != nil {
             // There is an error, show the error message
            showError(error!)
        } else {
            // Create cleaned versions of the data
            let occupation = occupationTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let age = ageTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let height = heightTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let gender = genderTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let countryOrigin = countryOriginTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let countryRaised = countryRaisedTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                        
            // Grabbing the current user's data
            let user = Auth.auth().currentUser
            
            
            
            
            // Checking if the current user is still logged in
            // TODO: Finish the else case here!!
            if user != nil {
                // User is signed in.
                // For testing
                print("We are about to update Firebase with the occupation: " + occupation)
                print("Second View Controller User Doc ID: " + self.currentUserDocId)
                
                
                // Creating a dictionary to upload all at once
                var userDictData: [String: Any] = [
                    "occupation" : occupation,
                    "age" : age,
                    "height" : height,
                    "gender" : gender,
                    "country of origin" : countryOrigin,
                    "country raised in" : countryRaised,
                    "profileImageUrl" : ""
                ]
                
                
                // UPLOADING OUR PROFILE IMAGE AND DATA AT ONCE
                // Making a reference to our root
                let storageRef = Storage.storage().reference(forURL: "gs://pompeius-e4abd.appspot.com")
                
                // Creating a node of all profile photos
                let uid = user!.uid
                let storageProfileRef = storageRef.child("profiles").child(uid)
                
                // Create file metadata including the content type
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpg"
                storageProfileRef.putData(imageData, metadata: metadata) { (storageMetaData, error) in
                    if error != nil {
                        // Print out our error message
                        print(error?.localizedDescription)
                        return
                    }
                    
                    // Saving the profile link to add to our current user
                    storageProfileRef.downloadURL { (url, error) in
                        if let metaImageUrl = url?.absoluteString {
                            // Adding this new URL to our user's dictionary of data
                            userDictData["profileImageUrl"] = metaImageUrl
                            
                            // Accessing the database
                            let db = Firestore.firestore()
                            
                            // Uploading data to our database
                            db.collection("users").document("new").setData(userDictData, merge: true)
                        }
                    }
                    
                }
                
                
                
                
                // UPLOADING OUR PROFILE DATA
                // Accessing the database
  //              let db = Firestore.firestore()
                
                // Getting the current user's document ID so we can add fields to their data
            //    let currDoc = db.collection("users").document()
            //    let strNewDocument = db.collection("users").document().documentID
            //    print("strNewDocument is: " + strNewDocument)
                
                
                // Assessing the current user's data so that we can add to it.
                // let userRef = rootRef.child("users").child(user.uid)
                // Grabbing the path of the current user so we can add to it!
                // let userRef = Database.database().reference().child("users").child(user.uid)
                
                // Adding to the user's UID
                // self.db.child("users").child(user!.uid).setValue(["occupation": occupation])
                
                // Grabbing the current +user's document value (from 'registerViewController')
                // let userDocId = db.collection("users").document().documentID
    
                // db.collection("users").document(userDocId).updateData(["occupation" : occupation])
                
                // If the document does not exist, it will be created. If the document does exist, its contents will be overwritten
                // with the newly provided data, unless you specify that the data should be merged into the existing document, as follows:
                
                // OLD METHOD
                // db.collection("users").document(userDocId).setData(["occupation" : occupation], merge: true)
                
                
                // NEW METHOD
             //   currDoc.setData(["occupation" : occupation], merge: true)
                
    //            db.collection("users").document("new").setData(["occupation" : occupation, "age" : age, "height" : height,
    //                                                            "gender" : gender, "country of origin" : countryOrigin, "country raised in" : countryRaised,
    //                                                            "profileImageUrl" : metaImageUrl], merge: true)
                
                
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
            self.performSegue(withIdentifier: "continueProfile", sender: self)
        }
    }
    
    
    
    
    
    // Touch outside of text to dismiss keyboard (you can also hit "return")
    // https://www.youtube.com/watch?v=uVCFV668dSQ
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            // usernameField.resignFirstResponder()
            occupationTextField.resignFirstResponder()
            ageTextField.resignFirstResponder()
            heightTextField.resignFirstResponder()
            genderTextField.resignFirstResponder()
            countryOriginTextField.resignFirstResponder()
            countryRaisedTextField.resignFirstResponder()
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



// Saving the photo we picked from the photo library within our phone
// https://www.youtube.com/watch?v=0MrJFBGVuk4&ab_channel=Zero2Launch
extension MyProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Displaying the photo on the UIImageView
        // We're basically saving the photo chosen to display in our little circle
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            // Saving the chosen image to the image variable we created
            image = imageSelected
            // Displaying the image that was selected in the profile section circle
            avatar.image = imageSelected
        }
        
        /*
        if let imageOriginal = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            // Saving the chosen image to the image variable we created
            image = imageSelected
            avatar.image = imageOriginal
        } */
        
        picker.dismiss(animated: true, completion: nil)
        
    }
}
