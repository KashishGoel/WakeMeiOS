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

import Pods_Photo_Alarm

import SwiftWeatherService
import CoreLocation
import Alamofire
import SwiftyJSON

class ViewController: UIViewController,AVAudioPlayerDelegate, CLLocationManagerDelegate {
    //deleted UITablEivew delegate and datasource
    //TestRun

   
    @IBOutlet weak var turnOffButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var temperature: UILabel!
    
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var loading: UILabel!
    
    @IBOutlet weak var time1: UILabel!
    @IBOutlet weak var time2: UILabel!

    @IBOutlet weak var time3: UILabel!
    @IBOutlet weak var time4: UILabel!
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    
    @IBOutlet weak var image3: UIImageView!
   
    @IBOutlet weak var image4: UIImageView!
    @IBOutlet weak var temp1: UILabel!
    @IBOutlet weak var temp2: UILabel!
    @IBOutlet weak var temp3: UILabel!
    @IBOutlet weak var temp4: UILabel!

    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
    
    
    var fetchedResultsController:NSFetchedResultsController = NSFetchedResultsController()
    var backgroundMusic = AVAudioPlayer()
     private let locationManager = CLLocationManager()
    
    
    @IBAction func turnOffButton(sender: UIButton) {
        self.performSegueWithIdentifier("main", sender: self)
    }
    @IBAction func settingsButtonPressed(sender: UIButton) {
        self.performSegueWithIdentifier("settings", sender: self)
    }
    @IBAction func alarmButtonPressed(sender: UIButton) {
        self.performSegueWithIdentifier("alarm", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.loadingIndicator.startAnimating()
        
       // let background = UIImage(named: "background.png")
       // self.view.backgroundColor = UIColor(patternImage: background!)
        
        let singleFingerTap = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleSingleTap(_:)))
        self.view.addGestureRecognizer(singleFingerTap)
        
        //locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()

     
        
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        locationManager.startUpdatingLocation()
    }
    func updateWeatherInfo(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let key = "631b983605dd35bbbc75a64dea3248b0"
        let url = "http://api.openweathermap.org/data/2.5/forecast"
        let params = ["lat":latitude, "lon":longitude, "APPID":key]
        print(params)
        
        request(.GET, url, parameters: params as? [String : AnyObject])
            .responseJSON { response in
                
                guard let data = response.result.value else {
                print("Error")
                    return
                }
                let data_ar = JSON(data)
                self.updateUISuccess(data_ar)
                

//                    print("Success: \(url)")
//                    print(request)
//                switch json {
//                case .Success(let data):
//                    let data_ar = JSON(data) 
//                    self.updateUISuccess(data_ar)
//                    
//                case .Failure(let error):
//                    print("Request failed with error: \(error)")
//                    
//                    
//                }
//                    let json = JSON(json)
//                    self.updateUISuccess(json!)
                //}
        }
    }
    
    func updateUISuccess(json: JSON) {
        self.loading.text = nil
        self.loadingIndicator.hidden = true
        self.loadingIndicator.stopAnimating()
        
        let service = SwiftWeatherService.WeatherService()
        
        // If we can get the temperature from JSON correctly, we assume the rest of JSON is correct.
        if let tempResult = json["list"][0]["main"]["temp"].double {
            // Get country
            let country = json["city"]["country"].stringValue
            
            // Get and convert temperature
            let temperature = service.convertTemperature(country, temperature: tempResult)
            self.temperature.text = "\(temperature)°"
            
            // Get city name
            self.location.text = json["city"]["name"].stringValue
            
            // Get and set icon
            let weather = json["list"][0]["weather"][0]
            let condition = weather["id"].intValue
            let icon = weather["icon"].stringValue
            let nightTime = service.isNightTime(icon)
            service.updateWeatherIcon(condition, nightTime: nightTime, index: 0, callback: self.updatePictures)
            
            // Get forecast
            for index in 1...4 {
                print(json["list"][index])
                if let tempResult = json["list"][index]["main"]["temp"].double {
                    // Get and convert temperature
                    let temperature = service.convertTemperature(country, temperature: tempResult)
                    if (index==1) {
                        self.temp1.text = "\(temperature)°"
                    }
                    else if (index==2) {
                        self.temp2.text = "\(temperature)°"
                    }
                    else if (index==3) {
                        self.temp3.text = "\(temperature)°"
                    }
                    else if (index==4) {
                        self.temp4.text = "\(temperature)°"
                    }
                    
                    // Get forecast time
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "HH:mm"
                    let rawDate = json["list"][index]["dt"].doubleValue
                    let date = NSDate(timeIntervalSince1970: rawDate)
                    let forecastTime = dateFormatter.stringFromDate(date)
                    if (index==1) {
                        self.time1.text = forecastTime
                    }
                    else if (index==2) {
                        self.time2.text = forecastTime
                    }
                    else if (index==3) {
                        self.time3.text = forecastTime
                    }
                    else if (index==4) {
                        self.time4.text = forecastTime
                    }
                    
                    // Get and set icon
                    let weather = json["list"][index]["weather"][0]
                    let condition = weather["id"].intValue
                    let icon = weather["icon"].stringValue
                    let nightTime = service.isNightTime(icon)
                    service.updateWeatherIcon(condition, nightTime: nightTime, index: index, callback: self.updatePictures)
                }
                else {
                    continue
                }
            }
        }
        else {
            self.loading.text = "Weather info is not available!"
        }
    }
    
    func updatePictures(index: Int, name: String) {
        if (index==0) {
            self.icon.image = UIImage(named: name)
        }
        if (index==1) {
            self.image1.image = UIImage(named: name)
        }
        if (index==2) {
            self.image2.image = UIImage(named: name)
        }
        if (index==3) {
            self.image3.image = UIImage(named: name)
        }
        if (index==4) {
            self.image4.image = UIImage(named: name)
        }
    }
    
    //MARK: - CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("loc")
        let location:CLLocation = locations[locations.count-1] 
        if (location.horizontalAccuracy > 0) {
            self.locationManager.stopUpdatingLocation()
            print(location.coordinate)
            updateWeatherInfo(location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
        self.loading.text = "Something went wrong!"
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

 
   
    
    
    @IBAction func turnOffButtonClicked(sender: UIButton) {
          self.performSegueWithIdentifier("showTurnOff", sender: self)
    }
        
    @IBAction func addAlarmButtonClicked(sender: UIButton) {
         self.performSegueWithIdentifier("showAddAlarm", sender: self)
    }
    @IBAction func settingsButtonClicked(sender: UIButton) {
        self.performSegueWithIdentifier("showSettings", sender: self)
    }
    func setupAudioPlayerWithFile(file:NSString, type:NSString) -> AVAudioPlayer  {
        //1
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            //try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        } catch {}
        let path = NSBundle.mainBundle().pathForResource(file as String, ofType: type as String)
        let url = NSURL.fileURLWithPath(path!)
        
        //2
        //let error: NSError?
        
        //3
        var audioPlayer:AVAudioPlayer?
        do {
            try
            audioPlayer = AVAudioPlayer(contentsOfURL: url)} catch
            {print("error")}
        
        //4
        return audioPlayer!
    }
    
   
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let numberOfNotifs = UIApplication.sharedApplication().scheduledLocalNotifications!.count
        
        if numberOfNotifs > 0 {
            turnOffButton.hidden = false
            
        }
            
        else {turnOffButton.hidden = true}

         }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

  
    
   
    
    
    
    

    
    
    func dateConvertFromTwentyFourToTwelve () {
      //  let dateManager = NSDateFormatter ()
        
    
    
    }
    

    
    
}

