//
//  EntityOptions.swift
//  Hierarchy
//
//  Created by Anton Cherkasov on 30.09.2023.
//

import Foundation

struct EntityOptions: OptionSet {

	var rawValue: Int16

	static let empty = EntityOptions(rawValue: 1 << 0)
	static let favorite = EntityOptions(rawValue: 1 << 1)
}

// MARK: - Codable
extension EntityOptions: Codable { }

// MARK: - Hashable
extension EntityOptions: Hashable { }
