//
//  SurveyIntroductionViewController.swift
//  new-pompeius
//
//  Created by Denis Tatar on 2020-09-02.
//  Copyright © 2020 Denis Tatar. All rights reserved.
//

import UIKit
import Firebase

class SurveyIntroductionViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    @IBAction func backButton(_ sender: Any) {
        self.performSegue(withIdentifier: "backButtonSeg", sender: self)
    }
    
    @IBAction func beginSurveyButton(_ sender: Any) {
    }
}
