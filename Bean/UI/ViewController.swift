//
//  ViewController.swift
//  Bean
//
//  Created by Broccoli on 2017/1/8.
//  Copyright © 2017年 Bean. All rights reserved.
//

import Cocoa
import Alamofire
import AVFoundation

extension Dictionary {
    func hString() -> String {
        var parts : Array<String> = []
        for (key, value) in self {
            let part = String("\(Dictionary.toString(key)):\(Dictionary.toString(value))")
            parts.append(part!)
        }
        return parts.joined(separator: "|")
    }
}

class ViewController: NSViewController {
    
    var playerItem: BeanPlayerItem? = nil
    var musicPlayer: AVPlayer! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        func randomString() -> String {
            let rand1 : UInt32 = arc4random()
            let rand2 : UInt32 = arc4random()
            return String(format:"%5x%5x",((rand1 & 0xfffff) | 0x10000), rand2)
        }
        
        let fetchDictionary : [String : AnyObject] = [
            "type": "n" as AnyObject,
            "channel": 1 as AnyObject,
            "sid": "" as AnyObject,
            "h": [:].hString() as AnyObject,
            "r": randomString() as AnyObject,
            "from": "mainsite" as AnyObject,
            "kbps": "64" as AnyObject]
        
        self.fetchSongs(withDictionary: fetchDictionary)
    }
    
    func fetchSongs(withDictionary dic: [String : AnyObject]) {
        DoubanFMProvider.request(.fetchPlaylist(dic)) { result in
            switch result {
            case let .success(response):
                do {
                    if let jDict = try response.mapJSON() as? [String : AnyObject] {
                        let jrVal = jDict["r"] as! Int
                        
                        // Something's wrong
                        if jrVal != 0 {
                            // failure
                        } else {
                            let jList = jDict["song"] as! [[String : AnyObject]]
                            self.playerItem = BeanPlayerItem(WithDict: jList[0])
                            self.musicPlayer = AVPlayer(playerItem: self.playerItem)
                            self.playerItem?.playState = ItemPlayState.playing
                            self.musicPlayer.actionAtItemEnd = AVPlayerActionAtItemEnd.pause
                            self.musicPlayer.play()
                            self.view.layer?.backgroundColor = NSColor.red.cgColor
                        }
                    } else {
                        
                    }
                } catch {
                    // failure
                }
                
            case let .failure(error):
                guard error is CustomStringConvertible else {
                    break
                }
                // failure
            }
        }
    }
}
