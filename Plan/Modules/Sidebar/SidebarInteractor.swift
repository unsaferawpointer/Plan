//
//  SidebarInteractor.swift
//  Plan
//
//  Created by Anton Cherkasov on 10.02.2024.
//

import Foundation

protocol SidebarInteractorProtocol {
	func fetchProjects() throws
}

final class SidebarInteractor {

	weak var presenter: SidebarPresenterProtocol?

	private var provider: ProjectsDataProviderProtocol

	private var storage: PersistentContainerProtocol

	// MARK: - Initialization

	init(
		provider: ProjectsDataProviderProtocol,
		storage: PersistentContainerProtocol
	) {
		self.provider = provider
		self.storage = storage
	}
}

// MARK: - SidebarInteractorProtocol
extension SidebarInteractor: SidebarInteractorProtocol {

	func fetchProjects() throws {
		try provider.subscribe(self)
	}
}

// MARK: - ProjectsDataProviderDelegate
extension SidebarInteractor: ProjectsDataProviderDelegate {

	func providerDidChangeContent(_ newContent: [Project]) {
		presenter?.present(newContent)
	}
}
