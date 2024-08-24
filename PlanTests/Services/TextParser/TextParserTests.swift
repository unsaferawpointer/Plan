//
//  TextParserTests.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 11.08.2024.
//

import XCTest
@testable import Plan

final class TextParserTests: XCTestCase {

	var sut: TextParser!

	override func setUpWithError() throws {
		sut = TextParser(configuration: .default)
	}

	override func tearDownWithError() throws {
		sut = nil
	}
}

// MARK: - Common cases
extension TextParserTests {

	func test_parse_whenFlatList() throws {
		// Arrange
		let text =
		"""
		line 0
		line 1
		line 2
		line 3
		line 4
		line 5
		line 6
		"""

		// Act
		let result = sut.parse(from: text)

		// Assert
		XCTAssertEqual(result.count, 7)
	}

	func test_parse_whenItemsContainsWhiteSpaces() throws {
		// Arrange
		let text =
		"""
		line    0
			line 1
		line    2
			line 3
		line    4
			line 5
		line    6
		"""

		// Act
		let result = sut.parse(from: text)

		// Assert
		XCTAssertEqual(result.count, 4)
	}

	func test_parse() throws {
		// Arrange
		let text =
		"""
		line 0
			line 1
				line 2
			line 3
		line 4
			line 5
		"""

		// Act
		let result = sut.parse(from: text)

		// Assert
		XCTAssertEqual(result.count, 2)
		XCTAssertEqual(result[0].children.count, 2)
		XCTAssertEqual(result[0].children[0].children.count, 1)
		XCTAssertEqual(result[0].children[1].children.count, 0)

		// node[1]
		XCTAssertEqual(result[1].children.count, 1)
		XCTAssertEqual(result[1].value.text, "line 4")
		XCTAssertFalse(result[1].value.isDone)
		XCTAssertEqual(result[1].value.count, 0)
		XCTAssertEqual(result[1].value.options, [])
		XCTAssertFalse(result[1].value.isFavorite)
		XCTAssertNil(result[1].value.iconName)

		// node[1, 0]
		XCTAssertEqual(result[1].children[0].children.count, 0)
		XCTAssertEqual(result[1].children[0].value.text, "line 5")
		XCTAssertFalse(result[1].children[0].value.isDone)
		XCTAssertEqual(result[1].children[0].value.count, 0)
		XCTAssertEqual(result[1].children[0].value.options, [])
		XCTAssertFalse(result[1].children[0].value.isFavorite)
		XCTAssertNil(result[1].children[0].value.iconName)
	}

	func test_parse_whenPrefixIsAsterics() throws {
		// Arrange
		let text =
		"""
		* line 0
		"""

		// Act
		let result = sut.parse(from: text)

		// Assert
		XCTAssertEqual(result.count, 1)
		XCTAssertEqual(result[0].value.text, "line 0")
	}

	func test_parse_whenPrefixIsDash() throws {
		// Arrange
		let text =
		"""
		- line 0
		"""

		// Act
		let result = sut.parse(from: text)

		// Assert
		XCTAssertEqual(result.count, 1)
		XCTAssertEqual(result[0].value.text, "line 0")
	}
}
