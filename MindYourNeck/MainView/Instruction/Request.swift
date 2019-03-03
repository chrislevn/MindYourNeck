//
//  Request.swift
//  MindYourNeck
//
//  Created by Hong Loc on 9/15/18.
//  Copyright © 2018 Hong Loc. All rights reserved.
//

import UIKit
import MessageUI

class Request: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var webName: UITextField!
    @IBOutlet weak var webURL: UITextField!
    @IBOutlet weak var webSubject: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendButton.layer.cornerRadius = 4
        
        self.navigationItem.title = "Request Page"
    }
    
    @IBAction func send(_ sender: Any) {
        let toRecipeients = ["locvicvn1234@gmail.com"]
        
        let mc: MFMailComposeViewController = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        
        mc.setToRecipients(toRecipeients)
        mc.setSubject("MYN Website Request - \(webName.text!)")
        
        mc.setMessageBody("Website's name: \(webName.text!) \nWebsite's link: \(webURL.text!) \n\nWebsite's subject: \(webSubject.text!)" , isHTML: false)
        
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
    
    @IBAction func dissmissKeyBoard(_ sender: Any) {
        self.resignFirstResponder()
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
