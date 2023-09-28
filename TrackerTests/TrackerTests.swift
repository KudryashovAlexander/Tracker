//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Александр Кудряшов on 23.09.2023.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testViewController() {
        let vc = TabBarController()
        
        assertSnapshot(matching: vc, as: .image(traits: .init(userInterfaceStyle: .light)))
        assertSnapshot(matching: vc, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }

}
