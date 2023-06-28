//
//  Primary.Interactor.swift
//  Plan
//
//  Created by Anton Cherkasov on 22.06.2023.
//

import Foundation

/// Primary unit interactor interface
protocol PrimaryInteractor {

	/// Fetch projects
	///
	/// - Parameters:
	///    - sorting: Sorting of projects
	func fetchProjects(sortBy sorting: [ProjectSorting]) throws

	/// Add new project
	///
	/// - Parameters:
	///    - project: New project
	func addProject(_ project: ProjectItem) throws

	/// Rename existing project
	///
	/// - Parameters:
	///    - id: Project identifier
	///    - newName: New name of the project
	func renameProject(id: UUID, newName: String) throws
}

extension Primary {

	/// Primary unit interactor
	final class Interactor {

		private var dataProvider: DataProvider

		weak var presenter: PrimaryPresenter?

		// MARK: - Initialization

		/// Basic initialization
		///
		/// - Parameters:
		///    - dataProvider: Unit data provider
		init(dataProvider: DataProvider) {
			self.dataProvider = dataProvider
		}
	}
}

// MARK: - PrimaryInteractor
extension Primary.Interactor: PrimaryInteractor {

	func renameProject(id: UUID, newName: String) throws {
		try dataProvider.updateProject(id) {
			$0.name = newName
		}
		try dataProvider.save()
	}

	func fetchProjects(sortBy sorting: [ProjectSorting]) throws {
		let projects = try dataProvider.fetchProjects(sortBy: sorting)
		presenter?.present(projects)
	}

	func addProject(_ project: ProjectItem) throws {
		try dataProvider.addProject(project)
		try dataProvider.save()
	}
}
