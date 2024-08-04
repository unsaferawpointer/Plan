//
//  DocumentFile.swift
//  Hierarchy
//
//  Created by Anton Cherkasov on 27.09.2023.
//

import Foundation

struct DocumentFile<Content: Codable>: Versioned, Codable {

	let version: String

	var content: Content
}
