//
//  DoubanFMAPI.swift
//  Bean
//
//  Created by Broccoli on 2017/1/8.
//  Copyright © 2017年 Bean. All rights reserved.
//

import Foundation
import Moya
import Result


let requestClosure: MoyaProvider<DoubanFM>.RequestClosure = { endpoint, done in
    var request = endpoint.urlRequest
    
    let cookie = HTTPCookie(properties: [HTTPCookiePropertyKey.domain: "douban.fm",
                                              HTTPCookiePropertyKey.name: "start",
                                              HTTPCookiePropertyKey.value: "",
                                              HTTPCookiePropertyKey.discard: true,
                                              HTTPCookiePropertyKey.path:"/"])
    HTTPCookieStorage.shared.setCookie(cookie!)
    
    done(.success(request!))
}

let DoubanFMProvider = MoyaProvider<DoubanFM>(requestClosure: requestClosure)

public enum DoubanFM {
    case fetchPlaylist([String : AnyObject])
}

extension DoubanFM: TargetType {
    public var baseURL: URL { return URL(string: "https://douban.fm/j/mine/playlist")! }
    
    public var path: String {
        switch self {
        case .fetchPlaylist:
            return ""
        }
    }
    public var method: Moya.Method {
        let cookie = HTTPCookie.init(properties: [HTTPCookiePropertyKey.domain: "douban.fm",
                                                  HTTPCookiePropertyKey.name: "start",
                                                  HTTPCookiePropertyKey.value: "",
                                                  HTTPCookiePropertyKey.discard: true,
                                                  HTTPCookiePropertyKey.path:"/"])
        HTTPCookieStorage.shared.setCookie(cookie!)
        
        switch self {
        case .fetchPlaylist:
            return .get
        }
    }
    public var parameters: [String: Any]? {
        switch self {
        case .fetchPlaylist(let param):
            return param
        }
    }
    public var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    public var task: Task {
        switch self {
        case .fetchPlaylist:
            return .request
        }
    }
    public var sampleData: Data {
        switch self {
        case .fetchPlaylist:
            return Data()
        }
    }
}

extension Dictionary {
    
    static func toString(_ object: Any) -> String {
        return String(describing: object);
    }
    
    static func urlEncode(_ object: Any) -> String {
        let inputString = toString(object);
        return inputString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    }
    
    
    func urlEncodedString() -> String {
        var parts : Array<String> = []
        for (key, value) in self {
            let encodedkey = Dictionary.urlEncode(key)
            let encodedVal = Dictionary.urlEncode(value)
            let part = String("\(encodedkey)=\(encodedVal)")
            parts.append(part!)
        }
        return parts.joined(separator: "&")
    }
}
