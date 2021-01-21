//
//  JSONSerialization+SH.swift
//  SwiftHelperDemo
//
//  Created by 刘畅 on 2021/1/21.
//  Copyright © 2021 LiuChang. All rights reserved.
//

import Foundation

public extension JSONSerialization {
    class func jsonObject(from jsonString: String) -> Any? {
        if let data = (try? JSONSerialization.jsonObject(
            with: jsonString.data(using: String.Encoding.utf8,
            allowLossyConversion: true)!,
            options: JSONSerialization.ReadingOptions.mutableContainers)) {
            return data
        }
        else {
            return nil
        }
    }
    
    class func jsonString(from obj: Any) -> String? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: obj, options: JSONSerialization.WritingOptions()) {
            let jsonStr = String(data: jsonData, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            return jsonStr
        }
        return nil
    }
}
