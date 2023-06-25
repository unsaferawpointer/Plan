//
//  Primary.Interactor.swift
//  Plan
//
//  Created by Anton Cherkasov on 22.06.2023.
//

/// Primary unit interactor interface
protocol PrimaryInteractor {

	/// Fetch projects
	///
	/// - Parameters:
	///    - sorting: Sorting of projects
	func fetchProjects(sortBy sorting: [ProjectSorting]) throws
}

extension Primary {

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

	func fetchProjects(sortBy sorting: [ProjectSorting]) throws {
		let projects = try dataProvider.fetchProjects(sortBy: sorting)
		presenter?.present(projects)
	}
}
