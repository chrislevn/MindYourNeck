//
//  CustomAlert.swift
//  MindYourNeck
//
//  Created by Hong Loc on 9/19/18.
//  Copyright © 2018 Hong Loc. All rights reserved.
//

import UIKit

class CustomAlert: UIViewController {

    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var alertContent: UITextView!
    @IBOutlet weak var alertImage: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
     
    }
    
override func viewDidLoad() {
        super.viewDidLoad()
        closeButton.layer.cornerRadius = 4
        popUpView.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
