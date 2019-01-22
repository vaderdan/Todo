//
//  TodoTests.swift
//  TodoTests
//
//  Created by Danny on 22.01.19.
//  Copyright © 2019 Danny Lazarov. All rights reserved.
//

import Foundation
import XCTest
import SnapshotTesting
@testable import Todo


class TodoTests: XCTestCase {
    
    override func setUp() {
//        diffTool = "ksdiff"
//        record = true
    }
    
    override func tearDown() {
    }
    
    func testAny() {
        struct User { let id: Int, name: String, bio: String }
        let user = User(id: 2, name: "Blobby", bio: "Blobbed around the world.")
        assertSnapshot(matching: user, as: .dump)
    }
}
