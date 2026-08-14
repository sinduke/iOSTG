//
//  ButtonDesignLiveDemo.swift
//  iOSTG
//
//  Created by Codex on 8/14/26.
//

import SwiftUI

struct ButtonDesignLiveDemo: View {
    let runtime: ButtonDesignExample.Runtime

    private let exclusiveKey = ButtonDesignExample.ExecutionKey(
        rawValue: "button-design.shared-operation"
    )

    var body: some View {
        Section("Live demo") {
            ButtonDesignObservedButton(
                interactionName: .buttonTriggered,
                context: context(for: "report-only"),
                reporter: runtime.reporter,
                action: {},
                label: {
                    Label("Report interaction only", systemImage: "cursorarrow.click")
                }
            )

            successButton(
                title: "Run async operation",
                example: "primary-operation"
            )

            successButton(
                title: "Competing trigger",
                example: "competing-operation"
            )

            ButtonDesignAppButton(
                interactionName: .buttonTriggered,
                context: context(for: "failing-operation"),
                operationName: "demo.failure",
                policy: .immediate,
                reporter: runtime.reporter,
                executor: runtime.executor
            ) { _ in
                try await runtime.service.fail()
            } label: {
                Label("Run failing operation", systemImage: "exclamationmark.triangle")
            }

            Text(
                "Start the async operation, then quickly tap Competing Trigger. "
                    + "Both controls share one ExecutionKey, so the second request is rejected."
            )
            .font(.caption)
            .foregroundStyle(.secondary)
        }
    }

    private func successButton(
        title: String,
        example: String
    ) -> some View {
        ButtonDesignAppButton(
            interactionName: .buttonTriggered,
            context: context(for: example),
            operationName: "demo.operation",
            policy: .asyncExclusive(exclusiveKey),
            reporter: runtime.reporter,
            executor: runtime.executor
        ) { correlationID in
            try await runtime.service.complete(
                correlationID: correlationID
            )
        } label: {
            Label(title, systemImage: "hourglass")
        }
    }

    private func context(
        for example: String
    ) -> ButtonDesignExample.ButtonContext {
        ButtonDesignExample.ButtonContext(
            example: example,
            source: "button-design-lab"
        )
    }
}
