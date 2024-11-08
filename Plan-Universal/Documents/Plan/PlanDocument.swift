//
//  PlanDocument.swift
//  Plan-Universal
//
//  Created by Anton Cherkasov on 06.11.2024.
//

import SwiftUI
import UniformTypeIdentifiers

extension UTType {
	static var plan: UTType {
		UTType(importedAs: "dev.zeroindex.plan")
	}
}

struct PlanDocument {

	var content: PlanContent

	// MARK: - Initialization

	init(content: PlanContent = .empty) {
		self.content = content
	}
}

// MARK: - FileDocument
extension PlanDocument: FileDocument {

	static var readableContentTypes: [UTType] {
		[.plan]
	}

	init(configuration: ReadConfiguration) throws {
		guard
			let data = configuration.file.regularFileContents
		else {
			throw CocoaError(.fileReadCorruptFile)
		}
		let documentType: DocumentType = .plan
		content = try PlanDataProvider().read(from: data, ofType: documentType.rawValue)
	}

	func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
		let documentType: DocumentType = .plan
		let data = try PlanDataProvider().data(ofType: documentType.rawValue, content: content)
		return .init(regularFileWithContents: data)
	}
}
