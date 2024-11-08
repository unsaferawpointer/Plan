//
//  NodeValue.swift
//  Hierarchy
//
//  Created by Anton Cherkasov on 06.11.2023.
//

import Foundation

protocol NodeValue: Identifiable, Hashable, Equatable {
	mutating func generateIdentifier()
}
