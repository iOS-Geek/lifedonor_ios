//
//  MenuViewController.swift
//  LifeDonor
//
//  Created by iOS Developer on 24/08/16.
//  Copyright © 2016 Prabh Kiran Kaur. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var menuTable: UITableView!
    var menuItems: NSArray = []
    var menuItemImages: NSArray = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let imageData = NSData(contentsOfURL: NSURL(string: NSUserDefaults.standardUserDefaults().objectForKey("logged_user_profile_image_url") as! String)!)
        userImage.image = UIImage(data: imageData!)
        
        userName.text = NSUserDefaults.standardUserDefaults().objectForKey("logged_user_name") as? String
        userEmail.text = NSUserDefaults.standardUserDefaults().objectForKey("logged_user_email") as? String
        
        
    }

    override func viewWillAppear(animated: Bool) {
        menuItems = ["Home","About Us","Edit Profile","Compatibility","Logout","Share App"]
        menuItemImages = ["log_home","log_about","log_edit","log_about","log_out","log_share"]
//        menuTable.reloadData()
        animateTable()
    }
    
    func animateTable() {
        menuTable.reloadData()
        
        let cells = menuTable.visibleCells
        let tableHeight: CGFloat = menuTable.bounds.size.height
        
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

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("menuCell", forIndexPath: indexPath)
        
        let menuLabel: UILabel = self.view.viewWithTag(51) as! UILabel
        menuLabel.text = menuItems[indexPath.row] as? String
        
        let menuImage: UIImageView = self.view.viewWithTag(50) as! UIImageView
        menuImage.image = UIImage(named: menuItemImages[indexPath.row] as! String)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.Checkmark
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
