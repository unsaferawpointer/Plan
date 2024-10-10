//
//  BasicFormatterTests.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 10.10.2024.
//

import Testing
@testable import Plan

final class BasicFormatterTests {

	@Test
	func format_whenPrefixIsDash() throws {
		// Arrange
		let node = makeNode()

		let expectedText =
		"""
		- item 0
			- item 0 0
				- item 0 0 0
			- item 0 1
		"""

		// Assert
		#expect(BasicFormatter().format(node) == expectedText)
	}

	@Test
	func format_whenPrefixIsAsterics() throws {
		// Arrange
		let node = makeNode()

		let expectedText =
		"""
		* item 0
			* item 0 0
				* item 0 0 0
			* item 0 1
		"""

		// Assert
		#expect(BasicFormatter(format: .init(indent: .tab, prefix: .asterics)).format(node) == expectedText)
	}
}

// MARK: - Helpers
private extension BasicFormatterTests {

	func makeNode() -> any TreeNode<ItemContent> {
		return TransferNode(
			value: .init(uuid: .uuid0, text: "item 0"),
			children:
				[
					.init(
						value: .init(uuid: .uuid1, text: "item 0 0"),
						children:
							[
								.init(value: .init(uuid: .uuid2, text: "item 0 0 0"), children: [])
							]
					),
					.init(value: .init(uuid: .uuid3, text: "item 0 1"), children: [])
				]
		)
	}
}
