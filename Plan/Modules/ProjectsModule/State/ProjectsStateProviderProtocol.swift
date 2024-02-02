//
//  ProjectsStateProviderProtocol.swift
//  Plan
//
//  Created by Anton Cherkasov on 02.02.2024.
//

import Foundation

protocol ProjectsStateProviderProtocol {
	func selectProjects(_ ids: [UUID])
}
