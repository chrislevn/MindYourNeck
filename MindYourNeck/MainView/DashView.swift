//
//  DashView.swift
//  MindYourNeck
//
//  Created by Hong Loc on 9/13/18.
//  Copyright © 2018 Hong Loc. All rights reserved.
//

import UIKit
import GoogleMobileAds
import Foundation
import CoreMotion
import UserNotifications
import AVFoundation
import AudioToolbox

class DashView: UIViewController, GADBannerViewDelegate, GADInterstitialDelegate, UNUserNotificationCenterDelegate {

//VARIABLES
    let motionManager = CMMotionManager()
    
    //Colors
    let red = UIColor(red: 0.77, green: 0.23, blue: 0.15, alpha: 1.0)
    let yellow = UIColor(red: 0.95, green: 0.81, blue: 0.22, alpha: 1.0)
    let green = UIColor(red: 0.341, green: 0.839, blue: 0.553, alpha: 1.0)
    let orange = UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1.0)
    let blue = UIColor(red: 116/255, green: 184/255, blue: 230/255, alpha: 1.0)
    
    let motionTimeIntervel = 0.5
    
    //For delay Button
    var alarmDisabled = false
    var isDelaying = false
    var levelAmount = UserDefaults.standard.integer(forKey: "levelIncrease")
    
    //Time
    var timeData = Double()
    
    var totalSec = 0.0
    var IntSec = Int()
    var hours = Int()
    var minutes = Int()
    
    //Timer
    var timer = Timer()
    var timeText = String()
    
    var alarmDisableDelayTask: DispatchWorkItem = DispatchWorkItem(block: {})
    
    //Banner Ad
    let bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
    var interstitial: GADInterstitial!

    //Sound
    var player: AVAudioPlayer?
    
    //Text
    let textArrayRight = ["Well-done! You've made a lot of progress!"]
    let textArrayAlmost = ["Common, you almost have the perfect posture. Don’t give up!"]
    let textArrayBad = ["The giraffe is in danger. Save him now!!!!"]
    let textArrayLying = ["Looks like you are lying on a sofa or something?"]
    let textArrayFlat = ["Nah! I won't annoy you when \nyour phone is on table"]
    
    @IBOutlet weak var clock: UIImageView!
    @IBOutlet weak var levelImage: UIImageView!
    @IBOutlet weak var instructionText: UITextView!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var popUpScene: UIView!
    @IBOutlet weak var myTimePicker: UIDatePicker!
    @IBOutlet weak var resultText: UILabel!
    @IBOutlet weak var circle: UIImageView!
    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var usageTime: UILabel!
    @IBOutlet weak var cancel: UIButton!
    @IBOutlet weak var confirm: UIButton!
    @IBOutlet weak var notiButton: UIButton!
    @IBAction func NotiFuncButton(_ sender: Any) {
        if alarmDisabled == false {
            showAnimate()
            backgroundView.isHidden = false
            popUpScene.isHidden = false
            alarmDisabled = true
        } else{
            notiButton.setImage(UIImage(named: "Icons_noti-on"), for: UIControlState.normal)
            alarmDisabled = false
        }
        
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        exitAnimate()
        backgroundView.isHidden = true
        notiButton.setImage(UIImage(named: "Icons_noti-on"), for: UIControlState.normal)
        alarmDisabled = false
    }
    
    @IBAction func confirmButton(_ sender: UIButton) {
        backgroundView.isHidden = true
        notiButton.setImage(UIImage(named: "Icons_noti-off"), for: UIControlState.normal)
        exitAnimate()
        
        let somedate: Date = myTimePicker.date
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: somedate)
        
        let hour: Double = Double(components.hour! * 3600)
        let minute: Double = Double(components.minute! * 60)
        
        let totalLength = hour + minute
        
        timeData = totalLength
        
        alarmDisabled = true
        isDelaying = false
        
        
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
        }
    }
    
//-------------------------------------------------------------------------------------------------------------------------//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Backgroynd
        backgroundView.isHidden = true
        popUpScene.isHidden = true
        
        //instructionText.text = "Hold your neck and your phone straight!"
        
        interstitial = createAndLoadInterstitial()
        bannerView.adUnitID = "ca-app-pub-8553102444908866/6877281963" // remember to change
        bannerView.rootViewController = self
        bannerView.delegate = self
        bannerView.load(GADRequest())
        addBannerViewToView(bannerView)
        
        instructionText.center = CGPoint(x: view.frame.width / 2, y: view.frame.height / 5)
        
        notiButton.center  = CGPoint(x: view.frame.width / 1.08, y: view.frame.height / 7.4)
        
        levelImage.center  = CGPoint(x: view.frame.width / 2 , y: view.frame.height / 1.38)
        level.center  = CGPoint(x: view.frame.width / 1.8 , y: view.frame.height / 1.38)
        
        circle.image = circle.image!.withRenderingMode(.alwaysTemplate)
        circle.tintColor = green
        
        cancel.layer.cornerRadius = 8
        cancel.layer.borderWidth = 1
        confirm.layer.cornerRadius = 8
        confirm.layer.borderWidth = 1
        
        popUpScene.layer.cornerRadius = 10
        popUpScene.center = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2.5)
        
        resultText.center = CGPoint(x: view.frame.width / 2, y: view.frame.height / 1.28)
        
        myTimePicker.datePickerMode = .countDownTimer
        myTimePicker.backgroundColor = UIColor.white
        
        notiButton.setImage(UIImage(named: "Icons_noti-on"), for: UIControlState.normal)
        
        //Levels
        levelAmount = UserDefaults.standard.integer(forKey: "levelIncrease")
        level.text = "\(UserDefaults.standard.integer(forKey: "levelIncrease"))"
        UIApplication.shared.applicationIconBadgeNumber = UserDefaults.standard.integer(forKey: "levelIncrease")
        usageTime.text = UserDefaults.standard.string(forKey: "Time")
        totalSec = UserDefaults.standard.double(forKey: "second")
    
        //CORE MOTION Function
        
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = motionTimeIntervel
            motionManager.startDeviceMotionUpdates(
                to: OperationQueue.current!, withHandler: {
                    (deviceMotion, error) -> Void in
                    
                    if(error == nil) {
                        self.handleDeviceMotionUpdate(deviceMotion: deviceMotion!)
                    } else {
                        print("error")
                    }
            })
        }
    }
    
//-------------------------------------------------------------------------------------------------------------------------//
//INIT Functions
    //MAIN
    
    func degrees(radians:Double) -> Double {
        return 180 / Double.pi * radians
    }
    
    
    func handleDeviceMotionUpdate(deviceMotion:CMDeviceMotion) {
        let randomRight = Int(arc4random_uniform(UInt32(textArrayRight.count)))
        let randomAlmost = Int(arc4random_uniform(UInt32(textArrayAlmost.count)))
        let randomBad = Int(arc4random_uniform(UInt32(textArrayBad.count)))
        let randomLying = Int(arc4random_uniform(UInt32(textArrayLying.count)))
        let randomFlat = Int(arc4random_uniform(UInt32(textArrayFlat.count)))
        
        let attitude = deviceMotion.attitude
        
        let pitch = degrees(radians: attitude.pitch)
        let roll = degrees(radians: attitude.roll)
        
        let rightUsage = pitch > 45 && pitch < 90
        let specialAngle = pitch > -2 && pitch < 2
        let specialRoll = roll > 70 && roll < 180
        let specialRoll2 = roll > -180 && roll < -70
        
        let special1 =  specialRoll || specialRoll2
        let SpecialCase = specialAngle || special1
        
        if rightUsage {
            runTimer()
            avatar.image = nil
            avatar.image = UIImage(named: "HCCAva-1")
            circle.tintColor = green
            resultText.textColor = green
            resultText.text = "Wonderful"
            instructionText.text = textArrayRight[randomRight]
            
        } else if specialAngle  {
            avatar.image = nil
            avatar.image = UIImage(named: "HCCAva-1")
            circle.tintColor = orange
            resultText.textColor = orange
            resultText.text = "Inactive"
            instructionText.text = textArrayFlat[randomFlat]
            
        } else if special1 {
            avatar.image = nil
            avatar.image = UIImage(named: "HCCAva-1")
            circle.tintColor = blue
            resultText.textColor = blue
            resultText.text = "Relax"
            instructionText.text = textArrayLying[randomLying]
            
        } else {
            if !SpecialCase {
            if !alarmDisabled {
                stopTimer()
                notification()
                
                let nearlyRightUsage = pitch > 20 && pitch < 45
                if nearlyRightUsage {
                    avatar.image = nil
                    avatar.image = UIImage(named: "HCCAva-2")
                    circle.tintColor = yellow
                    resultText.textColor = yellow
                    resultText.text = "Cool"
                    instructionText.text = textArrayAlmost[randomAlmost]
                    audio()
                    AudioServicesPlaySystemSound(1519)
                } else {
                    avatar.image = nil
                    avatar.image = UIImage(named: "HCCAva-3")
                    circle.tintColor = red
                    resultText.textColor = red
                    resultText.text = "Dangerous"
                    instructionText.text = textArrayBad[randomBad]
                    audio2()
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                }
            
            } else{
                DelayFunction()
                }
            }
        
        }
    }
    
    func audio2(){
        guard let url = Bundle.main.url(forResource: "beep" , withExtension: "mp3") else {return}
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategorySoloAmbient)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player else {return}
            player.prepareToPlay()
            player.play()
        }catch let error {
            print(error.localizedDescription)
        }
    }
    
    func audio(){
       
         guard let url = Bundle.main.url(forResource: "error" , withExtension: "mp3") else {return}
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategorySoloAmbient)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player else {return}
            player.prepareToPlay()
            player.play()
        }catch let error {
            print(error.localizedDescription)
        }
    }
    func audio3(){
        
        guard let url = Bundle.main.url(forResource: "notification" , withExtension: "mp3") else {return}
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategorySoloAmbient)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player else {return}
            player.prepareToPlay()
            player.play()
        }catch let error {
            print(error.localizedDescription)
        }
    }
    
    func DelayFunction(){
        if isDelaying { return }
        
        alarmDisableDelayTask.cancel()
        
        alarmDisableDelayTask = DispatchWorkItem(){ [weak self] in
            //print(self?.timeData)
            
            self?.notiButton.setImage(UIImage(named: "Icons_noti-on"), for: UIControlState.normal)
            self?.alarmDisabled = false
            self?.timeData = 0.0
            self?.isDelaying = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + timeData, execute: alarmDisableDelayTask)
       
        isDelaying = true
    }
    

    // TIMER
    func runTimer() {
        
        totalSec += 0.5
        UserDefaults.standard.set(totalSec, forKey: "second")
        let totalTime = UserDefaults.standard.float(forKey: "second")
        print(totalTime)
        
        IntSec = Int(totalTime)
        hours = Int(totalTime/3600)
        minutes = Int(totalTime.truncatingRemainder(dividingBy: 3600) / 60)
        
        if (IntSec != 0 ) && (IntSec % 3600 == 0) { //will change to 3600 for 1 hour
            levelAmount += 1
            let levelInt = Int(levelAmount)
            UserDefaults.standard.set(levelInt, forKey: "levelIncrease")
            let levelNumber = UserDefaults.standard.integer(forKey: "levelIncrease")
            level.text = "\(levelNumber)"
            UIApplication.shared.applicationIconBadgeNumber = levelNumber
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "alert") as! CustomAlert
            
            vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            
            if levelNumber < 5{
                vc.alertImage.image = UIImage(named: "bronze.jpg")
                vc.alertContent.text = "Excellent job with your \(levelNumber) hours using this app! Go to Levels for more information"
                 
            } else if levelNumber < 10{
                vc.alertImage.image = UIImage(named: "silver.jpg")
                vc.alertContent.text = "Wow \(levelNumber) hours!! You're awesome! Go to Levels for more information"
                
            } else if levelNumber < 15 {
                vc.alertImage.image = UIImage(named: "gold.jpg")
                vc.alertContent.text = "\(levelNumber) hours! You're crusing it! Go to Levels for more information"
                
            } else if levelNumber < 20 {
                vc.alertImage.image = UIImage(named: "green.jpg")
                vc.alertContent.text = "\(levelNumber) hours! This is awesome! Go to Levels for more information"
               
            } else if levelNumber < 25 {
                vc.alertImage.image = UIImage(named: "blue.jpg")
                vc.alertContent.text = "You're on your way to master your neck posture with \(levelNumber) hours! Go to Levels for more information"
                
            } else {
                vc.alertImage.image = UIImage(named: "orange.jpg")
                vc.alertContent.text = "You've masterer your neck posture with \(levelNumber) hours! Go to Levels for more information"
                
            }
            
            audio3()
            self.present(vc, animated: false, completion: nil)
            
        }
       
        
        if hours > 0 {
            print(String(format: "%02d hours :%02d minutes ", hours, minutes))
            timeText = String(format: "%02d hours :%02d minutes", hours, minutes)
             UserDefaults.standard.set(timeText, forKey: "Time")
            
        } else if minutes > 1 {
            print(String(format: "%02d minutes", minutes))
            timeText = String(format: "%02d minutes", minutes)
             UserDefaults.standard.set(timeText, forKey: "Time")
            
        } else {
            print(String(format: "%01d minute", minutes))
            timeText = String(format: "%01d minute", minutes)
             UserDefaults.standard.set(timeText, forKey: "Time")
        }
        
        
        usageTime.text = UserDefaults.standard.string(forKey: "Time")
        
    }
    
    func stopTimer(){
        print("stopped")
    }
    
    //FOR POP UP SCREEN
    func showAnimate(){
        popUpScene.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        popUpScene.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.popUpScene.alpha = 1.0
            self.popUpScene.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func exitAnimate(){
        UIView.animate(withDuration: 0.25, animations: {
            self.popUpScene.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.popUpScene.alpha = 0.0}, completion: { (finished : Bool) in
                if (finished){
                    self.popUpScene.isHidden = true
                }
        });
    }
    
    //Banner Ad Function
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
    
    //Int Ad Function
    func createAndLoadInterstitial() -> GADInterstitial {
        
        let request = GADRequest()
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-8553102444908866/2746465265") //remember to change
        interstitial.delegate = self
        interstitial.load(request)
        
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
    }
    
    //NOTIFICATIONS
    
    func notification(){
            let content = UNMutableNotificationContent()
            content.title = "See you later"
            content.body = NSString.localizedUserNotificationString(forKey: "Remember to come back to MYN for more fun stuffs", arguments: nil)
        
            content.categoryIdentifier = "Action_category"
            
            let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest.init(identifier: "Action_category", content: content, trigger: trigger)
            
    
        let center = UNUserNotificationCenter.current()
        
        center.add(request)
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
