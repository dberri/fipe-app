//
//  DataManager.swift
//  FIPE
//
//  Created by David Willian Berri on 5/20/16.
//  Copyright © 2016 David Willian Berri. All rights reserved.
//

import Foundation

public class DataManager: NSObject {
    
    
    public class func getBrands(tipo: String, acao: String) -> String {
        
        var urlString = String()
        let basicURL = "http://fipeapi.appspot.com/api/1/"
        
        // Forma o link para o JSON de marcas "http://fipeapi.appspot.com/api/1/[tipo]/marcas.json"
        urlString = basicURL.stringByAppendingString(tipo + "/" + acao + ".json")
        
        return urlString
    }
    
    public class func getVehicles(tipo: String, acao: String) -> String {
        
        var urlString = String()
        let basicURL = "http://fipeapi.appspot.com/api/1/"
        
        // Forma o link para o JSON de veiculos da marca "http://fipeapi.appspot.com/api/1/[tipo]/veiculos/[id].json"
        urlString = basicURL.stringByAppendingString(tipo + "/veiculos/" + acao + ".json")
        
        return urlString
    }
    
    public class func getModels(tipo: String, acao: String, parametro: String) -> String {
        
        var urlString = String()
        let basicURL = "http://fipeapi.appspot.com/api/1/"
        
        // Forma o link para o JSON de modelos "http://fipeapi.appspot.com/api/1/[tipo]/veiculo/[id]/[parametro].json"
        let url = basicURL.stringByAppendingString(tipo + "/veiculo/" + acao)
        urlString = url.stringByAppendingString("/" + parametro + ".json")

        return urlString
    }
    
    public class func getJSON(urlString: String) -> [String: String] {
        
        var dict = [String: String]()
        
        if let url = NSURL(string: urlString) {
            if let data = try? NSData(contentsOfURL: url, options: []) {
                let json = JSON(data: data)
                
                dict = parseJSON(json)
                
            } else {
                // Not a valid json
                
                // showError()
            }
        } else {
            // not a valid url?
            
            //showError()
        }
        
        return dict
    }
    
    
    public class func parseJSON(json: JSON) -> [String: String] {
        
        var dict = [String: String]()
        var name = String()
        var id = String()
        
        for i in 0...json.count - 1 {
            name = json[i]["name"].string!
            
            if let maybeId = json[i]["id"].int {
                id = String(maybeId)
            } else {
                id = json[i]["id"].string!
            }
            
            dict[name] = id
            
        }
        
        return dict
    }
    
    public class func getDetails(urlString: String) -> (String, String, String, String, String) {
        
        var name = String()
        var year = String()
        var fuel = String()
        var code = String()
        var price = String()
        
        if let url = NSURL(string: urlString) {
            if let data = try? NSData(contentsOfURL: url, options: []) {
                let json = JSON(data: data)

                name = json["name"].string!
                year = json["ano_modelo"].string!
                fuel = json["combustivel"].string!
                code = json["fipe_codigo"].string!
                price = json["preco"].string!
                
            } else {
                // Not a valid json
                
                // showError()
            }
        } else {
            // not a valid url?
            
            //showError()
        }
        
        return (name, year, fuel, code, price)
    }
    
    public class func loadHistory() -> [[String]] {
        var history = [[String]]()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if defaults.objectForKey("History") != nil {
            history = defaults.objectForKey("History") as? [[String]] ?? [[String]]()
        }
        
        return history
        
    }
    
}
