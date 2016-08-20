//
//  String+Extension.swift
//  SwiftHelperDemo
//
//  Created by LiuChang on 16/8/20.
//  Copyright © 2016年 LiuChang. All rights reserved.
//

extension String {
    
    public subscript (i: Int) -> Character {
        return self[self.startIndex.advancedBy(i)]
    }
    
    public subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    public subscript (r: Range<Int>) -> String {
        return substringWithRange(Range(startIndex.advancedBy(r.startIndex)..<startIndex.advancedBy(r.endIndex)))
    }
}
