//
//  BecomeDonorViewController.swift
//  LifeDonor
//
//  Created by iOS Developer on 02/08/16.
//  Copyright © 2016 Prabh Kiran Kaur. All rights reserved.
//

import UIKit

class BecomeDonorViewController: UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var genderHeight: NSLayoutConstraint!
    @IBOutlet weak var bloodHeight: NSLayoutConstraint!
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var genderView: UIView!
    @IBOutlet weak var maleBtn: UIButton!
    @IBOutlet weak var femaleBtn: UIButton!
    
    @IBOutlet weak var bloodGrpView: UIView!
    @IBOutlet weak var groupAButton: UIButton!
    @IBOutlet weak var groupBButton: UIButton!
    @IBOutlet weak var groupABButton: UIButton!
    @IBOutlet weak var groupOButton: UIButton!
    @IBOutlet weak var groupANegButton: UIButton!
    @IBOutlet weak var groupBNegButton: UIButton!
    @IBOutlet weak var groupABNegButton: UIButton!
    @IBOutlet weak var groupONegButton: UIButton!
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var contactField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var monthField: UITextField!
    @IBOutlet weak var yearField: UITextField!
    @IBOutlet weak var genderField: UITextField!
    @IBOutlet weak var bloodGrpField: UITextField!
    
    @IBOutlet weak var stateTableView: UITableView!
    
    var genderStr = ""
    var bloodStr = ""
    var statesArr = [String]()
    var statesIdArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        maleBtn.alpha = 0
        femaleBtn.alpha = 0
        
        groupAButton.alpha = 0
        groupBButton.alpha = 0
        groupABButton.alpha = 0
        groupOButton.alpha = 0
        groupANegButton.alpha = 0
        groupBNegButton.alpha = 0
        groupABNegButton.alpha = 0
        groupONegButton.alpha = 0
        
        RequestManager.getFromServer("states", parameters: ["user_id" : NSUserDefaults.standardUserDefaults().objectForKey("logged_user_id") as! String,"user_security_hash" : NSUserDefaults.standardUserDefaults().objectForKey("logged_user_security_hash") as! String], completionHandler:  {(responseDict) -> Void in
            print(responseDict)
            if responseDict.valueForKey("code") as! String == "1" {
                
                if let dictionaryArray = responseDict["data"] as? Array<Dictionary<String, String>> {
                    for dict in dictionaryArray {
                        self.statesArr.append(dict["state_name"]!)
                        self.statesIdArr.append(dict["state_id"]!)
                    }
                }
                print(self.statesArr)
                
            }
            self.stateTableView.reloadData()
        })

        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statesArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("stateCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = statesArr[indexPath.row]
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel?.font = UIFont(name: "Noteworthy", size: 14)
        
        return cell
    }
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let cell : EligibilityTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as! EligibilityTableViewCell
//        cell.eligibleImageViw.image = UIImage(named: "tick")
//        idDict.updateValue("1", forKey: questionsIdArr[indexPath.row])
//        print(idDict)
//        
//    }

    
    @IBAction func genderSelectionAction(sender: AnyObject) {
        
        nameField.resignFirstResponder()
        contactField.resignFirstResponder()
        dateField.resignFirstResponder()
        monthField.resignFirstResponder()
        yearField.resignFirstResponder()
        
        UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseInOut, animations: {
            self.mainScrollView.contentSize = CGSizeMake(self.view.frame.width, self.containerView.frame.height + 100)
            self.maleBtn.alpha = 1
            self.femaleBtn.alpha = 1
            
            self.genderHeight.constant = 30
            self.genderView.setNeedsUpdateConstraints()
            self.genderView.layoutIfNeeded()
            }, completion: nil)

    }

    @IBAction func bloodGroupSelectionAction(sender: AnyObject) {
        
        nameField.resignFirstResponder()
        contactField.resignFirstResponder()
        dateField.resignFirstResponder()
        monthField.resignFirstResponder()
        yearField.resignFirstResponder()
        
        mainScrollView.contentSize = CGSizeMake(self.view.frame.width, containerView.frame.height + 100)
        UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseInOut, animations: {
            self.groupAButton.alpha = 1
            self.groupBButton.alpha = 1
            self.groupABButton.alpha = 1
            self.groupOButton.alpha = 1
            self.groupANegButton.alpha = 1
            self.groupBNegButton.alpha = 1
            self.groupABNegButton.alpha = 1
            self.groupONegButton.alpha = 1
            
            self.bloodHeight.constant = 120
            self.bloodGrpView.setNeedsUpdateConstraints()
            self.bloodGrpView.layoutIfNeeded()
            }, completion: nil)

    }
    
    @IBAction func backNavigation(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func chooseGender(sender: UIButton) {
        
        genderField.text = sender.currentTitle
        
        if sender.tag == 20 {
            genderStr = "1"
            maleBtn.setImage(UIImage(named: "select"), forState: .Normal)
       femaleBtn.setImage(UIImage(named: "no_select"), forState: .Normal)
        }
        else if sender.tag == 21 {
            genderStr = "2"
            femaleBtn.setImage(UIImage(named: "select"), forState: .Normal)
            maleBtn.setImage(UIImage(named: "no_select"), forState: .Normal)
        }
        
        UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseInOut, animations: {
            self.maleBtn.alpha = 0
            self.femaleBtn.alpha = 0
            
            self.genderHeight.constant = 1
            self.genderView.setNeedsUpdateConstraints()
            self.genderView.layoutIfNeeded()
            
            self.mainScrollView.contentSize = CGSizeMake(self.view.frame.width, self.containerView.frame.height - 100)
            
            }, completion: nil)
    }
    
    @IBAction func selectBloodGroup(sender: AnyObject) {
        
        bloodGrpField.text = sender.currentTitle
        
        if sender.tag == 30 {
            
            bloodStr = "1"
            groupAButton.setImage(UIImage(named: "select"), forState: .Normal)
            groupANegButton.setImage(UIImage(named: "no_select"), forState: .Normal)
            groupBButton.setImage(UIImage(named: "no_select"), forState: .Normal)
            groupBNegButton.setImage(UIImage(named: "no_select"), forState: .Normal)
            groupABButton.setImage(UIImage(named: "no_select"), forState: .Normal)
            groupABNegButton.setImage(UIImage(named: "no_select"), forState: .Normal)
            groupOButton.setImage(UIImage(named: "no_select"), forState: .Normal)
            groupONegButton.setImage(UIImage(named: "no_select"), forState: .Normal)

        }
        else if sender.tag == 31 {
            
            bloodStr = "2"
            groupANegButton.setImage(UIImage(named: "select"), forState: .Normal)
            groupAButton.setImage(UIImage(named: "no_select"), forState: .Normal)
            groupBButton.setImage(UIImage(named: "no_select"), forState: .Normal)
            groupBNegButton.setImage(UIImage(named: "no_select"), forState: .Normal)
            groupABButton.setImage(UIImage(named: "no_select"), forState: .Normal)
            groupABNegButton.setImage(UIImage(named: "no_select"), forState: .Normal)
            groupOButton.setImage(UIImage(named: "no_select"), forState: .Normal)
            groupONegButton.setImage(UIImage(named: "no_select"), forState: .Normal)
        }
        else if sender.tag == 32 {
            
            bloodStr = "3"
            groupBButton.setImage(UIImage(named: "select"), forState: .Normal)
            groupANegButton.setImage(UIImage(named: "no_select"), forState: .Normal)
            groupAButton.setImage(UIImage(named: "no_select"), forState: .Normal)
            groupBNegButton.setImage(UIImage(named: "no_select"), forState: .Normal)
            groupABButton.setImage(UIImage(named: "no_select"), forState: .Normal)
            groupABNegButton.setImage(UIImage(named: "no_select"), forState: .Normal)
            groupOButton.setImage(UIImage(named: "no_select"), forState: .Normal)
            groupONegButton.setImage(UIImage(named: "no_select"), forState: .Normal)
        }
        else if sender.tag == 33 {
            
            bloodStr = "4"
            groupBNegButton.setImage(UIImage(named: "select"), forState: .Normal)
            groupANegButton.setImage(UIImage(named: "no_select"), forState: .Normal)
            groupBButton.setImage(UIImage(named: "no_select"), forState: .Normal)
            groupAButton.setImage(UIImage(named: "no_select"), forState: .Normal)
            groupABButton.setImage(UIImage(named: "no_select"), forState: .Normal)
            groupABNegButton.setImage(UIImage(named: "no_select"), forState: .Normal)
            groupOButton.setImage(UIImage(named: "no_select"), forState: .Normal)
            groupONegButton.setImage(UIImage(named: "no_select"), forState: .Normal)
        }
        else if sender.tag == 34 {
            
            bloodStr = "5"
            groupABButton.setImage(UIImage(named: "select"), forState: .Normal)
            groupANegButton.setImage(UIImage(named: "no_select"), forState: .Normal)
            groupBButton.setImage(UIImage(named: "no_select"), forState: .Normal)
            groupBNegButton.setImage(UIImage(named: "no_select"), forState: .Normal)
            groupAButton.setImage(UIImage(named: "no_select"), forState: .Normal)
            groupABNegButton.setImage(UIImage(named: "no_select"), forState: .Normal)
            groupOButton.setImage(UIImage(named: "no_select"), forState: .Normal)
            groupONegButton.setImage(UIImage(named: "no_select"), forState: .Normal)
        }
        else if sender.tag == 35 {
            
            bloodStr = "6"
            groupABNegButton.setImage(UIImage(named: "select"), forState: .Normal)
            groupANegButton.setImage(UIImage(named: "no_select"), forState: .Normal)
            groupBButton.setImage(UIImage(named: "no_select"), forState: .Normal)
            groupBNegButton.setImage(UIImage(named: "no_select"), forState: .Normal)
            groupABButton.setImage(UIImage(named: "no_select"), forState: .Normal)
            groupAButton.setImage(UIImage(named: "no_select"), forState: .Normal)
            groupOButton.setImage(UIImage(named: "no_select"), forState: .Normal)
            groupONegButton.setImage(UIImage(named: "no_select"), forState: .Normal)
        }
        else if sender.tag == 36 {
            
            bloodStr = "7"
            groupOButton.setImage(UIImage(named: "select"), forState: .Normal)
            groupANegButton.setImage(UIImage(named: "no_select"), forState: .Normal)
            groupBButton.setImage(UIImage(named: "no_select"), forState: .Normal)
            groupBNegButton.setImage(UIImage(named: "no_select"), forState: .Normal)
            groupABButton.setImage(UIImage(named: "no_select"), forState: .Normal)
            groupABNegButton.setImage(UIImage(named: "no_select"), forState: .Normal)
            groupAButton.setImage(UIImage(named: "no_select"), forState: .Normal)
            groupONegButton.setImage(UIImage(named: "no_select"), forState: .Normal)
        }
        else if sender.tag == 37 {
            
            bloodStr = "8"
            groupONegButton.setImage(UIImage(named: "select"), forState: .Normal)
            groupANegButton.setImage(UIImage(named: "no_select"), forState: .Normal)
            groupBButton.setImage(UIImage(named: "no_select"), forState: .Normal)
            groupBNegButton.setImage(UIImage(named: "no_select"), forState: .Normal)
            groupABButton.setImage(UIImage(named: "no_select"), forState: .Normal)
            groupABNegButton.setImage(UIImage(named: "no_select"), forState: .Normal)
            groupOButton.setImage(UIImage(named: "no_select"), forState: .Normal)
            groupAButton.setImage(UIImage(named: "no_select"), forState: .Normal)
        }
        
        UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseInOut, animations: {
            self.groupAButton.alpha = 0
            self.groupBButton.alpha = 0
            self.groupABButton.alpha = 0
            self.groupOButton.alpha = 0
            self.groupANegButton.alpha = 0
            self.groupBNegButton.alpha = 0
            self.groupABNegButton.alpha = 0
            self.groupONegButton.alpha = 0
            
            self.bloodHeight.constant = 1
            self.bloodGrpView.setNeedsUpdateConstraints()
            self.bloodGrpView.layoutIfNeeded()
            
            self.mainScrollView.contentSize = CGSizeMake(self.view.frame.width, self.containerView.frame.height - 100)
            
            
            }, completion: nil)

    }
    @IBAction func submitAction(sender: AnyObject) {
        nameField.resignFirstResponder()
        contactField.resignFirstResponder()
        dateField.resignFirstResponder()
        monthField.resignFirstResponder()
        yearField.resignFirstResponder()
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: {
            self.mainScrollView.contentSize = CGSizeMake(self.view.frame.width, self.containerView.frame.height - 200)
            }, completion: nil)
        
        if nameField.text == "" || contactField.text == "" || stateField.text == "" || cityField.text == "" || dateField.text == "" || monthField.text == "" || yearField.text == "" || genderField.text == "" || bloodGrpField.text == "" {
            let alertController: UIAlertController = UIAlertController(title: "Alert!!", message: "Please fill all the fields.", preferredStyle: .Alert)
            let ok: UIAlertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(ok)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else {
         
//            RequestManager.getFromServer("signup", parameters: ["user_id" : NSUserDefaults.standardUserDefaults().objectForKey("logged_user_id") as! String,"user_security_hash" : NSUserDefaults.standardUserDefaults().objectForKey("logged_user_security_hash") as! String,"user_name" : nameField.text!,"user_contact" : contactField.text!,"user_address" : addressField.text!,"user_age" : ageField.text!,"blood_groups_id" : bloodStr,"user_gender" : genderStr,"user_notification" : "0"], completionHandler: {(responseDict) -> Void in
//                
//                print(responseDict)
//            
//            })
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField.tag == 4 || textField.tag == 5) {
            mainScrollView.contentSize = CGSizeMake(self.view.frame.width, containerView.frame.height + 200)
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
    
     textField.resignFirstResponder()
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: {
            self.mainScrollView.contentSize = CGSizeMake(self.view.frame.width, self.containerView.frame.height - 200)
            }, completion: nil)

        return true
        
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 3 || textField.tag == 5 {
            if textField.text?.characters.count > 9 && range.length == 0 {
                return false
            }
            // Only characters in the NSCharacterSet you choose will insertable.
            let invalidCharSet = NSCharacterSet(charactersInString: "0123456789").invertedSet
            let filtered = string.componentsSeparatedByCharactersInSet(invalidCharSet).joinWithSeparator("")
            return (string == filtered)
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
