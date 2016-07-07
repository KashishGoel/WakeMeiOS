//
//  SettingsViewController.swift
//  KashishGoel_TaskItApplicationForiOS
//
//  Created by Kashish Goel on 2015-07-22.
//  Copyright (c) 2015 Kashish Goel. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    @IBOutlet weak var completeNewTodoTableView: UITableView!
    
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var capitalizeTableView: UITableView!
    let kVersionNumber = "1.0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let background = UIImage(named: "background12.jpg")
      
        //self.view.backgroundColor = UIColor(patternImage: background!)

        // Do any additional setup after loading the view.
//        self.capitalizeTableView.delegate = self
//        self.capitalizeTableView.dataSource = self
//        self.capitalizeTableView.scrollEnabled = false
//        self.completeNewTodoTableView.delegate = self
//        self.completeNewTodoTableView.dataSource = self
//        self.completeNewTodoTableView.scrollEnabled = false
//        self.title = "Settings"
////        self.versionLabel.text = kVersionNumber
//        var doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("doneBarButtonItemPressed:"))
//        self.navigationItem.leftBarButtonItem = doneButton
//        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!)
    }
    
    
    @IBAction func doneButtonPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        if tableView == self.capitalizeTableView {
//            var capitalizeCell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("capitalizeCell") as! UITableViewCell
//            if indexPath.row == 0 {
//                capitalizeCell.textLabel?.text = "No do not Capitalize"
//                if NSUserDefaults.standardUserDefaults().boolForKey(kShouldCapitalizeTaskKey) == false {
//                    capitalizeCell.accessoryType = UITableViewCellAccessoryType.Checkmark
//                } else {
//                    capitalizeCell.accessoryType = UITableViewCellAccessoryType.None
//                }
//            }
//            else {
//                capitalizeCell.textLabel?.text = "Yes Capitalize!"
//                if NSUserDefaults.standardUserDefaults().boolForKey(kShouldCapitalizeTaskKey) == true {
//                    capitalizeCell.accessoryType = UITableViewCellAccessoryType.Checkmark
//                } else {
//                    capitalizeCell.accessoryType = UITableViewCellAccessoryType.None
//                }
//            }
//            return capitalizeCell
//        }
//        else {
//            var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("completeNewTodoCell") as!   UITableViewCell
//            if indexPath.row == 0 {
//                cell.textLabel!.text = "Do not complete Task"
//                if NSUserDefaults.standardUserDefaults().boolForKey(kShouldCompleteNewTodoKey) == false {
//                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
//                }
//                else {
//                    cell.accessoryType = UITableViewCellAccessoryType.None
//                }
//            }
//            else {
//                cell.textLabel!.text = "Complete Task"
//                if NSUserDefaults.standardUserDefaults().boolForKey(kShouldCompleteNewTodoKey) == true {
//                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
//                }
//                else {
//                    cell.accessoryType = UITableViewCellAccessoryType.None
//                }
//            }
//            return cell
//        }
//    }
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 2
//    }
//    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 30
//    }
//    
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if tableView == self.capitalizeTableView {
//            return "Capitalize new Task?"
//        }
//        else {
//            return "Complete new Task?"
//        }
//    }
//    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        if tableView == self.capitalizeTableView {
//            if indexPath.row == 0 {
//                NSUserDefaults.standardUserDefaults().setBool(false, forKey: kShouldCapitalizeTaskKey)
//            }
//            else {
//                NSUserDefaults.standardUserDefaults().setBool(true, forKey: kShouldCapitalizeTaskKey)
//            }
//        }
//        else {
//            if indexPath.row == 0 {
//                NSUserDefaults.standardUserDefaults().setBool(false, forKey: kShouldCompleteNewTodoKey)
//            }
//            else {
//                NSUserDefaults.standardUserDefaults().setBool(true, forKey: kShouldCompleteNewTodoKey)
//            }
//        }
//        NSUserDefaults.standardUserDefaults().synchronize()
//        tableView.reloadData()
//    }
    
    
    
    
    @IBAction func backButtonPressed(sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewControllerAnimated(false)
    }
    
    @IBAction func homeButtonPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    
    
    
}
