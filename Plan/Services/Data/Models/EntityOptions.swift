//
//  EntityOptions.swift
//  Hierarchy
//
//  Created by Anton Cherkasov on 30.09.2023.
//

import Foundation

struct EntityOptions: OptionSet {

	var rawValue: Int16
}

// MARK: - Templates
extension EntityOptions {

	static let favorite = EntityOptions(rawValue: 1 << 0)
}

// MARK: - Codable
extension EntityOptions: Codable { }

// MARK: - Hashable
extension EntityOptions: Hashable { }
