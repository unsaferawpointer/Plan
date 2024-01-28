//
//  ProjectsInteractor.swift
//  Plan
//
//  Created by Anton Cherkasov on 27.01.2024.
//

import Foundation

protocol ProjectsInteractorProtocol { 
	func fetchProjects() throws -> [Project]
}

final class ProjectsInteractor {
	
	weak var presenter: ProjectsPresenterProtocol?

	// MARK: - Initialization

	init(presenter: ProjectsPresenterProtocol? = nil) {
		self.presenter = presenter
	}
}

// MARK: - ProjectsInteractorProtocol
extension ProjectsInteractor: ProjectsInteractorProtocol {

	func fetchProjects() throws -> [Project] {
		// TODO: - Handle action
		return [ ]
	}
}
