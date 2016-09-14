//
//  ViewController.swift
//  LifeDonor
//
//  Created by iOS Developer on 05/07/16.
//  Copyright © 2016 Prabh Kiran Kaur. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var userEmail : NSString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func facebookLoginAction(sender: AnyObject) {

        let login : FBSDKLoginManager = FBSDKLoginManager()
        
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
            login.logOut()
        }
        
        
        
        login.logInWithReadPermissions(["public_profile", "email", "user_friends"], fromViewController: self, handler: { (result:FBSDKLoginManagerLoginResult!, error:NSError!) -> Void in
            
            if ((error) != nil)
            {
                // Process error
            }
            else if result.isCancelled {
                // Handle cancellations
                
                let alertController: UIAlertController = UIAlertController(title: "Try Again", message: "Login Failed from facebook", preferredStyle: .Alert)
                let ok: UIAlertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(ok)
                self.presentViewController(alertController, animated: true, completion: { _ in })
            }
            else {
                // If you ask for multiple permissions at once, you
                // should check if specific permissions missing
                if result.grantedPermissions.contains("email")
                {
                    // Do work
                    self.returnUserData()
                }
            }

            
        })
        
    }

    
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"first_name, last_name, email, id, name"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                print("fetched user: \(result)")
                let userName : NSString = result.valueForKey("name") as! NSString
                print("User Name is: \(userName)")
                
                if let val = result["email"] {
                    
                    self.userEmail = val as! NSString
                    print("User Email is: \(self.userEmail)")
                    
                }
                
                let userId : NSString = result.valueForKey("id") as! NSString
                print("User Id is: \(userId)")
                
                // hit facebook login api and then perform segue else window hierarchy issue
                
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                let lat = appDelegate.latitude!
                let long = appDelegate.longitude!
                
                
                //hit login api
                
                RequestManager.getFromServer("login", parameters: ["social_media_platform":"facebook", "social_media_id":userId,"user_name":userName,"user_email":self.userEmail,"user_latitude":lat,"user_longitude":long], completionHandler: {(responseDict) -> Void in
                print(responseDict)
                    if responseDict.valueForKey("code") as! String == "1" {
                        let alertController: UIAlertController = UIAlertController(title: (responseDict.valueForKey("message") as! String), message: nil, preferredStyle: .Alert)
                        let ok: UIAlertAction = UIAlertAction(title: "OK", style: .Default, handler: {(alert: UIAlertAction!) in
                            
                            let dataDict = responseDict.valueForKey("data")
                            NSUserDefaults.standardUserDefaults().setObject(dataDict!["user_name"], forKey: "logged_user_name")
                            NSUserDefaults.standardUserDefaults().setObject(dataDict!["user_id"], forKey: "logged_user_id")
                            NSUserDefaults.standardUserDefaults().setObject(dataDict!["user_security_hash"], forKey: "logged_user_security_hash")
                            NSUserDefaults.standardUserDefaults().setObject(dataDict!["user_is_donor"], forKey: "logged_user_is_donor")
                            NSUserDefaults.standardUserDefaults().setObject(dataDict!["user_gender"], forKey: "logged_user_gender")
                            NSUserDefaults.standardUserDefaults().setObject(dataDict!["user_email"], forKey: "logged_user_email")
                            NSUserDefaults.standardUserDefaults().setObject(dataDict!["user_donor_qualified"], forKey: "logged_user_donor_qualified")
                            NSUserDefaults.standardUserDefaults().setObject(dataDict!["user_contact"], forKey: "logged_user_contact")
                            NSUserDefaults.standardUserDefaults().setObject(dataDict!["user_age"], forKey: "logged_user_age")
                            NSUserDefaults.standardUserDefaults().setObject(dataDict!["user_address"], forKey: "logged_user_address")
                            NSUserDefaults.standardUserDefaults().setObject(dataDict!["user_profile_image_url"], forKey: "logged_user_profile_image_url")


                            if let someValue = dataDict!["blood_group_name"] as? String {
                                NSUserDefaults.standardUserDefaults().setObject(someValue, forKey: "logged_blood_group_name")
                            }
                            
                            self.performSegueWithIdentifier("successHome", sender: self)
                            
                        })
                        alertController.addAction(ok)
                        self.presentViewController(alertController, animated: true, completion: { _ in })

                    }
                    else {
                        let alertController: UIAlertController = UIAlertController(title: "Try Again", message: "Login Failed", preferredStyle: .Alert)
                        let ok: UIAlertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        alertController.addAction(ok)
                        self.presentViewController(alertController, animated: true, completion: { _ in })

                    }
                
                })

            }
        })
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

