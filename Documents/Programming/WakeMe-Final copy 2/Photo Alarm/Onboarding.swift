//
//  Onboarding.swift
//  Photo Alarm
//
//  Created by Kashish Goel on 2016-07-02.
//  Copyright © 2016 Kashish Goel. All rights reserved.
//


import Foundation
import UIKit
import EventKit
import CoreLocation



public let application = UIApplication.sharedApplication()

class OnboardingStep:UIViewController{
    
    
    override func viewDidLoad() {
        self.view.backgroundColor = StyleKit.orangeWhite()
        print(NSUserDefaults.standardUserDefaults().boolForKey("loaded"))
        
        
        
        
        
        
    }
    override func viewDidAppear(animated: Bool) {
        if (NSUserDefaults.standardUserDefaults().boolForKey("loaded") == true){
            
            self.performSegueWithIdentifier("goDirectHome", sender: self)
        }
    }
    
    
    
    
}

class OnboardingStep2:UIViewController, CLLocationManagerDelegate{
    let locationManager:CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        self.view.backgroundColor = StyleKit.orangeWhite()
    }
    
    @IBAction func getPermission(sender: AnyObject) {
    
       locationManager.requestAlwaysAuthorization()
        
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        switch status{
        case .NotDetermined:
            manager.requestAlwaysAuthorization()
        case .AuthorizedAlways:
            self.performSegueWithIdentifier("goStep3", sender: self)
            
        case.Denied:
            print("denied")
            
        default:
            print("error")
        }
    }
    
    
}



class OnboardingStep3: UIViewController {
    override func viewDidLoad() {
        self.view.backgroundColor = StyleKit.orangeWhite()
    }
    
    @IBAction func getPermission(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "loaded")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert,.Sound], categories: nil))
        
        self.performSegueWithIdentifier("goHome", sender: self)
        
    }
    
}






