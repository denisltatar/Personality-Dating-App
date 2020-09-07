//
//  Q2ViewController.swift
//  new-pompeius
//
//  Created by Denis Tatar on 2020-09-06.
//  Copyright © 2020 Denis Tatar. All rights reserved.
//

import UIKit
import Firebase

class Q2ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.performSegue(withIdentifier: "backToQ1Set", sender: self)
    }
    
    @IBAction func continueButton(_ sender: Any) {
    }
}
