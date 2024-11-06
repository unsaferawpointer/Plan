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

struct PlanDocument: FileDocument {
	var text: String

	init(text: String = "Hello, world!") {
		self.text = text
	}

	static var readableContentTypes: [UTType] { [.plan] }

	init(configuration: ReadConfiguration) throws {
		guard let data = configuration.file.regularFileContents,
			  let string = String(data: data, encoding: .utf8)
		else {
			throw CocoaError(.fileReadCorruptFile)
		}
		text = string
	}

	func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
		let data = text.data(using: .utf8)!
		return .init(regularFileWithContents: data)
	}
}
