//
//  TodosStateProviderProtocol.swift
//  Plan
//
//  Created by Anton Cherkasov on 11.02.2024.
//

import Foundation

protocol TodosStateProviderProtocol {
	func selectTodos(_ ids: [UUID])
}
