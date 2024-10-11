//
//  PlanDataProviderTests.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 24.08.2024.
//

import XCTest
@testable import Plan

final class PlanDataProviderTests: XCTestCase {

	var sut: DataProvider<PlanContent>!

	let type: DocumentType = .plan

	override func setUpWithError() throws {
		sut = DataProvider()
	}

	override func tearDownWithError() throws {
		sut = nil
	}
}

// MARK: - ContentProvider interface testing (v1.0.0)
extension PlanDataProviderTests {

	func test_readFromDataOfType_whenV1_0_0() throws {
		// Arrange

		let expectedContent = PlanContent(
			uuid: .uuid0,
			hierarchy: [
				Node<ItemContent>(
					value: .init(
						uuid: .uuid1,
						created: Date(timeIntervalSince1970: 1723315099),
						text: "Item 0",
						status: .open,
						iconName: .folder,
						count: 0,
						options: [],
						priority: .medium
					)
				),
				Node<ItemContent>(
					value: .init(
						uuid: .uuid2,
						created: Date(timeIntervalSince1970: 1723315099),
						text: "Item 1",
						status: .done(completed: Date(timeIntervalSince1970: 1723316999)),
						iconName: .folder,
						count: 3,
						options: .favorite,
						priority: .high
					),
					children: [
						Node<ItemContent>(
							value: .init(
								uuid: .uuid3,
								created: Date(timeIntervalSince1970: 1723315099),
								text: "Item 1_0",
								status: .open,
								options: [],
								priority: .low
							)
						)
					]
				)
			]
		)

		let version = "1_0_0"

		let data = try loadFile("mock_plan_doc_v\(version)")

		// Act
		let content = try sut.read(from: XCTUnwrap(data), ofType: type.rawValue)

		// Assert
		XCTAssertEqual(content, expectedContent)
	}

	func test_readFromDataOfType_whenVersionIsUnknown() throws {

		let version = "1_0_0"

		// Arrange
		let data = try loadFile("mock_plan_doc_unknown_version_v\(version)")

		var isError = false

		do {
			// Act
			let _ = try sut.read(from: XCTUnwrap(data), ofType: type.rawValue)
		} catch let error as DocumentError where error == .unknownVersion {
			isError = true
		}

		// Assert
		XCTAssertTrue(isError)
	}

	func test_readFromDataOfType_whenFormatIsUnexpected() throws {

		let version = "1_0_0"

		// Arrange
		let data = try loadFile("mock_plan_doc_unexpected_format_v\(version)")

		var isError = false

		// Act
		do {
			let _ = try sut.read(from: XCTUnwrap(data), ofType: type.rawValue)
		} catch let error as DocumentError where error == .unexpectedFormat {
			isError = true
		}

		// Assert
		XCTAssertTrue(isError)
	}
}

extension PlanDataProviderTests {

	func test_readFromDataOfType_whenV1_1_0() throws {
		// Arrange

		let expectedContent = PlanContent(
			uuid: .uuid0,
			hierarchy: [
				Node<ItemContent>(
					value: .init(
						uuid: .uuid1,
						created: Date(timeIntervalSince1970: 1723315099),
						text: "Item 0",
						status: .open,
						iconName: .folder,
						count: 0,
						options: [],
						priority: .medium,
						iconColor: .red
					)
				),
				Node<ItemContent>(
					value: .init(
						uuid: .uuid2,
						created: Date(timeIntervalSince1970: 1723315099),
						text: "Item 1",
						status: .done(completed: Date(timeIntervalSince1970: 1723316999)),
						iconName: .folder,
						count: 3,
						options: .favorite,
						priority: .high,
						iconColor: .orange
					),
					children: [
						Node<ItemContent>(
							value: .init(
								uuid: .uuid3,
								created: Date(timeIntervalSince1970: 1723315099),
								text: "Item 1_0",
								status: .open,
								options: [],
								priority: .low,
								iconColor: nil
							)
						)
					]
				)
			]
		)

		let version = "1_1_0"

		let data = try loadFile("mock_plan_doc_v\(version)")

		// Act
		let content = try sut.read(from: XCTUnwrap(data), ofType: type.rawValue)

		// Assert
		XCTAssertEqual(content, expectedContent)
	}
}

// MARK: - Helpers
private extension PlanDataProviderTests {

	func loadFile(_ name: String) throws -> Data? {
		let bundle = Bundle(for: PlanDataProviderTests.self)
		guard let path = bundle.url(forResource: name, withExtension: "json") else {
			return nil
		}
		return try Data(contentsOf: path)
	}

}
