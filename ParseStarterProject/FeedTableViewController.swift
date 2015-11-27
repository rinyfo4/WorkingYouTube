//
//  FeedTableViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Luka Ivicevic on 11/13/15.
//  Copyright © 2015 Parse. All rights reserved.
//
import UIKit
import ParseUI
import Parse
import WebKit
import AVFoundation
import AVKit

public var AudioPlayer = AVPlayer()

public var isEnabled : Bool?

class FeedTableViewController: PFQueryTableViewController, AVAudioPlayerDelegate, CellButtonDelegate {
    
    
    let cellIdentifier:String = "MusicCell"
    
    
    override func viewDidLoad() {
        self.tableView.allowsSelection = false
        self.tableView.rowHeight = 400
        self.pullToRefreshEnabled = true
        
        self.tableView.frame = self.tableView.bounds
        
        tableView.registerNib(UINib(nibName: "FeedTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        super.viewDidLoad()
        
        
        
        
    }
    
    
    
    var objectArray : [AnyObject]?
    
    
    override func queryForTable() -> PFQuery {
        var query:PFQuery = PFQuery(className:"Music")
        
        if(objects?.count == 0)
        {
            query.cachePolicy = PFCachePolicy.CacheThenNetwork
            
            
            
        }
        
        query.orderByAscending("videoId")
        
        return query
    }
    
    
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        objectArray = objects
        return  objects!.count
        
    }
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        
        var cell: FeedTableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? FeedTableViewCell
        
        
        if(cell == nil) {
            
            cell = NSBundle.mainBundle().loadNibNamed("FeedTableViewCell", owner: self, options: nil)[0] as? FeedTableViewCell
        }
        
        objects![indexPath.row]
        
        if let pfObject = objectArray?[indexPath.row] {
            
            cell?.parseObject = object
//            cell?.songArtistName.text = pfObject["songName"] as? String
            
            
//            if let videoId = cell?.webView {
//                
//                var playerVars = ["playsinline" : 1]
//                
//                
//                videoId.loadWithVideoId(pfObject["videoId"] as? String, playerVars: playerVars)
//                
//            }
            
            var votes:Int? = pfObject["votes"] as? Int
            if votes == nil {
                votes = 0
                
            }
            cell?.delegate = self
            
            let isEnabled = pfObject["isEnabled"] as! Int
            if isEnabled == 1
            {
                cell?.buttonEnabled = true
            }
            else
            {
                cell?.buttonEnabled = false
            }
            
            print(pfObject["isEnabled"] as? Bool)
            
            
            
            cell?.votesLabel?.text = "\(votes!)"
            
            cell?.nameOfUserWhoAdded.text = pfObject["addedBy"] as? String
            
//            cell?.genre.text = pfObject["genre"] as? String
            
            cell?.userWhoAddedSong?.image = nil
            if var urlString:String? = pfObject["photoOfUser"] as? String {
                
                if var url:NSURL? = NSURL(string: urlString!) {
                    var error:NSError?
                    var request:NSURLRequest = NSURLRequest(URL: url!, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 5.0)
                    
                    NSOperationQueue.mainQueue().cancelAllOperations()
                    
                    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {
                        (response, imageData, error) -> Void in
                        
                        (cell?.userWhoAddedSong?.image = UIImage(data: imageData!))!
                        
                    })
                }
            }
            
            
            
            var createdAt =  pfObject.createdAt
            if createdAt != nil {
                let calendar = NSCalendar.currentCalendar()
                let comps = calendar.components([.Day, .Month, .Year, .Hour, .Minute, .Second], fromDate: createdAt as NSDate!)
                let hours = comps.hour
                let minutes = comps.minute
                let seconds = comps.second
                let day = comps.day
                let month = comps.month
                let year = comps.year
                
                cell?.timeLabel.text = "@ \(String(format: "%02dh on %02d/%02d", hours, day, month))"
                
                
            }
            
        }
        
        return cell
        
    }
    
    
    
    func buttonClicked(cell : PFTableViewCell) {
        
        let indexPath = tableView.indexPathForCell(cell)
        
        
        var object : PFObject = objectArray![indexPath!.row] as! PFObject
        
        object["isEnabled"] = 0
        objectArray?.removeAtIndex((indexPath?.row)!)
        objectArray?.insert(object, atIndex: (indexPath?.row)!)
        self.tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .None)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
}