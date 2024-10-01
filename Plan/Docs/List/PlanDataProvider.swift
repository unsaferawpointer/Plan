//
//  PlanDataProvider.swift
//  Hierarchy
//
//  Created by Anton Cherkasov on 27.09.2023.
//

import Foundation

/// Data provider of board document
final class PlanDataProvider {

	/// Last supported version
	let lastVersion: PlanVersion = .v1
}

// MARK: - ContentProvider
extension PlanDataProvider: ContentProvider {

	typealias Content = HierarchyContent

	func data(ofType typeName: String, content: Content) throws -> Data {

		let type = DocumentType(rawValue: typeName.lowercased())

		switch type {
		case .plan:
			let file = DocumentFile(version: lastVersion.rawValue, content: content)
			let encoder = JSONEncoder()
			encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
			encoder.dateEncodingStrategy = .secondsSince1970
			return try encoder.encode(file)
		default:
			throw DocumentError.unexpectedFormat
		}
	}

	func read(from data: Data, ofType typeName: String) throws -> Content {

		let type = DocumentType(rawValue: typeName.lowercased())

		switch type {
		case .plan:
			return try migrate(data)
		default:
			throw DocumentError.unexpectedFormat
		}
	}

	func data(of content: HierarchyContent) throws -> Data {
		let encoder = JSONEncoder()
		return try encoder.encode(content)
	}

	func read(from data: Data) throws -> HierarchyContent {
		let decoder = JSONDecoder()

		guard let content = try? decoder.decode(Content.self, from: data) else {
			throw DocumentError.unexpectedFormat
		}
		return content
	}
}

// MARK: - Helpers
private extension PlanDataProvider {

	func migrate(_ data: Data) throws -> Content {

		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .secondsSince1970

		guard let versionedFile = try? decoder.decode(VersionedFile.self, from: data) else {
			throw DocumentError.unexpectedFormat
		}
		guard let version = PlanVersion(rawValue: versionedFile.version), version <= lastVersion else {
			throw DocumentError.unknownVersion
		}
		guard let file = try? decoder.decode(DocumentFile<HierarchyContent>.self, from: data) else {
			throw DocumentError.unexpectedFormat
		}
		return file.content
	}
}
