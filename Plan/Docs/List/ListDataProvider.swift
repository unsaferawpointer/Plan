//
//  ListDataProvider.swift
//  Hierarchy
//
//  Created by Anton Cherkasov on 27.09.2023.
//

import Foundation

/// Data provider of board document
final class ListDataProvider {

	/// Last supported version
	let lastVersion: Version = .v1
}

// MARK: - ContentProvider
extension ListDataProvider: ContentProvider {

	typealias Content = HierarchyContent

	func data(ofType typeName: String, content: Content) throws -> Data {
		switch typeName.lowercased() {
		case "dev.paperwave.plan":
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
		switch typeName.lowercased() {
		case "dev.paperwave.plan":
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
private extension ListDataProvider {

	func migrate(_ data: Data) throws -> Content {

		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .secondsSince1970

		guard let versionedFile = try? decoder.decode(VersionedFile.self, from: data) else {
			throw DocumentError.unexpectedFormat
		}
		guard let version = Version(rawValue: versionedFile.version), version == lastVersion else {
			throw DocumentError.unknownVersion
		}
		guard let file = try? decoder.decode(DocumentFile<HierarchyContent>.self, from: data) else {
			throw DocumentError.unexpectedFormat
		}
		return file.content
	}
}

// MARK: - Nested data structs
extension ListDataProvider {

	/// Version of a document file
	enum Version: String {
		case v1
	}
}
