//
//  MainViewController.swift
//  TestApp
//
//  Created by Kashish Goel on 2015-08-11.
//  Copyright (c) 2015 Kashish Goel. All rights reserved.
//

import UIKit
import CoreData
import MobileCoreServices
import Foundation
import AVFoundation
import SwiftyJSON

class MainViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tryAgainButton: UIBarButtonItem!
    @IBOutlet weak var serverTimeLabel: UILabel!
    var status:String?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var camfindOutputLabel: UILabel!
    @IBOutlet weak var tryAgainLabel: UIButton!
    @IBOutlet weak var turnOffButton: UIButton!
    var API_KEY = "AIzaSyBPiCFXl2iNv0s3RCzEXFPlmqX4NEelIEw"
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
      //  let background = UIImage(named: "background_summer.png")
    
//        self.view.backgroundColor = UIColor(patternImage: background!)
//
//        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
//        let entityDescription = NSEntityDescription.entityForName("TaskModel", inManagedObjectContext: managedObjectContext!)
//        let alarm = TaskModel(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext!)
//        imageView.image = UIImage(data: alarm.image)
        // let string = tokenValue
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func cameraButtonPressed(sender: UIBarButtonItem) {
        if AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo) ==  AVAuthorizationStatus.Authorized
        {
            self.snapPicture()
        }
        else
        {
            AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: { (granted :Bool) -> Void in
                if granted == true
                {
                    self.snapPicture()
                }
                else
                {
                    // User Rejected
                }
            });
        }
        

    }
   
   
    @IBAction func tryAgainButtonPressed(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("backToHome", sender: self)
    }
    
    func snapPicture() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let cameraController = UIImagePickerController()
            cameraController.delegate = self
            cameraController.sourceType = UIImagePickerControllerSourceType.Camera
            
            //   let mediaTypes:[AnyObject] = [kUTTypeImage]
            cameraController.mediaTypes = [kUTTypeImage as String]
            cameraController.allowsEditing = false
            
            self.presentViewController(cameraController, animated: true, completion: nil)
        }
            
            
        else if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            
            let photoLibraryController = UIImagePickerController()
            photoLibraryController.delegate = self
            photoLibraryController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            
            
            //   let mediaTypes:[AnyObject] = [kUTTypeImage]
            photoLibraryController.mediaTypes = [kUTTypeImage as String]
            photoLibraryController.allowsEditing = false
            
            self.presentViewController(photoLibraryController, animated: true, completion: nil)
        }        else {
            let alertController = UIAlertController(title: "Alert", message: "Your device does not support the camera or photo Library", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    @IBAction func saveButtonPressed(sender: UIButton) {
        
        
        //        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        //        let entityDescription = NSEntityDescription.entityForName("TaskModel", inManagedObjectContext: managedObjectContext!)
        //        let alarm = TaskModel(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext!)
//        requestMethod(imageView.image)
//        getRequest()
        self.turnOffButton.hidden = true
        self.activityIndicator.hidden = false
        self.serverTimeLabel.hidden = false
    }
    
//    @IBAction func resultsButtonPressed(sender: UIButton) {
//        
//        var helloWorldTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("sayHello:"), userInfo: nil, repeats: false)
//        
//    }
    
    
    //UIIMagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let imageData = UIImageJPEGRepresentation(image, 1.0)
//        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
//        let entityDescription = NSEntityDescription.entityForName("TaskModel", inManagedObjectContext: managedObjectContext!)
//        let alarm = TaskModel(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext!)
//        alarm.image = imageData!
//        imageView.image = UIImage(data: alarm.image)
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .ScaleAspectFit
            imageView.hidden = true // You could optionally display the image here by setting imageView.image = pickedImage
            self.turnOffButton.hidden = true
            self.activityIndicator.hidden = false
            self.serverTimeLabel.hidden = false
            
            // Base64 encode the image and create the request
            let binaryImageData = base64EncodeImage(pickedImage)
            createRequest(binaryImageData)
        }
//        turnOffButton.hidden = false
        
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).saveContext()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func resizeImage(imageSize: CGSize, image: UIImage) -> NSData {
        UIGraphicsBeginImageContext(imageSize)
        image.drawInRect(CGRectMake(0, 0, imageSize.width, imageSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        let resizedImage = UIImagePNGRepresentation(newImage)
        UIGraphicsEndImageContext()
        return resizedImage!
    }
    
    func base64EncodeImage(image: UIImage) -> String {
        var imagedata = UIImagePNGRepresentation(image)
        
        // Resize the image if it exceeds the 2MB API limit
        if (imagedata?.length > 2097152) {
            let oldSize: CGSize = image.size
            let newSize: CGSize = CGSizeMake(800, oldSize.height / oldSize.width * 800)
            imagedata = resizeImage(newSize, image: image)
        }
        
        return imagedata!.base64EncodedStringWithOptions(.EncodingEndLineWithCarriageReturn)
    }
    func createRequest(imageData: String) {
        // Create our request URL
        let request = NSMutableURLRequest(
            URL: NSURL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(API_KEY)")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(
            NSBundle.mainBundle().bundleIdentifier ?? "",
            forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        
        // Build our API request
        let jsonRequest: [String: AnyObject] = [
            "requests": [
                "image": [
                    "content": imageData
                ],
                "features": [
                    [
                        "type": "LABEL_DETECTION",
                        "maxResults": 10
                    ],
                    [
                        "type": "FACE_DETECTION",
                        "maxResults": 10
                    ]
                ]
            ]
        ]
        
        // Serialize the JSON
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(jsonRequest, options: [])
        
        // Run the request on a background thread
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            self.runRequestOnBackgroundThread(request)
        });
        
    }
    
    func runRequestOnBackgroundThread(request: NSMutableURLRequest) {
        
        let session = NSURLSession.sharedSession()
        
        // run the request
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            self.analyzeResults(data!)
        })
        task.resume()
    }
    
    func analyzeResults(dataToParse: NSData) {
        
        // Update UI on the main thread
        dispatch_async(dispatch_get_main_queue(), {
            
            
            // Use SwiftyJSON to parse results
            let json = JSON(data: dataToParse)
            let errorObj: JSON = json["error"]
            
           
            self.imageView.hidden = true
//            self.labelResults.hidden = false
//            self.faceResults.hidden = false
//            self.faceResults.text = ""
            
            // Check for errors
            if (errorObj.dictionaryValue != [:]) {
                self.errorLabel.text = "Error code \(errorObj["code"]): \(errorObj["message"])"
            } else {
                // Parse the response
                print(json)
                let responses: JSON = json["responses"][0]
                
                // Get face annotations
//                let faceAnnotations: JSON = responses["faceAnnotations"]
//                if faceAnnotations != nil {
//                    let emotions: Array<String> = ["joy", "sorrow", "surprise", "anger"]
//                    
//                    let numPeopleDetected:Int = faceAnnotations.count
//                    
//                    self.faceResults.text = "People detected: \(numPeopleDetected)\n\nEmotions detected:\n"
//                    
//                    var emotionTotals: [String: Double] = ["sorrow": 0, "joy": 0, "surprise": 0, "anger": 0]
//                    var emotionLikelihoods: [String: Double] = ["VERY_LIKELY": 0.9, "LIKELY": 0.75, "POSSIBLE": 0.5, "UNLIKELY":0.25, "VERY_UNLIKELY": 0.0]
//                    
//                    for index in 0..<numPeopleDetected {
//                        let personData:JSON = faceAnnotations[index]
//                        
//                        // Sum all the detected emotions
//                        for emotion in emotions {
//                            let lookup = emotion + "Likelihood"
//                            let result:String = personData[lookup].stringValue
//                            emotionTotals[emotion]! += emotionLikelihoods[result]!
//                        }
//                    }
//                    // Get emotion likelihood as a % and display in UI
//                    for (emotion, total) in emotionTotals {
//                        let likelihood:Double = total / Double(numPeopleDetected)
//                        let percent: Int = Int(round(likelihood * 100))
//                        self.faceResults.text! += "\(emotion): \(percent)%\n"
//                    }
//                } else {
//                    self.faceResults.text = "No faces found"
//                }
                
                // Get label annotations
                let labelAnnotations: JSON = responses["labelAnnotations"]
                let numLabels: Int = labelAnnotations.count
                var labels: Array<String> = []
                if numLabels > 0 {
                    var labelResultsText:String = ""
                    for index in 0..<numLabels {
                        let label = labelAnnotations[index]["description"].stringValue
                        labels.append(label)
                    }
                    for label in labels {
                        // if it's not the last item add a comma
                        if labels[labels.count - 1] != label {
                            labelResultsText += "\(label), "
                        } else {
                            labelResultsText += "\(label)"
                        }
                    }
                    print(labelResultsText)
                    if labelResultsText.lowercaseString.rangeOfString("sink") != nil {
                        UIApplication.sharedApplication().cancelAllLocalNotifications()
                        let audio = (UIApplication.sharedApplication().delegate as! AppDelegate).backgroundMusic
                        if (audio?.playing != nil) {
                            audio?.stop()
                        }
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                    else if labelResultsText.lowercaseString.rangeOfString("bathroom") != nil {
                        UIApplication.sharedApplication().cancelAllLocalNotifications()
                        let audio = (UIApplication.sharedApplication().delegate as! AppDelegate).backgroundMusic
                        if (audio?.playing != nil) {
                            audio?.stop()
                        }
                      self.dismissViewControllerAnimated(true, completion: nil)
                    }
                   else if labelResultsText.lowercaseString.rangeOfString("faucet") != nil {
                        UIApplication.sharedApplication().cancelAllLocalNotifications()
                        let audio = (UIApplication.sharedApplication().delegate as! AppDelegate).backgroundMusic
                        if (audio?.playing != nil) {
                            audio?.stop()
                        }
                           self.dismissViewControllerAnimated(true, completion: nil)
                    }
                    else if labelResultsText.lowercaseString.rangeOfString("soap") != nil {
                        UIApplication.sharedApplication().cancelAllLocalNotifications()
                        let audio = (UIApplication.sharedApplication().delegate as! AppDelegate).backgroundMusic
                        if (audio?.playing != nil) {
                            audio?.stop()
                        }
                       self.dismissViewControllerAnimated(true, completion: nil)
                    }
                    else {
                        var outputText = "We couldn't find a sink! Try Again! We found: "
                        outputText += labelResultsText
                        self.errorLabel.text = outputText
                        self.errorLabel.hidden = false
//                        self.camfindOutputLabel.text = outputText
//                        self.camfindOutputLabel.hidden = false
                    }



                   // self.labelResults.text = labelResultsText
                } else {
                    self.errorLabel.text = "Nothing Found!"
                   
                }
            }
        })
        
    }
    

    override func viewDidAppear(animated: Bool) {
        
    }
    
    
    
    
   
    
    
}
