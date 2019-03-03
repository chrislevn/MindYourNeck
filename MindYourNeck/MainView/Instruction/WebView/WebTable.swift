//
//  WebTable.swift
//  MindYourNeck
//
//  Created by Hong Loc on 9/15/18.
//  Copyright © 2018 Hong Loc. All rights reserved.
//

import UIKit

class WebTable: UITableViewController {
    
    
    @IBOutlet weak var RequestButton: UIButton!
    
    var itemsInSections: Array<Array<String>> = [["Facebook", "Twitter", "Instagram", "Reddit", "Pinterest", "9GAG"],
                                                 ["Youtube"],
                                                 ["Daily Mail", "The Guardian", "New York Times", "Telegraph", "Independent", "CNN", "BBC", "The Verge"],
                                                  ["Google"],
                                                 ["Amazon", "Ebay"],
                                                 ["Webtoon","Wattpad","Viewcomic","Truyentranhtuan", "Thichtruyentranh"],
                                                 ["Báo Kenh14","Báo VnExpress", "Báo Thanh niên", "Báo Dân trí", "Tinh Tế "]]
    
    var imageInSections: Array<Array<String>> = [["Facebook", "Twitter", "Instagram", "Reddit", "Pinterest", "9GAG"],
                                                 ["Youtube"],
                                                 ["News", "News", "News", "News", "News", "News", "News", "News"],
                                                 ["Google"],
                                                 ["Amazon", "Ebay"],
                                                 ["Viewcomic","Viewcomic","Viewcomic","Viewcomic","Viewcomic"],
                                                 ["News","News","News", "News", "News"]]
    
    var linksInSections: Array<Array<String>> = [["https://www.facebook.com/", "https://twitter.com/", "https://www.instagram.com", "https://www.reddit.com/","https://www.pinterest.com/", "https://9gag.com/"],
                                                 
                                                 ["https://www.youtube.com/"],
                                                                  
                                                 ["https://www.dailymail.co.uk/home/index.html", "https://www.theguardian.com", "https://www.nytimes.com/", "https://www.telegraph.co.uk/", "https://www.independent.co.uk/", "https://edition.cnn.com/", "https://www.bbc.co.uk/", "https://www.theverge.com/"],
                                                 
                                                 ["https://www.google.com/"],
                                                 
                                                 ["https://www.amazon.com/", "https://www.ebay.com/"],
                                                 
                                                 ["https://www.webtoons.com/en/","https://www.wattpad.com/", "http://viewcomic.com/","http://truyentranhtuan.com/", "http://thichtruyentranh.com/"],
                                                 
                                                 ["http://kenh14.vn/","https://vnexpress.net/", "https://thanhnien.vn/", "https://dantri.com.vn/", "https://tinhte.vn/"]]
    var sections: Array<String> = ["Social media", "Streaming", "News", "Utilities", "Shopping","Comics", "Vietnamese news"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RequestButton.layer.cornerRadius = 8
        
        self.navigationItem.title = "Websites"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
         return self.sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.itemsInSections[section].count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section]
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WebCell") as! WebView
        let text = self.itemsInSections[indexPath.section][indexPath.row]
        let image = UIImage(named: "\(imageInSections[indexPath.section][indexPath.row])" )
        
        cell.webImage.image = image
        cell.webLabel.text = text
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "SurfID") as? SurfWeb
        vc?.WebTitle = itemsInSections[indexPath.section][indexPath.row]
        vc?.link = linksInSections[indexPath.section][indexPath.row]
        self.navigationController?.pushViewController(vc!, animated: true)
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
