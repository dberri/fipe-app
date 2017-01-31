//
//  VehiclesTableViewController.swift
//  FIPE
//
//  Created by David Willian Berri on 5/25/16.
//  Copyright © 2016 David Willian Berri. All rights reserved.
//

import UIKit

class VehiclesTableViewController: UITableViewController, UISearchBarDelegate {
    
    var tipo = String()
    var acao = String()
    
    var nameAndID = [String: String]()
    var names = [String]()
    
    var barColor = UIColor()
    
    var searchResults: [String]!
    var searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = DataManager.getVehicles(tipo, acao: acao)
        nameAndID = DataManager.getJSON(url)
        for (key, _) in nameAndID {
            names.append(key)
        }
        
        names.sortInPlace()
        
        self.title = "Veículos"
        
        setupSearchController()
        setupNavBar()
        setupSearchBar()
        
        tableView.separatorColor = barColor
    }
    
    func setupSearchController() {
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.tintColor = UIColor.whiteColor()
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        self.tableView.tableHeaderView = searchController.searchBar
        
        definesPresentationContext = true
        
        self.searchController.loadViewIfNeeded()
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
    
    func setupSearchBar() {
        let searchBar = searchController.searchBar
        
        // Get rid of the line above the search bar
        searchBar.backgroundImage = UIImage()
        
        // Set appearance attributes
        searchBar.translucent = false
        searchBar.barTintColor = barColor
        searchBar.backgroundColor = barColor
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
        return searchController.active ? searchResults.count : names.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("vehicleCell", forIndexPath: indexPath) as! VehicleCell
        
        if searchController.active && searchController.searchBar.text != "" {
            cell.vehicleLabel.text = searchResults[indexPath.row]
            
        } else {
            cell.vehicleLabel.text = names[indexPath.row]
        }
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showModels") {
            let controller = segue.destinationViewController as! ModelsTableViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                controller.tipo = self.tipo
                controller.acao = self.acao
                controller.barColor = self.barColor
                
                if searchController.active && searchController.searchBar.text != "" {
                    controller.parametro = nameAndID[searchResults[indexPath.row]]!
                    
                } else {
                    controller.parametro = nameAndID[names[indexPath.row]]!
                }
                
            }
        }
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        
        searchResults = names.filter{ brand in
            return brand.lowercaseString.containsString(searchText.lowercaseString)
            //brand.lowercaseString.hasPrefix(searchText.lowercaseString)
        }
        tableView.reloadData()
    }
    
}

extension VehiclesTableViewController: UISearchResultsUpdating {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        filterContentForSearchText(searchController.searchBar.text!)
        
    }
    
}