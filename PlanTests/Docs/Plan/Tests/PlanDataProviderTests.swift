//
//  PlanDataProviderTests.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 24.08.2024.
//

import XCTest
@testable import Plan

final class PlanDataProviderTests: XCTestCase {

	var sut: PlanDataProvider!

	let allVersions = PlanVersion.allCases

	let type: DocumentType = .plan

	override func setUpWithError() throws {
		sut = PlanDataProvider()
	}

	override func tearDownWithError() throws {
		sut = nil
	}
}

// MARK: - ContentProvider interface testing
extension PlanDataProviderTests {

	func test_readFromDataOfType() throws {
		// Arrange

		let expectedContent = makeContent()

		for version in allVersions {
			let data = try loadFile("mock_plan_doc_\(version)")

			// Act
			let content = try sut.read(from: XCTUnwrap(data), ofType: type.rawValue)

			// Assert
			XCTAssertEqual(content, expectedContent)
		}
	}

	func test_readFromDataOfType_whenVersionIsUnknown() throws {

		for version in allVersions {
			// Arrange
			let data = try loadFile("mock_plan_doc_unknown_version_\(version)")

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
	}

	func test_readFromDataOfType_whenFormatIsUnexpected() throws {

		for version in allVersions {
			// Arrange
			let data = try loadFile("mock_plan_doc_unexpected_format_\(version)")

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

	func makeContent() -> HierarchyContent {
		HierarchyContent(
			uuid: .uuid0,
			hierarchy: [
				Node<ItemContent>(
					value: .init(
						uuid: .uuid1,
						created: Date(timeIntervalSince1970: 1723315099),
						text: "Item 0",
						status: .open,
						iconName: "folder",
						count: 0,
						options: [])
				),
				Node<ItemContent>(
					value: .init(
						uuid: .uuid2,
						created: Date(timeIntervalSince1970: 1723315099),
						text: "Item 1",
						status: .done(completed: Date(timeIntervalSince1970: 1723316999)),
						iconName: "folder",
						count: 3,
						options: .favorite),
					children: [
						Node<ItemContent>(
							value: .init(
								uuid: .uuid3,
								created: Date(timeIntervalSince1970: 1723315099),
								text: "Item 1_0",
								status: .open,
								options: [])
						)
					]
				)
			]
		)
	}
}
