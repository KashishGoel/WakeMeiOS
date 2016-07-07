//
//  ViewController.swift
//  Kashish_TaskIt
//
//  Created by Kashish Goel on 2015-07-15.
//  Copyright (c) 2015 Kashish Goel. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation
import AVKit


class AddAlarm: UIViewController,AVAudioPlayerDelegate{
    

    
    
    //@IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
 
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
//       let background = UIImage(named: "background11.jpg")
       // dueDatePicker.setValue(UIColor.whiteColor(), forKeyPath: "textColor")
       // dueDatePicker.backgroundColor = hexStringToUIColor("0F7386")
//                self.view.backgroundColor = UIColor(patternImage: background!)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    
//    @IBAction func cancelButtonTapped(sender: UIButton) {
//
//       
//     
//        
//    }
    
    @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
 
    
  
    func notificationCreater (date:NSDate) {
        
        for notif in 0 ..< 10 {
            let date1 = date.dateByAddingTimeInterval(Double(notif*6))
           // print(date1)
            let notification = UILocalNotification ()
            
            notification.alertBody = "If you're reading this, it's too late, wake up!"
            
            notification.fireDate = date1
            notification.repeatInterval = NSCalendarUnit.Minute
                       //  notification.soundName = "alarmSound.m4a"
            notification.alertAction = "Swipe to turn off Alarm"
            notification.soundName = "alarmSound.m4a"
            notification.alertTitle = "WakeMe"
            
           // print("schld")
            
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        }
    }
    
   override func  preferredStatusBarStyle() -> UIStatusBarStyle {
    return UIStatusBarStyle.LightContent
    
    }
    
   
    
    @IBAction func doneButtonPressed(sender: UIBarButtonItem) {
        
      

    }
    
    
    
    @IBAction func doneButton(sender: UIBarButtonItem) {
        

        notificationCreater(dueDatePicker.date)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
