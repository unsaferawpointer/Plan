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
	func createProject(withTitle title: String) throws
	func deleteProjects(with ids: [UUID]) throws
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

	func createProject(withTitle title: String) throws {
		let project = Project(uuid: .init(), title: title, count: 0)
		try storage.insertProject(project)
		try storage.save()
	}

	func deleteProjects(with ids: [UUID]) throws {
		try storage.deleteProjects(with: ids)
		try storage.save()
	}
}

// MARK: - ProjectsDataProviderDelegate
extension ProjectsInteractor: ProjectsDataProviderDelegate {

	func providerDidChangeContent(_ newContent: [Project]) {
		presenter?.present(newContent)
	}
}
