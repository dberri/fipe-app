//
//  DetailViewController.swift
//  FIPE
//
//  Created by David Willian Berri on 5/27/16.
//  Copyright © 2016 David Willian Berri. All rights reserved.
//

import UIKit
import GoogleMobileAds

class DetailViewController: UIViewController, GADBannerViewDelegate {
    
    @IBOutlet weak var vehicleIcon: UIImageView!
    @IBOutlet weak var yearIcon: UIImageView!
    @IBOutlet weak var fuelIcon: UIImageView!
    @IBOutlet weak var codeIcon: UIImageView!
    @IBOutlet weak var priceIcon: UIImageView!
    
    @IBOutlet weak var vehicleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var fuelLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var homeButton: UIButton!
    
    var tipo = String()
    var id: String!
    var url: String!
    var urlString: String!
    
    var mainColor = UIColor()
    
    var name = String()
    var year = String()
    var fuel = String()
    var code = String()
    var price = String()
    
    @IBOutlet weak var banner: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if id == nil {
            urlString = url
            
        } else {
            urlString = url.stringByReplacingOccurrencesOfString(".json", withString: ("/" + id + ".json"))
            navigationController?.navigationBar.tintColor = UIColor.whiteColor()
            
        }
        
        
        (name, year, fuel, code, price) = DataManager.getDetails(urlString)
        
        if year == "32000" {
            year = "Zero Km"
        }
        
        setup()
        loadBanner()
        
        
        if id != nil {
            // Save the vehicle to the history
            let defaults = NSUserDefaults.standardUserDefaults()
            var history = defaults.objectForKey("History") as? [[String]] ?? [[String]]()
            history.append([name, urlString])
            defaults.setObject(history, forKey: "History")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup() {
        
        let names = [tipo, "date", "fuel", "bar", "price"]
        let icons = [vehicleIcon, yearIcon, fuelIcon, codeIcon, priceIcon]
        let labels = [vehicleLabel, yearLabel, fuelLabel, codeLabel, priceLabel]
        let results = [name, year, fuel, code, price]
        
        for i in 0...4 {
            let origImg = UIImage(named: names[i])
            let tintedImage = origImg?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            icons[i].image = tintedImage
            icons[i].tintColor = mainColor
            
            labels[i].text = results[i]
        }
        
        let origImg = UIImage(named: "home")
        let tintedImage = origImg?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        homeButton.setImage(tintedImage, forState: .Normal)
        homeButton.tintColor = UIColor.whiteColor()
        
        homeButton.layer.backgroundColor = mainColor.CGColor
        homeButton.layer.cornerRadius = 10
        homeButton.layer.borderColor = UIColor.blackColor().CGColor
        homeButton.layer.borderWidth = 1
    }
    
    func loadBanner() {
        
        banner.hidden = true
        
        banner.delegate = self
        banner.adUnitID = "ca-app-pub-5961478542405743/1666024910"
        banner.rootViewController = self
        let req = GADRequest()
        req.testDevices = ["85EA0085-F172-465B-8BD5-C4C8D91FBE3C","36d2cf0f188bb90330ae31914791cea44771eac7", "9cd5bef36835f01e6b3da5247a71d0ad"]
        banner.loadRequest(req)
        self.view.addSubview(banner)
    }
    
    func adViewDidReceiveAd(bannerView: GADBannerView!) {
        banner.hidden = false
    }
    
    func adView(bannerView: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!) {
        banner.hidden = true
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
