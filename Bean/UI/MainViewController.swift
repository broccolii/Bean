//
//  MainViewController.swift
//  Bean
//
//  Created by Broccoli on 2017/1/8.
//  Copyright © 2017年 Bean. All rights reserved.
//

import Cocoa
import Alamofire
import AVFoundation



class MainViewController: NSViewController {
    
    var playerItem: BeanPlayerItem? = nil
    var musicPlayer: AVPlayer! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
//        let fetchDictionary = [
//            "type": "n" as AnyObject,
//            "channel": 1 as AnyObject,
//            "sid": "" as AnyObject,
//            "h": [:].hString() as AnyObject,
//            "r": randomString() as AnyObject,
//            "from": "mainsite" as AnyObject,
//            "kbps": "64" as AnyObject]
        
        var fetchPara = FetchSongParameter()
        fetchPara.type = "n"
        fetchPara.channel = 2
        
        self.fetchSongs(with: fetchPara)
    }
    
    func fetchSongs(with parameter: FetchSongParameter) {
        
        DoubanFMProvider.request(.fetchPlaylist(parameter.toJSON())) { result in
            switch result {
            case let .success(response):
                do {
                    if let playerItem = BeanPlayerItem.getInstent(with: try response.mapJSON() as AnyObject) {
                    
                        self.playerItem = playerItem
                        self.musicPlayer = AVPlayer(playerItem: self.playerItem)
                        self.playerItem?.playState = ItemPlayState.playing
                        self.musicPlayer.actionAtItemEnd = AVPlayerActionAtItemEnd.pause
                        self.musicPlayer.play()
                        self.view.layer?.backgroundColor = NSColor.red.cgColor
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
