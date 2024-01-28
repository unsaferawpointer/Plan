//
//  ProjectsPresenterTests.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 28.01.2024.
//

import XCTest
@testable import Plan

final class ProjectsPresenterTests: XCTestCase {

	private var sut: ProjectsPresenter!

	// MARK: - DI

	private var view: ProjectsViewMock!

	private var interactor: ProjectsInteractorMock!

	override func setUpWithError() throws {
		view = ProjectsViewMock()
		interactor = ProjectsInteractorMock()
		sut = ProjectsPresenter()
		sut.view = view
		sut.interactor = interactor
	}

	override func tearDownWithError() throws {
		sut = nil
		view = nil
		interactor = nil
	}
}

// MARK: - test ProjectsPresenterProtocol
extension ProjectsPresenterTests {

	func testFetchProjects() {
		// Arrange
		let projects: [Project] = [.random, .random, .random]
		let expectedItems = projects.map { project in
			ProjectConfiguration(uuid: project.uuid, title: project.title, subtitle: "\(project.count) items")
		}

		// Act
		sut.present(projects)

		// Assert
		guard case let .display(items) = view.invocations[0] else {
			return XCTFail()
		}
		XCTAssertEqual(expectedItems, items)
	}
}

// MARK: - ProjectsViewOutput
extension ProjectsPresenterTests {

	func testProviderDidChangeContent() {
		// Arrange
		let projects: [Project] = [.random, .random, .random]

		// Act
		sut.viewDidChange(state: .didLoad)

		// Assert
		guard case .fetchProjects = interactor.invocations[0] else {
			return XCTFail()
		}
	}
}

