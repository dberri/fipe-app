//
//  HistoryTableViewController.swift
//  FIPE
//
//  Created by David Willian Berri on 5/25/16.
//  Copyright © 2016 David Willian Berri. All rights reserved.
//

import UIKit
import WebKit

class HistoryTableViewController: UITableViewController {
    
    var barColor = UIColor()
    var history: [[String]]!
    var names = [String]()
    var urls = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = barColor
        
        history = DataManager.loadHistory()
        
        if history != nil {
            for index in history {
                names.append(index[0])
                urls.append(index[1])
            }
        }
        
        self.title = "Histórico"
        
        navigationItem.rightBarButtonItem = editButtonItem()
        
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
        return history.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("historyCell", forIndexPath: indexPath) as! HistoryCell
        
        
        let name = names[indexPath.row]
        cell.historyLabel.text = name
        
        return cell
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            
            history.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(history, forKey: "History")
        
        if segue.identifier == "history" {
            
            checkInternetStatus()
            
            let controller = segue.destinationViewController as! DetailViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                
                let url = urls[indexPath.row]
                
                controller.url = url
                controller.mainColor = barColor
                controller.tipo = "carros"
                controller.navigationController?.navigationBar.tintColor = barColor
            }
        }
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
}

