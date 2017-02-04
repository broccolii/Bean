//
//  BeanPlayerItem.swift
//  Bean
//
//  Created by Broccoli on 2017/1/8.
//  Copyright © 2017年 Bean. All rights reserved.
//

import Cocoa
import AVFoundation
import ObjectMapper

@objc public enum ItemPlayState : Int {
    case waitToPlay, playing, playing_and_will_replay, replaying, replayed
}

@objc public protocol DMPlayableItemDelegate {
    func playableItem(_ item: BeanPlayerItem, logStateChanged: Int) -> (Void)
}

extension String {
    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }
    
}

public struct MusicInfo: Mappable {
    
    var like = false
    var title = ""
    var artist = ""
    var subtype = ""
    var albumtitle = ""
    // TODO: name
    var musicLocation = ""
    private var pictureLocation = ""
    var largePictureLocation = ""
    var aid: String? = ""
    var sid = ""
    var ssid = ""
    var length: Double = 0.0
    var album = ""
    
    static let kDoubanMusicURL = "https://music.douban.com/subject/3645475/"
    
    public init?(map: Map) {
        
    }
    
    public mutating func mapping(map: Map) {
        
        like                <- map["like"]
        title               <- map["title"]
        artist              <- map["artist"]
        subtype             <- map["subtype"]
        albumtitle          <- map["albumtitle"]
        musicLocation       <- map["url"]
        pictureLocation     <- map["picture"]
        
        largePictureLocation = pictureLocation.replacingOccurrences(of:"mpic", with:"lpic")
        aid <- map["aid"]
        // TODO: 可能会空
        sid <- map["sid"]
        ssid <- map["ssid"]
        length <- map["length"]
        length = length * 1000.0
        
        album <- map["album"]
        album = MusicInfo.kDoubanMusicURL + album
    }
}

extension Dictionary {
    public func jsonString(prettify: Bool = false) -> String? {
        guard JSONSerialization.isValidJSONObject(self) else {
            return nil
        }
        let options = (prettify == true) ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions()
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: options)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            return nil
        }
    }
}

public class BeanPlayerItem: AVPlayerItem {
    
    public var cover: NSImage? = nil
    private(set) public var musicInfo : MusicInfo? = nil
    public var delegate: DMPlayableItemDelegate? = nil
    
    public var playState: ItemPlayState = .waitToPlay
    
    public var floatDuration: Float {
        get {
            return Float(CMTimeGetSeconds(self.asset.duration))
        }
    }
    
    init?(with ap: Any) {
        if ap is [String : AnyObject] {
            super.init(asset: Avasset(url: URL(string: "")), automaticallyLoadedAssetKeys: nil)
        } else {
            return nil
        }
    }
//    required public init?(with JSON: Any) {
//   
//        if JSON is [String : AnyObject] {
//            if let val = (JSON as! [String : AnyObject])["r"] as? Int,
//                val != 0 {
//                return nil
//            }
//            
//            if let songList = (JSON as! [String : AnyObject])["song"] as? [[String : Any]] {
//                let musicInfo = MusicInfo(JSON: songList[0])!
//                
//                if let resourceURL = URL(string: musicInfo.musicLocation) {
//                    super.init(asset: AVAsset(url: resourceURL), automaticallyLoadedAssetKeys: nil)
//                }
//            }
//            
//        } else {
//            return nil
//        }
//    }
}
