//
//  CoreDataProviderTests + Deleting.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 29.06.2023.
//

import XCTest
@testable import Plan

// MARK: - deleting test-cases
extension CoreDataProviderTests {

	func test_deleteProject() throws {
		// Arrange
		let uuid = UUID()

		let project = ProjectItem(uuid: uuid, name: .random)
		addProject(project)

		// Act
		try sut.deleteProject(uuid)

		// Assert
		let entities = try XCTUnwrap(try fetchEntities(type: ProjectEntity.self))

		XCTAssertEqual(entities.count, 0)
	}
}
