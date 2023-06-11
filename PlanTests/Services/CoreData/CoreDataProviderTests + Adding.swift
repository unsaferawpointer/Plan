//
//  CoreDataProviderTests + Adding.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 11.06.2023.
//

import XCTest
@testable import Plan

// MARK: - Adding test-cases
extension CoreDataProviderTests {

	func test_addProject() throws {
		// Arrange
		let project = ProjectItem(name: .random, creationDate: Date())

		// Act
		try sut.addProject(project)

		// Assert
		let entities = try XCTUnwrap(try fetchEntities(type: ProjectEntity.self))

		XCTAssertEqual(entities.count, 1)
		XCTAssertEqual(entities[0].uuid, project.uuid)
		XCTAssertEqual(entities[0].creationDate, project.creationDate)
		XCTAssertEqual(entities[0].name, project.name)
	}

	func test_addList() throws {
		// Arrange
		let list = ListItem(name: .random, isFavorite: false)

		let project = ProjectItem(name: .random)
		addProject(project)

		// Act
		try sut.addList(list, toProject: project.uuid)

		// Assert
		let entities = try XCTUnwrap(try fetchEntities(type: ListEntity.self))

		XCTAssertEqual(entities.count, 1)
		XCTAssertEqual(entities[0].uuid, list.uuid)
		XCTAssertEqual(entities[0].creationDate, list.creationDate)
		XCTAssertEqual(entities[0].name, list.name)
		XCTAssertEqual(entities[0].project?.uuid, project.uuid)
	}

	func test_addTask() throws {
		// Arrange
		let task = TaskItem(status: .incomplete, text: .random)

		let list = ListItem(name: .random, isFavorite: false)
		addList(list, to: nil)

		// Act
		try sut.addTask(task, toList: list.uuid)

		// Assert
		let entities = try XCTUnwrap(try fetchEntities(type: TaskEntity.self))

		XCTAssertEqual(entities.count, 1)
		XCTAssertEqual(entities[0].uuid, task.uuid)
		XCTAssertEqual(entities[0].creationDate, task.creationDate)
		XCTAssertEqual(entities[0].text, task.text)
		XCTAssertEqual(entities[0].status, task.status.rawValue)
		XCTAssertEqual(entities[0].list?.uuid, list.uuid)
	}
}
