//
//  MusicTableViewCell.swift
//  LaTuneParseAttempt2
//
//  Created by Luka Ivicevic on 11/9/15.
//  Copyright © 2015 jaysl. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import AVFoundation
import AVKit

protocol CellButtonDelegate {
    
    func buttonClicked(cell : PFTableViewCell)
    
}

var delegate : CellButtonDelegate?

class FeedTableViewCell: PFTableViewCell, AVAudioPlayerDelegate {
    var delegate : CellButtonDelegate?
    
    internal var buttonEnabled : Bool? {
        get {
            return heartOutlet.enabled
        }
        
        set {
            heartOutlet.enabled = newValue!
        }
    }
    
    var tapped: ((FeedTableViewCell) -> Void)?
    
    var parseObject:PFObject?
    
    var pressedPlay = true
    
//    @IBOutlet weak var webView: YTPlayerView!
    
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var songArtistName: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var votesLabel: UILabel!
    @IBOutlet weak var nameOfUserWhoAdded: UILabel!
    @IBOutlet weak var heartOutlet: UIButton!
    @IBAction func heartButton(sender: AnyObject) {
        
        
        if(parseObject != nil) {
            if var votes:Int? = parseObject!.objectForKey("votes") as? Int {
                votes!++
                
                parseObject!.setObject(votes!, forKey: "votes")
                parseObject!.saveInBackground()
                
                votesLabel?.text = "\(votes!)"
            }
            
        }
        
        delegate?.buttonClicked(self)
        
        
    }
    
    
    @IBAction func shareButton(sender: AnyObject) {
        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            presentVC()
            
        } else {
            print("Internet connection FAILED")
            let alert = UIAlertView(title: "Woops! No Internet Connection :(", message: "Make sure your iPhone is connected to the internet!", delegate: nil, cancelButtonTitle: "OK")
            // self.pullToRefreshEnabled = false
            
            alert.show()
        }
        
    }
    
    @IBOutlet weak var playOutlet: UIButton!
    
    @IBAction func playPauseButton(sender: AnyObject) {
        
        if pressedPlay == true {
            
            let button = sender as! UIButton
            var indexPath =   self.window?.rootViewController!.indexOfAccessibilityElement(playOutlet)
            
            
            
            var pauseImage: UIImage = UIImage(named: "pause31.png")!
            
            playOutlet.setImage(pauseImage, forState: .Normal)
            
            
            pressedPlay = false
            
            print("cellPlay")
            
            
        } else {
            
            
            var playImage:UIImage = UIImage(named: "play102.png")!
            
            playOutlet.setImage(playImage, forState: .Normal)
            pressedPlay = true
            
            AudioPlayer.pause()
            print("stopCell")
        }
    }
    
    
    @IBOutlet weak var pauseOutlet: UIButton!
    @IBOutlet weak var userWhoAddedSong: UIImageView!
    
    
    func presentWebVC() {
        // self.window?.rootViewController!.presentViewController(activityVC, animated: true, completion: nil)
    }
    
    func presentVC () {
        let textToShare = "Found this song on LaTune where all the newest and best songs are curated!"
        
        if let myWebsite = NSURL(string: "http://www.twitter.com")
        {
            let objectsToShare = [textToShare, myWebsite]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            self.window?.rootViewController!.presentViewController(activityVC, animated: true, completion: nil)
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}