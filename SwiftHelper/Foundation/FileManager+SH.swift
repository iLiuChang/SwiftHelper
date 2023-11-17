//
//  FileManager+SH.swift
//  SwiftHelper (https://github.com/iLiuChang/SwiftHelper)
//
//  Created by LiuChang on 2022/8/9.
//  Copyright © 2022 LiuChang. All rights reserved.
//

import Foundation

public extension FileManager {
    struct SH {
        /// ...
        public static var homeDirectory: String {
            return NSHomeDirectory()
        }

        /// .../Documents
        public static var documentsDirectory: String {
            return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        }
        
        /// .../Library
        public static var libraryDirectory: String {
            return NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first!
        }
        
        /// .../Library/Caches
        public static var cachesDirectory: String {
            return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
        }

        /// .../Library/Preferences
        public static var preferencesDirectory: String {
            return NSHomeDirectory() + "/Library/Preferences"
        }
        
        /// .../tmp/
        public static var tmpDirectory: String {
            return NSTemporaryDirectory()
        }
        
        /// creates a folder at the specified path. The intermediate directory will be created automatically if it does not exist.
        @discardableResult
        public static func createFolder(atPath path: String) -> Error? {
            if FileManager.default.fileExists(atPath: path) {
                return nil
            }
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
                return nil
            } catch let error {
                return error
            }
        }
        
        /// creates a file at the specified path.
        @discardableResult
        public static func createFile(atPath path: String, data: Data? = nil) -> Bool {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
            return FileManager.default.createFile(atPath: path, contents: data, attributes: nil)
        }

    }
}

