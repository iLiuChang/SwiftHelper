//
//  SwiftHelper.swift
//  SwiftHelperDemo
//
//  Created by LC on 2023/11/16.
//  Copyright © 2023 LiuChang. All rights reserved.
//

import Foundation
public struct SwiftHelperWrapper<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

/// Represents an object type that is compatible with SwiftHelper. You can use `sh` property to get a
/// value in the namespace of SwiftHelper.
public protocol SwiftHelperCompatible: AnyObject { }

/// Represents a value type that is compatible with SwiftHelper. You can use `sh` property to get a
/// value in the namespace of SwiftHelper.
public protocol SwiftHelperCompatibleValue {}

extension SwiftHelperCompatible {
    /// Gets a namespace holder for SwiftHelper compatible types.
    public var sh: SwiftHelperWrapper<Self> {
        get { return SwiftHelperWrapper(self) }
        set { }
    }
}

extension SwiftHelperCompatibleValue {
    /// Gets a namespace holder for SwiftHelper compatible types.
    public var sh: SwiftHelperWrapper<Self> {
        get { return SwiftHelperWrapper(self) }
        set { }
    }
}

