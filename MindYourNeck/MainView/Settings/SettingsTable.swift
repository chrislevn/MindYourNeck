//
//  SettingsTable.swift
//  MindYourNeck
//
//  Created by Hong Loc on 9/13/18.
//  Copyright © 2018 Hong Loc. All rights reserved.
//

import UIKit
import GoogleMobileAds
import StoreKit


class SettingsTable: UITableViewController, GADBannerViewDelegate {
    
   
    @IBOutlet weak var RatingCell: UITableViewCell!
    @IBOutlet weak var generalTableViewCell: UITableViewCell!
    @IBOutlet weak var generalContentView: UIView!
    @IBOutlet weak var selectedSoundLabel: UILabel!
    @IBOutlet weak var settingSwitch: UISwitch!
    var bannerView: GADBannerView!
    
    override  func tableView(_ tableView: UITableView, didSelectRowAt
        indexPath: IndexPath){
        print(indexPath.row)
        print(indexPath.section)
        if indexPath.row == 4{
            print("okay")
            let stb = UIStoryboard(name: "Main", bundle: Bundle.main)
            let walkthrough = stb.instantiateViewController(withIdentifier: "master") as! BWWalkthroughViewController
            let page_one = stb.instantiateViewController(withIdentifier: "page1") 
            let page_two = stb.instantiateViewController(withIdentifier: "page2")
            let page_three = stb.instantiateViewController(withIdentifier: "page3")
            let page_four = stb.instantiateViewController(withIdentifier: "page4")
            
            // Attach the pages to the master
            walkthrough.delegate = self as? BWWalkthroughViewControllerDelegate
            walkthrough.add(viewController:page_one)
            walkthrough.add(viewController:page_two)
            walkthrough.add(viewController:page_three)
            walkthrough.add(viewController:page_four)
            
            self.present(walkthrough, animated: true, completion: nil)
        } else if indexPath.section == 1{
            if indexPath.row == 0 {
                if #available(iOS 10.3, *) {
                    SKStoreReviewController.requestReview()
                } else {
                    // Fallback on earlier versions
                }
                
                RatingCell.isSelected = false
            }
        }
    }
    
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    




    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
