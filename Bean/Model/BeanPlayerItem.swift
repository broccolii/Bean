//
//  BeanPlayerItem.swift
//  Bean
//
//  Created by Broccoli on 2017/1/8.
//  Copyright © 2017年 Bean. All rights reserved.
//

import Cocoa
import AVFoundation

@objc public enum ItemPlayState : Int {
    case waitToPlay, playing, playing_and_will_replay, replaying, replayed
}

@objc public protocol DMPlayableItemDelegate {
    func playableItem(_ item: BeanPlayerItem, logStateChanged: Int) -> (Void)
}

public class BeanPlayerItem: AVPlayerItem {
    // Interface variables
    public var cover : NSImage?
    public var like : Bool
    private(set) public var musicInfo : [String: AnyObject]!
    public var playState: ItemPlayState
    public var delegate: DMPlayableItemDelegate?
    
    public var floatDuration: Float {
        get {
            return Float(CMTimeGetSeconds(self.asset.duration))
        }
    }
    
    // Const variables
    static let douban_URL_prefix = "https://music.douban.com"
    
    init(WithDict aDict: Dictionary<String, AnyObject>) {
        self.musicInfo = [ "title":aDict["title"]!,
                           "artist":aDict["artist"]!,
                           "subtype":aDict["subtype"]!,
                           "albumtitle":aDict["albumtitle"]!,
                           "musicLocation":aDict["url"]!,
                           "pictureLocation":aDict["picture"]!]
        
        let pic = String(describing: aDict["picture"]!)
        self.musicInfo["largePictureLocation"] = pic.replacingOccurrences(of:"mpic", with:"lpic") as AnyObject?
        
        if aDict["aid"] != nil {
            self.musicInfo["aid"] = aDict["aid"]!
            self.musicInfo["sid"] = aDict["sid"]!
            self.musicInfo["ssid"] = aDict["ssid"]!
            self.musicInfo["length"] = Float(String(describing: aDict["length"]!))! * 1000 as AnyObject
            self.musicInfo["albumLocation"] = String("\(BeanPlayerItem.douban_URL_prefix)\(String(describing: aDict["album"]!))") as AnyObject?
        }
        
        self.like = NSString(string: String(describing: aDict["like"]!)).boolValue
        self.playState = ItemPlayState.waitToPlay
        self.cover = nil
        
        let dictURL = String(describing: aDict["url"]!)
        let aURL  = URL(string: dictURL)
        let aAsset = AVAsset(url: aURL!)
        super.init(asset: aAsset, automaticallyLoadedAssetKeys: nil)
    }
}
