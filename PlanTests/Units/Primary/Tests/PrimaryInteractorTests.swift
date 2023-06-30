//
//  PrimaryInteractorTests.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 24.06.2023.
//

import XCTest
@testable import Plan

final class InteractorPresenterTests: XCTestCase {

	var sut: Primary.Interactor!

	var dataProvider: DataProviderMock!

	var presenter: PrimaryPresenterMock!

	override func setUpWithError() throws {
		dataProvider = DataProviderMock()
		presenter = PrimaryPresenterMock()
		sut = Primary.Interactor(dataProvider: dataProvider)
		sut.presenter = presenter
	}

	override func tearDownWithError() throws {
		sut = nil
		dataProvider = nil
		presenter = nil
	}
}

// MARK: - PrimaryInteractor
extension InteractorPresenterTests {

	func testFetchProjects() throws {
		// Arrange
		let sorting: [ProjectSorting] = [.creationDate(), .name()]
		dataProvider.stubs.fetchProjects = [.init(name: .random), .init(name: .random)]

		// Act
		try sut.fetchProjects(sortBy: sorting)

		// Assert
		guard case let .fetchProjects(sorting) = dataProvider.invocations.first else {
			return XCTFail("`fetchProjects` should be invocked")
		}

		XCTAssertEqual(sorting, [.creationDate(), .name()])

		guard case let .present(projects) = presenter.invocations.first else {
			return XCTFail("`present` should be invocked")
		}

		XCTAssertEqual(projects, dataProvider.stubs.fetchProjects)
	}

	func testAddProject() throws {
		// Arrange
		let newItem = ProjectItem(name: .random)

		// Act
		try sut.addProject(newItem)

		// Assert
		XCTAssertEqual(dataProvider.invocations.count, 2)

		guard case let .addProject(project) = dataProvider.invocations.first else {
			return XCTFail("`addProject` should be invocked")
		}

		XCTAssertEqual(project, newItem)

		guard case .save = dataProvider.invocations[1] else {
			return XCTFail("`save` should be invocked")
		}
	}

	func testRenameProject() throws {
		// Arrange
		let id = UUID()
		let newName = String.random

		// Act
		try sut.renameProject(id: id, newName: newName)

		// Assert
		XCTAssertEqual(dataProvider.invocations.count, 2)

		guard case let .updateProject(updatedId) = dataProvider.invocations.first else {
			return XCTFail("`updateProject` should be invocked")
		}

		guard case .save = dataProvider.invocations[1] else {
			return XCTFail("`save` should be invocked")
		}

		XCTAssertEqual(updatedId, id)
		XCTAssertEqual(dataProvider.stubs.updatedProject.name, newName)
	}

	func testDeleteProject() throws {
		// Arrange
		let id = UUID()

		// Act
		try sut.deleteProject(id)

		// Assert
		XCTAssertEqual(dataProvider.invocations.count, 2)

		guard case let .deleteProject(deletedId) = dataProvider.invocations.first else {
			return XCTFail("`deleteProject` should be invocked")
		}

		guard case .save = dataProvider.invocations[1] else {
			return XCTFail("`save` should be invocked")
		}

		XCTAssertEqual(deletedId, id)
	}
}
