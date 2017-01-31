//
//  ModelsTableViewController.swift
//  FIPE
//
//  Created by David Willian Berri on 5/25/16.
//  Copyright © 2016 David Willian Berri. All rights reserved.
//

import UIKit

class ModelsTableViewController: UITableViewController {
    
    var tipo = String()
    var acao = String()
    var parametro = String()
    
    var nameAndID = [String: String]()
    var names = [String]()
    
    var barColor = UIColor()
    
    var url: String!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        url = DataManager.getModels(tipo, acao: acao, parametro: parametro)
        nameAndID = DataManager.getJSON(url)
        for (key, _) in nameAndID {
            names.append(key)
        }
        
        self.title = "Modelos"

        setupNavBar()
        
        tableView.separatorColor = barColor
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
        navBar?.tintColor = UIColor.whiteColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("modelCell", forIndexPath: indexPath) as! ModeloCell

        cell.modelLabel.text = names[indexPath.row]
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            let controller = segue.destinationViewController as! DetailViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                
                let id = nameAndID[names[indexPath.row]]!
                
                controller.tipo = self.tipo
                controller.url = self.url
                controller.id = id
                controller.mainColor = self.barColor
                
            }
    }
    
}
