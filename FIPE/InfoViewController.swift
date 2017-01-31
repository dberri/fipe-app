//
//  InfoViewController.swift
//  FiPE
//
//  Created by David Willian Berri on 7/11/16.
//  Copyright © 2016 David Willian Berri. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    var barColor = UIColor()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupNavBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupNavBar() {
        let navBar = navigationController?.navigationBar
        
        // Get rid of the line under nav bar
        navBar?.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navBar?.shadowImage = UIImage()
        
        // Set appearance attributes
        navBar?.translucent = false
        navBar?.barTintColor = barColor
        navBar?.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
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
