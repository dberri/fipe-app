//
//  GenericTableViewController.swift
//  FIPE
//
//  Created by David Willian Berri on 5/20/16.
//  Copyright © 2016 David Willian Berri. All rights reserved.
//

import UIKit
import WebKit


class BrandsTableViewController: UITableViewController, UISearchBarDelegate {
    
    var tipo = String()
    var acao = String()
    
    var nameAndID = [String: String]()
    var names = [String]()
    
    var barColor = UIColor()
    
    var searchResults: [String]!
    var searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check if there's connection
        checkInternetStatus()
        
        let url = DataManager.getBrands(tipo, acao: acao)
        nameAndID = DataManager.getJSON(url)
        for (key, _) in nameAndID {
            names.append(key)
        }
        
        names.sortInPlace()
        
        self.title = "Marcas"
        
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
    
    func checkInternetStatus() {
        let connectionWebView = WKWebView()
        connectionWebView.loadRequest(NSURLRequest(URL: NSURL(string: "https://www.apple.com")!))
        let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            if connectionWebView.URL != nil {
                //print("true")
            }
            else {
                let alert = UIAlertController(title: "Sem Conexão", message: "Parece que você não está conectado à internet. Cheque suas configurações de rede e tente novamente.", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        })
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("brandCell", forIndexPath: indexPath) as! BrandCell
        
        if searchController.active && searchController.searchBar.text != "" {
            cell.marcaLabel.text = searchResults[indexPath.row]
            
        } else {
            cell.marcaLabel.text = names[indexPath.row]
        }

        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showVehicles") {
            let controller = segue.destinationViewController as! VehiclesTableViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                controller.tipo = self.tipo
                controller.barColor = self.barColor
                
                var name = String()
                if let searchResults = searchResults {
                    name = searchResults[indexPath.row]
                } else {
                    name = names[indexPath.row]
                }
                
                let idForName = nameAndID[name]
                controller.acao = idForName!
            }
        }
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        
        searchResults = names.filter{ brand in
            return brand.lowercaseString.containsString(searchText.lowercaseString)
        }
        tableView.reloadData()
    }

}

extension BrandsTableViewController: UISearchResultsUpdating {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {

        filterContentForSearchText(searchController.searchBar.text!)

    }
    
}
