//
//  FetchSongParameter.swift
//  Bean
//
//  Created by Broccoli on 2017/1/23.
//  Copyright © 2017年 Bean. All rights reserved.
//

import Foundation
import ObjectMapper

private func randomString() -> String {
    let rand1 : UInt32 = arc4random()
    let rand2 : UInt32 = arc4random()
    return String(format:"%5x%5x",((rand1 & 0xfffff) | 0x10000), rand2)
}

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

struct FetchSongParameter {
    var type = ""
    var channel = 0
    var sid = ""
    var h = [:].hString()
    var r = randomString()
    var from = "mainsite"
    var kbps = "64"
    
    func toJSON() -> [String : Any] {
        return ["type": type,
                "channel": channel,
                "sid": sid,
                "h": h,
                "r": r,
                "from": from,
                "kbps": kbps]
    }
}
