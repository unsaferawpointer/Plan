//
//  CoreDataProviderTests + Fetching.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 11.06.2023.
//

import XCTest
@testable import Plan

// MARK: - fetching lists test-cases
extension CoreDataProviderTests {

	func test_fetchLists() throws {
		// Arrange
		let referenceDate = Date()

		let list0 = ListItem(name: .random, isFavorite: false, creationDate: referenceDate)
		let list1 = ListItem(name: .random, isFavorite: false, creationDate: referenceDate.addingTimeInterval(100.0))
		let list2 = ListItem(name: .random, isFavorite: true, creationDate: referenceDate.addingTimeInterval(200.0))

		let project1 = ProjectItem(name: .random)
		let projectEntity = addProject(project1)


		addLists([list0, list1, list2], to: projectEntity)

		// Act
		let lists = try sut.fetchLists(
			for: project1.uuid,
			sortBy: [.isFavorite(ascending: false), .creationDate()]
		)

		// Assert
		XCTAssertEqual(lists.count, 3)
		XCTAssertEqual(lists[0].uuid, list2.uuid)
		XCTAssertEqual(lists[1].uuid, list0.uuid)

		XCTAssertEqual(lists[2].uuid, list1.uuid)
		XCTAssertEqual(lists[2].creationDate, list1.creationDate)
		XCTAssertEqual(lists[2].name, list1.name)
		XCTAssertEqual(lists[2].isFavorite, list1.isFavorite)
	}

	func test_fetchLists_whenProjectIdIsNil() throws {
		// Arrange
		let referenceDate = Date()

		let list0 = ListItem(name: .random, isFavorite: false, creationDate: referenceDate)
		let list1 = ListItem(name: .random, isFavorite: false, creationDate: referenceDate.addingTimeInterval(100.0))
		let list2 = ListItem(name: .random, isFavorite: true, creationDate: referenceDate.addingTimeInterval(200.0))

		addLists([list0, list1, list2], to: nil)

		// Act
		let lists = try sut.fetchLists(
			for: nil,
			sortBy: [.isFavorite(ascending: false), .creationDate()]
		)

		// Assert
		XCTAssertEqual(lists.count, 3)
		XCTAssertEqual(lists[0].uuid, list2.uuid)
		XCTAssertEqual(lists[1].uuid, list0.uuid)
		XCTAssertEqual(lists[2].uuid, list1.uuid)
	}

}

// MARK: - Fetching projects test-cases
extension CoreDataProviderTests {

	func test_fetchProjects() throws {
		// Arrange
		let referenceDate = Date()

		let project0 = ProjectItem(name: .random, creationDate: referenceDate)
		let project1 = ProjectItem(name: "b", creationDate: referenceDate.addingTimeInterval(100.0))
		let project2 = ProjectItem(name: "a", creationDate: referenceDate.addingTimeInterval(100.0))

		addProject(project0)
		addProject(project1)
		addProject(project2)

		// Act
		let projects = try sut.fetchProjects(sortBy: [.creationDate(), .name()])

		// Assert
		XCTAssertEqual(projects.count, 3)
		XCTAssertEqual(projects[0].uuid, project0.uuid)
		XCTAssertEqual(projects[1].uuid, project2.uuid)

		XCTAssertEqual(projects[2].uuid, project1.uuid)
		XCTAssertEqual(projects[2].creationDate, project1.creationDate)
		XCTAssertEqual(projects[2].name, project1.name)
	}

	func test_fetchProject() throws {
		// Arrange
		let project = ProjectItem(name: .random, creationDate: Date())
		addProject(project)

		// Act
		let result = try sut.fetchProject(id: project.uuid)

		// Assert
		XCTAssertEqual(result?.uuid, project.uuid)
		XCTAssertEqual(result?.name, project.name)
		XCTAssertEqual(result?.creationDate, project.creationDate)
	}

	func test_fetchList() throws {
		// Arrange
		let list = ListItem(name: .random, isFavorite: Bool.random())
		addList(list, to: nil)

		// Act
		let result = try sut.fetchList(id: list.uuid)

		// Assert
		XCTAssertEqual(result?.uuid, list.uuid)
		XCTAssertEqual(result?.name, list.name)
		XCTAssertEqual(result?.creationDate, list.creationDate)
		XCTAssertEqual(result?.isFavorite, list.isFavorite)
	}
}

// MARK: - Fetching tasks test-cases
extension CoreDataProviderTests {

	func test_fetchTasks() throws {
		// Arrange
		let referenceDate = Date()

		let task0 = TaskItem(status: .done, text: "d", creationDate: referenceDate)
		let task1 = TaskItem(status: .done, text: "c", creationDate: referenceDate.addingTimeInterval(100.0))
		let task2 = TaskItem(status: .incomplete, text: "b", creationDate: referenceDate.addingTimeInterval(100.0))
		let task3 = TaskItem(status: .incomplete, text: "a", creationDate: referenceDate.addingTimeInterval(100.0))

		let list0 = ListItem(name: .random, isFavorite: false)
		let listEntity = addList(list0, to: nil)

		addTasks([task0, task1, task2, task3], to: listEntity)

		// Act
		let tasks = try sut.fetchTasks(for: listEntity.uuid, sortBy: [.creationDate(), .status(), .text()])

		// Assert
		XCTAssertEqual(tasks.count, 4)
		XCTAssertEqual(tasks[0].uuid, task0.uuid)
		XCTAssertEqual(tasks[1].uuid, task3.uuid)
		XCTAssertEqual(tasks[2].uuid, task2.uuid)

		XCTAssertEqual(tasks[3].uuid, task1.uuid)
		XCTAssertEqual(tasks[3].status, task1.status)
		XCTAssertEqual(tasks[3].creationDate, task1.creationDate)
		XCTAssertEqual(tasks[3].text, task1.text)
	}

}
