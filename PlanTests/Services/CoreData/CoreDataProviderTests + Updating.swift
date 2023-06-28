//
//  CoreDataProviderTests + Updating.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 28.06.2023.
//

import XCTest
@testable import Plan

// MARK: - updating test-cases
extension CoreDataProviderTests {

	func test_updateProject() throws {
		// Arrange
		let uuid = UUID()

		let project = ProjectItem(uuid: uuid, name: .random)
		addProject(project)

		let newName: String = .random
		let newDate = Date()

		// Act
		try sut.updateProject(uuid) {
			$0.name = newName
			$0.creationDate = newDate
		}

		// Assert
		let entities = try XCTUnwrap(try fetchEntities(type: ProjectEntity.self))

		XCTAssertEqual(entities.count, 1)
		XCTAssertEqual(entities[0].uuid, uuid)
		XCTAssertEqual(entities[0].creationDate, newDate)
		XCTAssertEqual(entities[0].name, newName)
	}
}
