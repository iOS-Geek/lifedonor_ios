//
//  EligibilityController.swift
//  LifeDonor
//
//  Created by iOS Developer on 01/08/16.
//  Copyright © 2016 Prabh Kiran Kaur. All rights reserved.
//

import UIKit

class EligibilityController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var moreInfoView: UIView!
    @IBOutlet weak var eligibleTable: UITableView!
    var questionsArr = [String]()
    var questionsIdArr = [String]()
    var idDict = [String:String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        moreInfoView.alpha = 0;
        
        eligibleTable.tableFooterView = UIView()
        eligibleTable.allowsMultipleSelection = true
        RequestManager.getFromServer("questions", parameters: ["user_id" : NSUserDefaults.standardUserDefaults().objectForKey("logged_user_id") as! String,"user_security_hash" : NSUserDefaults.standardUserDefaults().objectForKey("logged_user_security_hash") as! String], completionHandler:  {(responseDict) -> Void in
            print(responseDict)
            if responseDict.valueForKey("code") as! String == "1" {
                
                if let dictionaryArray = responseDict["data"] as? Array<Dictionary<String, String>> {
                    for dict in dictionaryArray {
                        self.questionsArr.append(dict["question_name"]!)
                        self.questionsIdArr.append(dict["question_id"]!)
                    }
                }
                print(self.questionsArr)
                for id in 1...self.questionsIdArr.count {
                    print(id)
                    self.idDict["\(id)"] = "0"
                }
                print(self.idDict)
            }
            else {
                let alertController: UIAlertController = UIAlertController(title: "Try Again", message: "There seems to be some problem. Please try again.", preferredStyle: .Alert)
                let ok: UIAlertAction = UIAlertAction(title: "OK", style: .Default, handler: { _ in
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
                alertController.addAction(ok)
                self.presentViewController(alertController, animated: true, completion: nil)
                
            }
            self.animateTable()
        })
        
    }
    
    func animateTable() {
        eligibleTable.reloadData()
        
        let cells = eligibleTable.visibleCells
        let tableHeight: CGFloat = eligibleTable.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransformMakeTranslation(0, tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animateWithDuration(1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                cell.transform = CGAffineTransformMakeTranslation(0, 0);
                }, completion: nil)
            
            index += 1
        }
    }
    
    @IBAction func showMoreInfo(sender: AnyObject) {
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.moreInfoView.alpha = 1
            self.eligibleTable.userInteractionEnabled = false
            }, completion: nil)
        
    }
    @IBAction func closeMoreInfo(sender: AnyObject) {
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.moreInfoView.alpha = 0
            self.eligibleTable.userInteractionEnabled = true
            }, completion: nil)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionsArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell : EligibilityTableViewCell = tableView.dequeueReusableCellWithIdentifier("eligibilityCell", forIndexPath: indexPath) as! EligibilityTableViewCell
        
        if cell.selected {
            cell.eligibleImageViw.image = UIImage(named: "tick")
        }
        else
        {
            cell.eligibleImageViw.image = UIImage(named: "no_tick")
        }
        
        cell.eligibleLabel.text = questionsArr[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell : EligibilityTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as! EligibilityTableViewCell
        cell.eligibleImageViw.image = UIImage(named: "tick")
        idDict.updateValue("1", forKey: questionsIdArr[indexPath.row])
        print(idDict)
        
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell : EligibilityTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as! EligibilityTableViewCell
        cell.eligibleImageViw.image = UIImage(named: "no_tick")
        idDict.updateValue("0", forKey: questionsIdArr[indexPath.row])
        print(idDict)
    }
    
    @IBAction func checkAction(sender: AnyObject) {
        
        closeMoreInfo(self)
        
        do {
            let jsonData: NSData = try NSJSONSerialization.dataWithJSONObject(idDict, options: NSJSONWritingOptions.PrettyPrinted)
            let str = NSString(data: jsonData, encoding: NSUTF8StringEncoding)! as String
            
            RequestManager.getFromServer("answers", parameters: ["user_id" : NSUserDefaults.standardUserDefaults().objectForKey("logged_user_id") as! String,"user_security_hash" : NSUserDefaults.standardUserDefaults().objectForKey("logged_user_security_hash") as! String,"answer_details_array" : str], completionHandler: {(responseDict) -> Void in
                
                print(responseDict)
                if responseDict.valueForKey("code") as! String == "1" {
                    let alertController: UIAlertController = UIAlertController(title: (responseDict.valueForKey("message") as! String), message: nil, preferredStyle: .Alert)
                    let ok: UIAlertAction = UIAlertAction(title: "OK", style: .Default, handler: {(alert: UIAlertAction!) in
                        
                        let dataDict = responseDict.valueForKey("data")
                        NSUserDefaults.standardUserDefaults().setObject(dataDict!["user_donor_qualified"], forKey: "logged_user_donor_qualified")
                        
                        self.performSegueWithIdentifier("successAnswer", sender: self)
                        
                    })
                    alertController.addAction(ok)
                    self.presentViewController(alertController, animated: true, completion: { _ in })
                }
                else {
                    let alertController: UIAlertController = UIAlertController(title: (responseDict.valueForKey("message") as! String), message: nil, preferredStyle: .Alert)
                    let ok: UIAlertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alertController.addAction(ok)
                    self.presentViewController(alertController, animated: true, completion: { _ in })
                }
                
            })
            
            
        } catch let error as NSError {
            print(error)
        }
        
    }
    
    @IBAction func backNavigation(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
}


