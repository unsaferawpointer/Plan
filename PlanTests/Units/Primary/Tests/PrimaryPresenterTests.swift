//
//  PrimaryPresenterTests.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 23.06.2023.
//

import XCTest
@testable import Plan

final class PrimaryPresenterTests: XCTestCase {

	var sut: Primary.Presenter!

	var interactor: PrimaryInteractorMock!

	var view: PrimaryViewMock!

	var localization: PrimaryLocalizationMock!

	override func setUpWithError() throws {
		interactor = PrimaryInteractorMock()
		view = PrimaryViewMock()
		sut = Primary.Presenter()
		localization = PrimaryLocalizationMock()
		sut.interactor = interactor
		sut.localization = localization
		sut.view = view
	}

	override func tearDownWithError() throws {
		sut = nil
		view = nil
		localization = nil
		interactor = nil
	}
}

// MARK: - ViewControllerOutput
extension PrimaryPresenterTests {

	func testPresentProjects() {
		// Arrange

		// Act
		sut.viewControllerDidChangeState(.viewDidLoad)

		// Assert
		guard case let .fetchProjects(sorting) = interactor.invocations.first else {
			return XCTFail("`fetchProjects` should be invocked")
		}
		XCTAssertEqual(sorting, [.creationDate(), .name()])

	}
}

// MARK: - PrimaryPresenter
extension PrimaryPresenterTests {

	func testPresent() {
		// Arrange
		let projects: [ProjectItem] = [.init(name: .random), .init(name: .random)]

		// Act
		sut.present(projects)

		// Assert
		guard case let .display(model) = view.invocations.first else {
			return XCTFail("`display` should be invocked")
		}

		// Basic section
		XCTAssertEqual(model[0].id, .basic)

		XCTAssertEqual(model[0].items.count, 2)

		XCTAssertEqual(model[0].items[0].id, Primary.NavigationModel.all)
		XCTAssertEqual(model[0].items[0].tintColor, .gray)
		XCTAssertEqual(model[0].items[0].content, .init(title: localization.allItemStub,
														iconName: "app",
														isEditable: false,
														titleDidChange: nil))

		XCTAssertEqual(model[0].items[1].id, Primary.NavigationModel.favorite)
		XCTAssertEqual(model[0].items[1].tintColor, .yellow)
		XCTAssertEqual(model[0].items[1].content, .init(title: localization.favoriteItemStub,
														iconName: "star.fill",
														isEditable: false,
														titleDidChange: nil))

		// Projects section
		XCTAssertEqual(model[1].id, .projects)

		XCTAssertEqual(model[1].items.count, 2)

		XCTAssertEqual(model[1].items[0].id, projects[0].id)
		XCTAssertEqual(model[1].items[0].tintColor, .gray)
		XCTAssertEqual(model[1].items[0].content, .init(title: projects[0].name,
														iconName: "doc.plaintext.fill",
														isEditable: true,
														titleDidChange: nil))

		XCTAssertEqual(model[1].items[1].id, projects[1].id)
		XCTAssertEqual(model[1].items[1].tintColor, .gray)
		XCTAssertEqual(model[1].items[1].content, .init(title: projects[1].name,
														iconName: "doc.plaintext.fill",
														isEditable: true,
														titleDidChange: nil))
	}
}
