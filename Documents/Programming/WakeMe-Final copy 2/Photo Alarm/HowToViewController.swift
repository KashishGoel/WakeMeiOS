//
//  HowToViewController.swift
//  Photo Alarm
//
//  Created by Kashish Goel on 2015-09-05.
//  Copyright (c) 2015 Kashish Goel. All rights reserved.
//

import UIKit

class HowToViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //let background = UIImage(named: "background12.jpg")
        
        //self.view.backgroundColor = UIColor(patternImage: background!)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    @IBAction func doneButtonPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
   
    

   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
