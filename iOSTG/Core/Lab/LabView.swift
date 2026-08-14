//
//  LabView.swift
//  iOSTG
//
//  Created by Codex on 8/14/26.
//

import SwiftUI

struct LabView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Interaction system") {
                    NavigationLink {
                        ButtonDesignView()
                    } label: {
                        LabExampleRow(
                            title: "Button Design",
                            summary: "Intent, execution, domain facts, and observation",
                            systemImage: "button.programmable"
                        )
                    }
                }

                Section("About") {
                    Text(
                        "Lab examples are complete, runnable references. "
                            + "They remain isolated from the current business flow until a real feature adopts them."
                    )
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Lab")
        }
    }
}

private struct LabExampleRow: View {
    let title: String
    let summary: String
    let systemImage: String

    var body: some View {
        Label {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)

                Text(summary)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        } icon: {
            Image(systemName: systemImage)
                .foregroundStyle(.tint)
        }
    }
}

#Preview {
    LabView()
}
