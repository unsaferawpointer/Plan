//
//  VersionTests.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 05.10.2024.
//

import XCTest
@testable import Plan

final class VersionTests: XCTestCase {

	var sut: Version!

	override func setUpWithError() throws {
		sut = Version(rawValue: "v1")
	}

	override func tearDownWithError() throws {
		sut = nil
	}
}

// MARK: - Common cases
extension VersionTests {

	func test_init_whenRawValueContainsVersionPrefix() {
		// Act
		let result = Version(rawValue: "v1")

		// Assert
		XCTAssertEqual(result, .init(major: 1, minor: 0, patch: 0))
	}

	func test_init_whenRawValueContainsOnlyMajor() {
		// Act
		let result = Version(rawValue: "1")

		// Assert
		XCTAssertEqual(result, .init(major: 1, minor: 0, patch: 0))
	}

	func test_init_whenRawValueHasNoPatch() {
		// Act
		let result = Version(rawValue: "1.12")

		// Assert
		XCTAssertEqual(result, .init(major: 1, minor: 12, patch: 0))
	}

	func test_init() {
		// Act
		let result = Version(rawValue: "v1.12.24")

		// Assert
		XCTAssertEqual(result, .init(major: 1, minor: 12, patch: 24))
	}

	func test_compare() {
		// Act
		XCTAssertFalse(Version(major: 1, minor: 0, patch: 0) < Version(major: 1, minor: 0, patch: 0))
		XCTAssertTrue(Version(major: 0, minor: 0, patch: 0) < Version(major: 1, minor: 0, patch: 0))
		XCTAssertTrue(Version(major: 1, minor: 1, patch: 0) < Version(major: 1, minor: 2, patch: 0))
		XCTAssertTrue(Version(major: 1, minor: 1, patch: 4) < Version(major: 1, minor: 1, patch: 12))
	}

}
