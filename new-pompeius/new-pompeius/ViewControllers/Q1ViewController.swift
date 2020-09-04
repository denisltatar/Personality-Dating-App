//
//  Q1ViewController.swift
//  new-pompeius
//
//  Created by Denis Tatar on 2020-09-04.
//  Copyright © 2020 Denis Tatar. All rights reserved.
//

import UIKit
import Firebase

class Q1ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    @IBAction func backButton(_ sender: Any) {
        self.performSegue(withIdentifier: "backToBeginSurvery", sender: self)
    }
    
    @IBAction func continueButton(_ sender: Any) {
    }
    
}
