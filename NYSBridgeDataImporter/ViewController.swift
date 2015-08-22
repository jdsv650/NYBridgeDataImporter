//
//  ViewController.swift
//  NYSBridgeDataImporter
//
//  Created by James on 8/19/15.
//  Copyright (c) 2015 James. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var counties = [""]

    /*
    ["Niagara", "Erie", "Orleans", "Albany"]
     ["Allegany", "Bronx", "Broome", "Cattaraugus"]
     ["Cayuga", "Chautauqua", "Chemung", "Chenango", "Clinton"]
     ["Columbia", "Cortland", "Delaware", "Dutchess", "Essex"]
     ["Franklin", "Fulton", "Genesee", "Greene", "Hamilton"]
     ["Herkimer", "Jefferson", "Kings", "Lewis", "Livingston"]
    ["Madison", "Monroe", "Montgomery", "Nassau", "Manhattan"]
     ["Oneida", "Onondaga", "Ontario", "Orange"]
    ["Oswego", "Otsego",  "Putnam", "Queens", "Rensselaer"]
     ["Richmond", "Rockland",  "St%20Lawrence", "Saratoga", "Schenectady"]
    ["Schoharie",  "Schuyler",  "Seneca", "Steuben", "Suffolk"]
    ["Sullivan", "Tioga", "Tompkins", "Ulster",  "Warren"]
     ["Washington", "Wayne", "Westchester", "Wyoming", "Yates"]
    
  */
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
      // getPostedBridgesForCounty("Erie", layer: 0)  //layer 0 posted layer 1 height
      // getPostedBridgesForCounty("Niagara", layer: 1)
       
    }

    
    @IBAction func importPressed(sender: UIButton) {
        
        
        for c in counties
       {
            getPostedBridgesForCounty(c, layer: 0)
        
        }
        
    }
    
    func getPostedBridgesForCounty(county: String, layer: Int)
    {
        var urlAsString = "http://"
        
       
            let URL = NSURL(string: urlAsString)
            var mutableURLRequest = NSMutableURLRequest(URL: URL!)
            mutableURLRequest.HTTPMethod = Method.GET.rawValue
    
            let manager = Manager.sharedInstance
            let myRequest = manager.request(mutableURLRequest)
            
            myRequest.responseJSON(options: NSJSONReadingOptions.MutableContainers)
                { (request, response, data, error) in
                
                    println(request)
                    println()
                    println(response)
                    println()
                    println(data)
                    println()
                    println(error)
                    println()

                    if(error != nil)
                    {
                        println(error!.localizedDescription)
                        return
                    }
                    
                if response?.statusCode == 200
                {
                    self.parseData(data as! NSDictionary)
                }
        }

    }
    
    
    func parseData(data: NSDictionary)
    {
        var results = data["results"] as! NSArray
        
        for bridge in results
        {
            var b = Bridge()
           // println(bridge)
            
            b.country = "US"
            b.state = "NY"
            b.zip = ""
            b.numVotes = 1
            
            if let attributes = bridge["attributes"] as? NSDictionary
            {
                if let bin = attributes["BIN"] as? NSString
                {
                 println("BIN = \(bin)")
                 b.bin = bin as String
                }
                
                if let county = attributes["COUNTY_NAME"] as? NSString
                {
                    println("County Name = \(county)")
                    b.county = county as String
                }
                
                if let carried = attributes["CARRIED"] as? NSString
                {
                    println("Feature Carried = \(carried)")
                    b.featureCarried = carried as? String
                }
                
                if let crossed = attributes["CROSSED"] as? NSString
                {
                    println("Feature Crossed = \(crossed)")
                    b.featureCrossed = crossed as? String
                }
                
                if let location = attributes["LOCATION"] as? NSString
                {
                    println("Location = \(location)")
                    b.locationDescription = location as? String
                }
                
                if let posted = attributes["POSTED_LOAD_TONS"] as? NSString
                {
                    println("Posted Load Tons = \(posted)")
                    b.weightStraight = posted.doubleValue
                }
                
                if let isR = attributes["R_POSTED"] as? NSString
                {
                    println("Is R Posted = \(isR)")
                    if isR == "NO"
                    {
                        b.isRPosted = false
                    }
                    else { b.isRPosted = true  }
                }
                
                if let otherPosting = attributes["OTHER_POSTING"] as? NSString
                {
                    println("Other Posting = \(otherPosting)")
                    b.otherPosting = otherPosting as? String
                }
                
                if let postedClearanceUnder = attributes["POSTED_VRT_CLRNC_UNDER"] as? NSString
                {
                    println("Posted clearance = \(postedClearanceUnder)")
                    b.height = postedClearanceUnder.doubleValue
                }
                
                if let city = attributes["POLITICAL_UNIT"] as? NSString
                {
                    println("City = \(city)")
                    b.city = city as? String
                }
           
                
            /*
                {
                "results": [
                {
                "layerId": 0,
                "layerName": "Posted Load Bridges",
                "displayFieldName": "COUNTY_NAME",
                "foundFieldName": "COUNTY_NAME",
                "value": "NIAGARA",
                "attributes": {
                "SHAPE": "Point",
                "BIN": "3329570",
                "COUNTY_NAME": "NIAGARA",
                "CARRIED": "SLAYTON SETTMT RD",
                "CROSSED": "EIGHTEEN MILE CRK",
                "CROSSED_MIN_VERT_DESC": "Null",
                "CROSSED_TOTAL_HZ_CLNC_DESC": "Null",
                "LOCATION": "1 MILE NE OF GASPORT",
                "PRIMARY_OWNER": "County",
                "POSTED_LOAD_TONS": "15",
                "R_POSTED": "NO",
                "OTHER_POSTING": "",
                "POSTING_LEGEND": "P",
                "TOTAL_HZ_CLEARANCE_ON": "37",
                "TOTAL_HZ_CLEARANCE_UNDER": "0",
                "POSTED_VRT_CLRNC_ON": "0",
                "POSTED_VRT_CLRNC_UNDER": "0",
                "STATE_OWNED": "NO",
                "PERMITTED_VC_ON": "833",
                "PERMITTED_VC_UNDER": "0",
                "POLITICAL_UNIT": "ROYALTON TOWN",
                "CARRIED_LABEL": "SLAYTON SETTMT RD  :833'3\"",
                "OBJECTID": "781609"
                },
                "geometryType": "esriGeometryPoint",
                "geometry": {
                "x": -78.56566998707738,
                "y": 43.208322033787276,
                "spatialReference": {
                "wkid": 4269,
                "latestWkid": 4269
                }

             */
            
            }
            
            if let geometry = bridge["geometry"] as? NSDictionary
            {
                if let x = geometry["x"] as? Double
                {
                    println("x = \(x)")
                    b.longitude = x
                }
                
                if let y = geometry["y"] as? Double
                {
                    println("y = \(y)")
                    b.latitude = y
                }
                
            }
            
               addBridge(b)
        } // end for
        
    }
    
    
    func addBridge(bridge :Bridge)
    {
        var urlAsString = "http://www.myopenroad.info/Api/Bridge/Add"
        
            let params = [
                "BridgeId" : 100,
                "BIN": bridge.bin!,
                "Latitude": bridge.latitude,
                "Longitude": bridge.longitude,
                "FeatureCarried": "\(bridge.featureCarried!)",
                "FeatureCrossed": "\(bridge.featureCrossed!)",
                "LocationDescription": "\(bridge.locationDescription!)",
                "State": "\(bridge.state!)",
                "County": "\(bridge.county!)",
                "Township": "\(bridge.city!)",
                "Zip": "\(bridge.zip!)",
                "Country": "\(bridge.country!)",
                "WeightStraight": bridge.weightStraight!,
                "isRposted": bridge.isRPosted!,
                "OtherPosting": bridge.otherPosting!,
                "DateCreated": NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle),
                "DateModified": NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle),
                "UserCreated" : "jdsv650@yahoo.com",
                "UserModified" : "jdsv650@yahoo.com",
                "NumberOfVotes" : bridge.numVotes,
                "isLocked" : bridge.isLocked,
                "WeightCombination": bridge.weightCombo!,
                "WeightDouble": bridge.weightDouble!,
                "Height": bridge.height!,
            ]
            
            let URL = NSURL(string: urlAsString)
            var mutableURLRequest = NSMutableURLRequest(URL: URL!)
            mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            mutableURLRequest.HTTPMethod = Method.POST.rawValue
            
            let encoding = ParameterEncoding.JSON
            // was params as --- as? [String : AnyObject]
            (mutableURLRequest, _) = encoding.encode(mutableURLRequest, parameters: params as? [String : AnyObject])
            
            let manager = Manager.sharedInstance
            
            manager.request(mutableURLRequest).responseJSON(options: NSJSONReadingOptions.MutableContainers)
                { (request, response, data, error) in
                    
                    println(request)
                    println()
                    println(response)
                    println()
                    println(data)
                    println()
                    println(error)
                    println()
                    
                    if(error != nil)
                    {
                        println(error!.localizedDescription)
                        // bail out -- error getting the token
                        //self.showErrorLoginMessage(ErrorMessages.generic_network.rawValue)
                        return
                    }
                    
                    if response?.statusCode != 200 && response?.statusCode != 204
                    {
                       println("ERROR SAVING BRIDGE")
                    }
                    else
                    {
                        println("BRIDGE ADDED")
                    }
       }

    }
    
}

