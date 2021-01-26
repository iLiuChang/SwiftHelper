//
//  AppInfo.swift
//  SwiftHelperDemo
//
//  Created by 刘畅 on 2021/1/23.
//  Copyright © 2021 LiuChang. All rights reserved.
//

import Foundation

public struct AppInfo {
    public static var name: String? {
        if let bundleDisplayName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String {
            return bundleDisplayName
        } else if let bundleName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String {
            return bundleName
        }

        return nil
    }

    public static var version: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }

    public static var build: String? {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
    }

    public static var bundleID: String? {
        return Bundle.main.bundleIdentifier
    }
}
