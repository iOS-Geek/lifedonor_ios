//
//  HomeViewController.swift
//  LifeDonor
//
//  Created by iOS Developer on 18/07/16.
//  Copyright © 2016 Prabh Kiran Kaur. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController,UIScrollViewDelegate {

    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var displayScrollView: UIScrollView!
    @IBOutlet weak var pager: UIPageControl!
    var frame: CGRect = CGRectMake(0, 0, 0, 0)
    let scrollArray = ["slider_1","slider_2"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        if self.revealViewController() != nil {
//            menuButton.target = self.revealViewController()
//            menuButton.action = "revealToggle:"
            menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), forControlEvents: .TouchUpInside)
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        displayScrollView.contentSize = CGSizeMake(displayScrollView.frame.size.width * CGFloat(scrollArray.count), displayScrollView.frame.size.height)
        displayScrollView.pagingEnabled = true
        displayScrollView.delegate = self
        
        for index in 0..<scrollArray.count {
            frame.origin.x = displayScrollView.frame.size.width * CGFloat(index)
            frame.size = displayScrollView.frame.size
            let imgView = UIImageView(frame: frame)
            imgView.image = UIImage(named: scrollArray[index])!
            displayScrollView.addSubview(imgView)
        }
        
        pager.numberOfPages = scrollArray.count
        pager.currentPage = 0

    }
    
    // MARK: - scrollview delegate
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollView == displayScrollView {
            let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
            pager.currentPage = Int(pageNumber)
        }
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
