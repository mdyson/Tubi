//
//  TubiTests.swift
//  TubiTests
//
//  Created by Matthew Dyson on 3/25/19.
//  Copyright © 2019 Matthew Dyson. All rights reserved.
//

import XCTest
@testable import Tubi

class LRUCacheTests: XCTestCase {
    var subject: LRUCache<String, String>!

    override func setUp() {
        subject = LRUCache<String, String>(size: 5)
    }

    func testBasicAddAndFetch() {
        subject.add(key: "hello", value: "world")
        subject.add(key: "item", value: "one")
        subject.add(key: "two", value: "2")
        subject.add(key: "three", value: "3")
        
        XCTAssertEqual(subject.get(key: "hello"), "world")
        
        subject.add(key: "four", value: "4")
        XCTAssertEqual(subject.get(key: "two"), "2")
        
        subject.add(key: "five", value: "5")
        subject.add(key: "hello", value: "new")
        XCTAssertEqual(subject.get(key: "three"), "3")
        
        subject.add(key: "seven", value: "7")
        
        XCTAssertTrue(subject.isValid(key: "three"))
        XCTAssertTrue(subject.isValid(key: "two"))
        XCTAssertTrue(subject.isValid(key: "five"))
        
        XCTAssertEqual(subject.get(key: "hello"), "new")
        XCTAssertEqual(subject.get(key: "five"), "5")
        XCTAssertEqual(subject.get(key: "seven"), "7")
        XCTAssertNil(subject.get(key: "item"))
    }
}
