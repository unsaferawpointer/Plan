//
//  PlanDataProvider.swift
//  Hierarchy
//
//  Created by Anton Cherkasov on 27.09.2023.
//

import Foundation

/// Data provider of board document
final class PlanDataProvider<Content: Codable> { }

// MARK: - ContentProvider
extension PlanDataProvider: ContentProvider {

	func data(ofType typeName: String, content: Content) throws -> Data {

		guard let type = DocumentType(rawValue: typeName.lowercased()) else {
			throw DocumentError.unexpectedFormat
		}

		switch type {
		case .plan:
			let file = DocumentFile(version: type.lastVersion, content: content)
			let encoder = JSONEncoder()
			encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
			encoder.dateEncodingStrategy = .secondsSince1970
			return try encoder.encode(file)
		}
	}

	func read(from data: Data, ofType typeName: String) throws -> Content {

		guard let type = DocumentType(rawValue: typeName.lowercased()) else {
			throw DocumentError.unexpectedFormat
		}

		switch type {
		case .plan:
			return try migrate(data, type: type)
		}
	}

	func data(of content: Content) throws -> Data {
		let encoder = JSONEncoder()
		return try encoder.encode(content)
	}

	func read(from data: Data) throws -> Content {
		let decoder = JSONDecoder()

		guard let content = try? decoder.decode(Content.self, from: data) else {
			throw DocumentError.unexpectedFormat
		}
		return content
	}
}

// MARK: - Helpers
private extension PlanDataProvider {

	func migrate(_ data: Data, type: DocumentType) throws -> Content {

		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .secondsSince1970

		guard let versionedFile = try? decoder.decode(VersionedFile.self, from: data) else {
			throw DocumentError.unexpectedFormat
		}
		guard versionedFile.version <= type.lastVersion else {
			throw DocumentError.unknownVersion
		}
		guard let file = try? decoder.decode(DocumentFile<Content>.self, from: data) else {
			throw DocumentError.unexpectedFormat
		}
		return file.content
	}
}
