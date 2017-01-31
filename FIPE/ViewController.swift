//
//  ViewController.swift
//  FIPE
//
//  Created by David Willian Berri on 5/20/16.
//  Copyright © 2016 David Willian Berri. All rights reserved.
//

import UIKit
import GoogleMobileAds

public enum Color: Int {
    case Code = 0
    case Carro, Caminhao, Moto, Info
    
    
    var mainColor: UIColor {
        switch self {
        case .Code:
            /* Codigo */
            return UIColor(red: 67/255, green: 179/255, blue: 243/255, alpha: 1.0)
            
        case .Carro:
            /* Carros */
            return UIColor(red: 29/255, green: 171/255, blue: 218/255, alpha: 1.0)
            
        case .Caminhao:
            /* Caminhao */
            return UIColor(red: 27/255, green: 171/255, blue: 187/255, alpha: 1.0)
            
        case .Moto:
            /* Moto */
            return UIColor(red: 26/255, green: 170/255, blue: 160/255, alpha: 1.0)
            
        case .Info:
            /* Info */
            return UIColor(red: 161/255, green: 161/255, blue: 161/255, alpha: 1.0)
        }
    }
}


class ViewController: UIViewController, GADBannerViewDelegate {
    
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet var label: UILabel!
    
    let buttonTitles = ["Carros", "Caminhões", "Motocicletas"]
    var heightOfView: CGFloat!
    var heightOfTopConstraint: CGFloat!
    
    @IBOutlet weak var banner: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        heightOfView = self.view.frame.size.height
        let h = (heightOfView - 460.0)/2.0
        
        if (h > 80){
            heightOfTopConstraint = 80
            
        } else {
            
            heightOfTopConstraint = h - 20
        }
        
        label.topAnchor.constraintEqualToAnchor(self.topLayoutGuide.bottomAnchor, constant: heightOfTopConstraint).active = true
        
        for i in 0...4 {
            
            let button = buttons[i]
            let color: Color!
            if i < 3 {
                color = Color(rawValue: i)
                button.titleLabel?.font = UIFont(name: "Avenir Next", size: 24)
                button.setTitle(buttonTitles[i], forState: .Normal)
                
                
                let h = NSLayoutConstraint(item: button, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: 64)
                let w = NSLayoutConstraint(item: button, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1, constant: 218)
                button.addConstraints([h,w])
                
            } else {
                
                color = Color.Info
                
                let h = NSLayoutConstraint(item: button, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: 64)
                
                button.addConstraint(h)
            }
            
            setupButtons(buttons[i], color: color)
        }
        
        loadBanner()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupButtons(button: UIButton, color: Color?) {
        
        let layer = button.layer
        
        layer.borderWidth = 2
        layer.borderColor = color?.mainColor.CGColor
        layer.cornerRadius = 15
        
        button.titleLabel?.tintColor = color?.mainColor
        button.setTitleColor(color?.mainColor, forState: .Normal)
        
        button.addTarget(self, action: #selector(ViewController.buttonTapped(_:)), forControlEvents: .TouchUpInside)
        
    }
    
    func buttonTapped(sender: UIButton) {
        animateButtons(sender)
        
        if sender.tag == 5 {
            performSegueWithIdentifier("info", sender: sender)
        } else if sender.tag < 4 {
            performSegueWithIdentifier("customSegue", sender: sender)
        } else if sender.tag == 4 {
            performSegueWithIdentifier("history", sender: sender)
        }
        
    }
    
    func animateButtons(button: UIButton) {
        UIView.animateAndChainWithDuration(0.3, delay: 0.0, options: [.CurveEaseInOut], animations: {
            button.layer.opacity = 0.5
            button.layer.backgroundColor = button.layer.borderColor
            button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            
            }, completion: nil).animateWithDuration(0.2, animations: {
                button.layer.backgroundColor = UIColor.clearColor().CGColor
                button.setTitleColor(button.titleLabel?.tintColor, forState: .Normal)
                button.layer.opacity = 1
            })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (sender as! UIButton).tag < 4 {
            
            let navVC = segue.destinationViewController as! UINavigationController
            let table = navVC.viewControllers.first as! BrandsTableViewController
            
            if sender?.tag == 1 {
                table.tipo = "carros"
                table.barColor = Color.Carro.mainColor
            } else if sender?.tag == 2 {
                table.tipo = "caminhoes"
                table.barColor = Color.Caminhao.mainColor
            } else if sender?.tag == 3 {
                table.tipo = "motos"
                table.barColor = Color.Moto.mainColor
            }
            
            table.acao = "marcas"
            
        } else if (sender as! UIButton).tag == 4 {
            
            let navVC = segue.destinationViewController as! UINavigationController
            let table = navVC.viewControllers.first as! HistoryTableViewController
            
            table.barColor = Color.Info.mainColor
            
        } else if (sender as! UIButton).tag == 5 {
            
            let navVC = segue.destinationViewController as! UINavigationController
            let table = navVC.viewControllers.first as! InfoViewController
            
            table.barColor = Color.Info.mainColor
        }
    }
        
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        
    }
    
    func loadBanner() {
        
        banner.hidden = true
        
        banner.delegate = self
        banner.adUnitID = "ca-app-pub-5961478542405743/1666024910"
        banner.rootViewController = self
        let req = GADRequest()
        req.testDevices = [kGADSimulatorID,"36d2cf0f188bb90330ae31914791cea44771eac7", "9cd5bef36835f01e6b3da5247a71d0ad"]
        banner.loadRequest(req)
        self.view.addSubview(banner)
    }
    
    func adViewDidReceiveAd(bannerView: GADBannerView!) {
        banner.hidden = false
    }
    
    func adView(bannerView: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!) {
        banner.hidden = true
    }
}

