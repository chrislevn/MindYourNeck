//
//  ExerciseView.swift
//  MindYourNeck
//
//  Created by Hong Loc on 9/13/18.
//  Copyright © 2018 Hong Loc. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ExerciseView: UIViewController, GADBannerViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let exercisesImage = ["NeckGlide", "NeckExtension", "NeckRotation", "ShoulderShrugs", "NeckTilt", "NeckStretching", "NeckResist", "NeckTowel"]
    let Level = ["Neck Glide: ", "Neck Extension: ", "Neck Rotation: ", "Shoulder Shrugs: ", "Tilted Forward Flexion: ", "Deep Stretching: ", "Resistance Presses: ", "Towel Pull: "]
    let Content = [//NeckGlide
                    "1. Start with neck straight." +
                    "\n\n2. Slowly slide your chin forward." +
                    "\n\n3. Hold for 5 seconds and return to starting position. Do 10 times.",
                    //NeckExtension
                    "1. Without arching your back, slowly move your head backward so you are looking upward." +
                    "\n\n2. Hold for five seconds." +
                    "\n\n3.Return to starting position. This is a good exercise to do during work to prevent neck strain.",
                    
                    //NeckRotation
                    "1. Start by looking straight ahead. Slowly turn your head to the left. Hold for 10 seconds, then return to starting position." +
                    "\n\n2. Then, slowly turn you head to the other side. Hold for 10 seconds. Return to starting position. Do 10 repetitions." +
                    "\n\n3. This is a good exercise to do during work, especially if you have to keep your head in a steady position for extended periods, as in working at a computer." +
                    "\n\n4. Do this exercise every half hour to prevent neck strain.",
                    //ShoulderShrugs
                    "1. Start by looking straight ahead. Slowly raise both shoulders up. Hold for 5 seconds, then return to starting position." +
                    "\n\n2. Do 10 repetitions." +
                    "\n\n3. This is a good exercise to do during work, especially if you have to keep your head in a steady position for extended periods, as in working at a computer." +
                    "\n\n4. Do this exercise every half hour to prevent neck strain.",
                    
                    //NeckTilt
                    "1. Start by looking straight ahead. Slowly lower your chin toward your chest." +
                    "\n\n2. Hold for 5 seconds, then return to starting position." +
                    "\n\n3. Do 10 repetitions." +
                    "\n\n4. This is a good exercise to do during work, especially if you have to keep your head in a steady position for extended periods, as when working at a computer." +
                    "\n\n5. Do this exercise every half hour to prevent neck strain.",
                    
                    //NeckStretching
                    "1. Sitting with good posture, let your head fall towards your shoulder." +
                    "\n\n2. You can apply pressure with your hand as shown. You may also hold onto your chair with the opposite hand." +
                    "\n\n3. Hold 30 seconds, repeat 3 times.",
                    
                    //NeckResist
                    "1. Keep your head in a neutral position at all times." +
                    "\n\n2. Apply pressure to your head in the following positions for 5 seconds then relax." +
                    "\n\n3. Flexion- place hand at forehead. Extension- place hand at back of head",
                    
                    //NeckTowel
                    "1. Place rolled towel around your neck, and hold ends with hands." +
                    "\n\n2. Slowly look up as far as you can, rolling your head over the towel." +
                    "\n\n3. Apply gentle pressure on towel to support cervical spine as you extend head back." +
                    "\n\n4. Do not hold the position. Instead, return to starting position. Repeat 10 times."]
    
    @IBOutlet weak var myTableView: UITableView!
    let bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Neck Exercises"
        
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.rowHeight = 600
       
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
        return (Content.count)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExCell", for: indexPath) as! ExerciseCell
        
        cell.StepLabel.text = Level[indexPath.row]
        cell.ImageLabel.image = UIImage(named: (exercisesImage[indexPath.row] + ".jpg"))
        cell.ContentLabel.text = Content[indexPath.row]
        
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
