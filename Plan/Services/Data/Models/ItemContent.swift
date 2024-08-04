//
//  ItemContent.swift
//  Hierarchy
//
//  Created by Anton Cherkasov on 30.09.2023.
//

import Foundation

struct ItemContent {

	var uuid: UUID

	var text: String

	var isDone: Bool

	var iconName: String?

	var count: Int

	var options: EntityOptions
}

// MARK: - Hashable
extension ItemContent: Hashable { }

// MARK: - Decodable
extension ItemContent: Decodable {

	enum CodingKeys: CodingKey {
		case uuid
		case text
		case isDone
		case iconName
		case count
		case options
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let uuid = try container.decode(UUID.self, forKey: .uuid)
		let text = try container.decode(String.self, forKey: .text)
		let isDone = try container.decode(Bool.self, forKey: .isDone)
		let iconName = try container.decodeIfPresent(String.self, forKey: .iconName)
		let count = try container.decodeIfPresent(Int.self, forKey: .count) ?? 0
		let options = try container.decode(EntityOptions.self, forKey: .options)
		self.init(
			uuid: uuid,
			text: text,
			isDone: isDone,
			iconName: iconName,
			count: count,
			options: options
		)
	}
}

// MARK: - Encodable
extension ItemContent: Encodable {

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(uuid, forKey: .uuid)
		try container.encode(text, forKey: .text)
		try container.encode(isDone, forKey: .isDone)
		try container.encode(iconName, forKey: .iconName)
		try container.encode(count, forKey: .count)
		try container.encode(options, forKey: .options)
	}
}

// MARK: - NodeValue
extension ItemContent: NodeValue {

	var id: UUID {
		return uuid
	}

	mutating func generateIdentifier() {
		self.uuid = UUID()
	}
}

// MARK: - Computed properties
extension ItemContent {

	var isFavorite: Bool {
		get {
			options.contains(.favorite)
		}
		set {
			if newValue {
				options.insert(.favorite)
			} else {
				options.remove(.favorite)
			}
		}
	}
}
