//
//  ItemContent.swift
//  Hierarchy
//
//  Created by Anton Cherkasov on 30.09.2023.
//

import Foundation

struct ItemContent {

	var uuid: UUID

	var created: Date

	var text: String

	var status: ItemStatus

	var iconName: IconName?

	var count: Int

	var options: EntityOptions

	var priority: ItemPriority

	var iconColor: ColorModel?

	// MARK: - Initialization

	init(
		uuid: UUID,
		created: Date = .now,
		text: String,
		status: ItemStatus = .open,
		iconName: IconName? = nil,
		count: Int = 0,
		options: EntityOptions = [],
		priority: ItemPriority = .low,
		iconColor: ColorModel? = nil
	) {
		self.uuid = uuid
		self.created = created
		self.text = text
		self.status = status
		self.iconName = iconName
		self.count = count
		self.options = options
		self.priority = priority
		self.iconColor = iconColor
	}
}

// MARK: - Hashable
extension ItemContent: Hashable { }

// MARK: - Decodable
extension ItemContent: Decodable {

	enum CodingKeys: CodingKey {
		case uuid
		case created
		case text
		case status
		case iconName
		case count
		case options
		case priority
		case iconColor
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let uuid = try container.decode(UUID.self, forKey: .uuid)
		let created = try container.decode(Date.self, forKey: .created)
		let text = try container.decode(String.self, forKey: .text)
		let status = try container.decode(ItemStatus.self, forKey: .status)
		let iconName = try? container.decodeIfPresent(IconName.self, forKey: .iconName)
		let iconColor = try? container.decodeIfPresent(ColorModel.self, forKey: .iconColor)
		let count = try container.decodeIfPresent(Int.self, forKey: .count) ?? 0
		let options = try container.decode(EntityOptions.self, forKey: .options)
		let priority = try container.decodeIfPresent(ItemPriority.self, forKey: .priority) ?? .low
		self.init(
			uuid: uuid,
			created: created,
			text: text,
			status: status,
			iconName: iconName,
			count: count,
			options: options,
			priority: priority,
			iconColor: iconColor
		)
	}
}

// MARK: - Equatable
extension ItemContent: Equatable { }

// MARK: - Encodable
extension ItemContent: Encodable {

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(uuid, forKey: .uuid)
		try container.encode(created, forKey: .created)
		try container.encode(text, forKey: .text)
		try container.encode(status, forKey: .status)
		try container.encode(iconName, forKey: .iconName)
		try container.encode(count, forKey: .count)
		try container.encode(options, forKey: .options)
		try container.encode(priority, forKey: .priority)
		try container.encode(iconColor, forKey: .iconColor)
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

	var isDone: Bool {
		get {
			switch status {
			case .open: false
			case .done: true
			}
		}
		set {
			status = newValue ? .done(completed: max(.now, created)) : .open
		}
	}
}
