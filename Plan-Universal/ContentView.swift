//
//  ContentView.swift
//  Plan-Universal
//
//  Created by Anton Cherkasov on 06.11.2024.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: PlanDocument

    var body: some View {
        TextEditor(text: $document.text)
    }
}

#Preview {
    ContentView(document: .constant(PlanDocument()))
}
