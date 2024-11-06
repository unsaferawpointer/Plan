//
//  PlanApp.swift
//  Plan-Universal
//
//  Created by Anton Cherkasov on 06.11.2024.
//

import SwiftUI

@main
struct PlanApp: App {
	var body: some Scene {
		DocumentGroup(newDocument: PlanDocument()) { file in
			ContentView(document: file.$document)
		}
	}
}
