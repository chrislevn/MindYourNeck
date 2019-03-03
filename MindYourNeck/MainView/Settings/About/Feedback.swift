//
//  Feedback.swift
//  MindYourNeck
//
//  Created by Hong Loc on 9/13/18.
//  Copyright © 2018 Hong Loc. All rights reserved.
//

import UIKit
import MessageUI

class Feedback: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var messageField: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.navigationItem.title = "Feedback"
        sendButton.layer.cornerRadius = 4
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
    self.resignFirstResponder()
    }
    
    
    @IBAction func send(_ sender: Any) {
        let toRecipeients = ["locvicvn1234@gmail.com"]
        
        let mc: MFMailComposeViewController = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        
        mc.setToRecipients(toRecipeients)
        mc.setSubject("MYN Feedback - Customer's name: \(nameField.text!)")
        
        mc.setMessageBody("Name: \(nameField.text!) \nMessage: \(messageField.text!)" , isHTML: false)
        
        self.present(mc, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            print("Cancelled")
        case MFMailComposeResult.failed.rawValue:
            print("Failed")
        case MFMailComposeResult.saved.rawValue:
            print("Saved")
        case MFMailComposeResult.sent.rawValue:
            print("Sent")
        default:
            break
        }
        self.dismiss(animated: true, completion: nil)
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
