//
//  StringTest.swift
//  SHFoundationTests
//
//  Created by LC on 2022/8/9.
//  Copyright © 2022 LiuChang. All rights reserved.
//

import XCTest

class StringTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBase64() throws {
        let str = "liuchang"
        let ed = str.base64Encoded()
        let dd = ed!.base64Decoding()
        XCTAssert(dd == str)
    }

    func testRange() throws {
        let str = "liuchang"
        XCTAssert(str[safe: 0..<100] == nil)
        XCTAssert(str[safe: 0..<2]! == "li")

    }

}
