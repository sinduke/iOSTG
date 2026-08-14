//
//  ButtonDesignView.swift
//  iOSTG
//
//  Created by Codex on 8/14/26.
//

import SwiftUI

struct ButtonDesignView: View {
    private let runtime: ButtonDesignExample.Runtime

    @State private var store: ButtonDesignExample.ObservationStore

    init() {
        let store = ButtonDesignExample.ObservationStore()
        self.runtime = ButtonDesignExample.Runtime(store: store)
        self._store = State(initialValue: store)
    }

    var body: some View {
        List {
            ButtonDesignIntroduction()
            ButtonDesignLiveDemo(runtime: runtime)
            ButtonDesignTimeline(records: store.records)
            ButtonDesignArchitectureGuide()
            ButtonDesignUsageGuide()
        }
        .navigationTitle("Button Design")
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                NavigationLink("Guide") {
                    LabDocumentationView(resource: .buttonDesign)
                }

                Button("Clear", action: store.clear)
                    .disabled(store.records.isEmpty)
            }
        }
    }
}

private struct ButtonDesignIntroduction: View {
    var body: some View {
        Section("Introduction") {
            Text(
                "This example is a self-contained reference implementation. "
                    + "It does not replace buttons in the current app and does not connect to a real analytics service."
            )

            LabeledContent("Intent") {
                Text("What the user wants")
            }

            LabeledContent("Execution event") {
                Text("What the operation lifecycle did")
            }

            LabeledContent("Domain event") {
                Text("What the demo service knows is true")
            }
        }
    }
}

private struct ButtonDesignTimeline: View {
    let records: [ButtonDesignExample.ObservationRecord]

    var body: some View {
        Section("Observation timeline") {
            if records.isEmpty {
                ContentUnavailableView(
                    "No events yet",
                    systemImage: "waveform.path.ecg",
                    description: Text("Run one of the live examples above.")
                )
            } else {
                ForEach(records.reversed()) { record in
                    ButtonDesignRecordRow(record: record)
                }
            }
        }
    }
}

private struct ButtonDesignRecordRow: View {
    let record: ButtonDesignExample.ObservationRecord

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(record.kind.rawValue.uppercased())
                    .font(.caption2.bold())
                    .foregroundStyle(kindColor)

                Spacer()

                Text(record.occurredAt, style: .time)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            Text(record.name)
                .font(.subheadline.monospaced())

            if let correlationID = record.correlationID {
                Text("correlation: \(correlationID.uuidString.prefix(8))")
                    .font(.caption2.monospaced())
                    .foregroundStyle(.secondary)
            }

            ForEach(record.attributes.keys.sorted(), id: \.self) { key in
                if let value = record.attributes[key] {
                    Text("\(key): \(value.displayValue)")
                        .font(.caption2.monospaced())
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }

    private var kindColor: Color {
        switch record.kind {
        case .interaction:
            .blue
        case .execution:
            .orange
        case .domain:
            .green
        }
    }
}

private struct ButtonDesignArchitectureGuide: View {
    var body: some View {
        Section("Architecture rules") {
            Text("Intent expresses what the user wants; it is not a historical fact.")
            Text("Execution completed means the closure returned, not that the business succeeded.")
            Text("Only the demo service emits the domain fact after it knows the result.")
            Text("Projectors whitelist fields before producing ObservationRecord values.")
            Text("The No-op sink proves that external SDKs are optional at this boundary.")
        }
    }
}

private struct ButtonDesignUsageGuide: View {
    private let snippet = """
    ButtonDesignAppButton(
        interactionName: .buttonTriggered,
        context: context,
        operationName: "demo.operation",
        policy: .asyncExclusive(key),
        reporter: runtime.reporter,
        executor: runtime.executor
    ) { correlationID in
        try await service.complete(
            correlationID: correlationID
        )
    } label: {
        Text("Run")
    }
    """

    var body: some View {
        Section("Usage") {
            Text(
                "Keep Context strongly typed inside the app. "
                    + "Convert it to an ObservationRecord only through an explicit projector."
            )

            ScrollView(.horizontal) {
                Text(snippet)
                    .font(.caption.monospaced())
                    .textSelection(.enabled)
            }

            NavigationLink {
                LabDocumentationView(resource: .buttonDesign)
            } label: {
                Label("Full Chinese Guide", systemImage: "book.pages")
            }
        }
    }
}

#Preview {
    NavigationStack {
        ButtonDesignView()
    }
}
