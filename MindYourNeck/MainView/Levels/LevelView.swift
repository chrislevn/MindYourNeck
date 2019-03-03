//
//  LevelView.swift
//  MindYourNeck
//
//  Created by Hong Loc on 9/13/18.
//  Copyright © 2018 Hong Loc. All rights reserved.
//

import UIKit
import GoogleMobileAds

class LevelView: UIViewController, GADBannerViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var levelNumber =  UserDefaults.standard.integer(forKey: "levelIncrease")
    var number = 0
    
    let medalImage = ["bronze", "silver", "gold", "dimond", "green", "orange"]
    let levelTitleLabel = ["Level 1 - 1 hour: ", "Level 5 - 5 hours: ", "Level 10 - 10 hours: ", "Level 15 - 15 hours: ", "Level 20 - 20 hours: ", "Level 25 - 25 hour: "]
    let levelContent = ["Congrats, you have reached the first goal! Keep correct posture to go further!",
                        "Woo hoooo, 5 hours with MYN! You are using your phone with a really good posture!",
                        "You are step by step staying away from degenerative spine disease!!",
                        "Exellent job in 15 hours! Your neck isn’t hurt any more, is it? ",
                        "You’re on the way to fight degenerative spine disease off!!  Fighting!",
                        "Awesome, you are the champion!!!! You are your neck master"]
    
    @IBOutlet weak var levelTable: UITableView!
    
    let bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        levelTable.reloadData()
        levelTable.delegate = self
        levelTable.dataSource = self
        levelTable.rowHeight = 100
        
        bannerView.adUnitID = "ca-app-pub-8553102444908866/6877281963" // remember to change
        bannerView.rootViewController = self
        bannerView.delegate = self
        bannerView.load(GADRequest())
        
        addBannerViewToView(bannerView)
        // Do any additional setup after loading the view.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return levelTitleLabel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "levelCell", for: indexPath) as! LevelCell
        
        cell.medalImage.image = UIImage(named: (medalImage[indexPath.row] + ".jpg"))
        cell.levelTitle.text = levelTitleLabel[indexPath.row]
        cell.levelDescript.text = levelContent[indexPath.row]
        
        
        return cell
    }
   
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        if #available(iOS 11.0, *) {
            // In iOS 11, we need to constrain the view to the safe area.
            positionBannerViewFullWidthAtBottomOfSafeArea(bannerView)
        }
        else {
            // In lower iOS versions, safe area is not available so we use
            // bottom layout guide and view edges.
            positionBannerViewFullWidthAtBottomOfView(bannerView)
        }
    }
    
    // MARK: - view positioning
    @available (iOS 11, *)
    func positionBannerViewFullWidthAtBottomOfSafeArea(_ bannerView: UIView) {
        // Position the banner. Stick it to the bottom of the Safe Area.
        // Make it constrained to the edges of the safe area.
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            guide.leftAnchor.constraint(equalTo: bannerView.leftAnchor),
            guide.rightAnchor.constraint(equalTo: bannerView.rightAnchor),
            guide.bottomAnchor.constraint(equalTo: bannerView.bottomAnchor)
            ])
    }
    
    func positionBannerViewFullWidthAtBottomOfView(_ bannerView: UIView) {
        view.addConstraint(NSLayoutConstraint(item: bannerView,
                                              attribute: .leading,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .leading,
                                              multiplier: 1,
                                              constant: 0))
        view.addConstraint(NSLayoutConstraint(item: bannerView,
                                              attribute: .trailing,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .trailing,
                                              multiplier: 1,
                                              constant: 0))
        view.addConstraint(NSLayoutConstraint(item: bannerView,
                                              attribute: .bottom,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .top,
                                              multiplier: 1,
                                              constant: 0))
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
