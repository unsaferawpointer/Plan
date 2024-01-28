//
//  ProjectsInteractor.swift
//  Plan
//
//  Created by Anton Cherkasov on 27.01.2024.
//

import Foundation

protocol ProjectsInteractorProtocol { 
	func fetchProjects() throws
	func setTitle(_ title: String, with id: UUID) throws
}

final class ProjectsInteractor {
	
	private weak var presenter: ProjectsPresenterProtocol?

	private var provider: ProjectsDataProviderProtocol

	private var storage: PersistentContainerProtocol

	// MARK: - Initialization

	init(
		presenter: ProjectsPresenterProtocol,
		provider: ProjectsDataProviderProtocol,
		storage: PersistentContainerProtocol
	) {
		self.presenter = presenter
		self.provider = provider
		self.storage = storage
	}
}

// MARK: - ProjectsInteractorProtocol
extension ProjectsInteractor: ProjectsInteractorProtocol {

	func fetchProjects() throws {
		try provider.subscribe(self)
	}

	func setTitle(_ title: String, with id: UUID) throws {
		try storage.setProject(title: title, with: id)
		try storage.save()
	}
}

// MARK: - ProjectsDataProviderDelegate
extension ProjectsInteractor: ProjectsDataProviderDelegate {

	func providerDidChangeContent(_ newContent: [Project]) {
		presenter?.present(newContent)
	}
}
