//
//  ButtonDesignControls.swift
//  iOSTG
//
//  Created by Codex on 8/14/26.
//

import SwiftUI

struct ButtonDesignObservedButton<Label: View>: View {
    let interactionName: ButtonDesignExample.InteractionName
    let context: ButtonDesignExample.ButtonContext
    let reporter: ButtonDesignExample.ObservationReporter
    let action: () -> Void
    let label: () -> Label

    private let projector = ButtonDesignExample.ButtonInteractionProjector()

    init(
        interactionName: ButtonDesignExample.InteractionName,
        context: ButtonDesignExample.ButtonContext,
        reporter: ButtonDesignExample.ObservationReporter,
        action: @escaping () -> Void,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.interactionName = interactionName
        self.context = context
        self.reporter = reporter
        self.action = action
        self.label = label
    }

    var body: some View {
        Button(action: trigger) {
            label()
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
        .controlSize(.large)
    }

    private func trigger() {
        let intent = ButtonDesignExample.InteractionIntent(
            name: interactionName,
            context: context
        )
        let record = projector.project(
            ButtonDesignExample.InteractionEvent(intent: intent)
        )

        Task {
            await reporter.emit(record)
        }
        action()
    }
}

struct ButtonDesignAppButton<Label: View>: View {
    enum TaskLifetime: Equatable {
        case viewBound
        case flowBound
    }

    enum LocalState: Equatable {
        case idle
        case running
        case completed
        case failed
        case rejected

        var message: String? {
            switch self {
            case .idle:
                nil
            case .running:
                "Running…"
            case .completed:
                "Execution completed"
            case .failed:
                "Execution failed"
            case .rejected:
                "Rejected by async-exclusive policy"
            }
        }
    }

    let interactionName: ButtonDesignExample.InteractionName
    let context: ButtonDesignExample.ButtonContext
    let operationName: String
    let policy: ButtonDesignExample.ExecutionPolicy
    let lifetime: TaskLifetime
    let reporter: ButtonDesignExample.ObservationReporter
    let executor: ButtonDesignExample.OperationExecutor
    let operation: @Sendable (UUID) async throws -> Void
    let label: () -> Label

    @State private var task: Task<Void, Never>?
    @State private var localState: LocalState = .idle

    private let projector = ButtonDesignExample.ButtonInteractionProjector()

    init(
        interactionName: ButtonDesignExample.InteractionName,
        context: ButtonDesignExample.ButtonContext,
        operationName: String,
        policy: ButtonDesignExample.ExecutionPolicy,
        lifetime: TaskLifetime = .viewBound,
        reporter: ButtonDesignExample.ObservationReporter,
        executor: ButtonDesignExample.OperationExecutor,
        operation: @escaping @Sendable (UUID) async throws -> Void,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.interactionName = interactionName
        self.context = context
        self.operationName = operationName
        self.policy = policy
        self.lifetime = lifetime
        self.reporter = reporter
        self.executor = executor
        self.operation = operation
        self.label = label
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Button(action: start) {
                HStack {
                    if localState == .running {
                        ProgressView()
                    }

                    label()
                        .frame(maxWidth: .infinity)
                }
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(localState == .running)

            if let message = localState.message {
                Text(message)
                    .font(.caption)
                    .foregroundStyle(messageColor)
            }
        }
        .onDisappear(perform: cancelViewBoundTask)
    }

    private var messageColor: Color {
        switch localState {
        case .failed, .rejected:
            .red
        case .idle, .running, .completed:
            .secondary
        }
    }

    private func start() {
        guard task == nil else { return }

        let correlationID = UUID()
        let intent = ButtonDesignExample.InteractionIntent(
            name: interactionName,
            context: context,
            correlationID: correlationID
        )
        let interactionRecord = projector.project(
            ButtonDesignExample.InteractionEvent(intent: intent)
        )
        let request = ButtonDesignExample.ExecutionRequest(
            operationName: operationName,
            correlationID: correlationID
        )
        let operation = operation

        localState = .running
        task = Task {
            await reporter.emit(interactionRecord)

            do {
                try await executor.execute(
                    request: request,
                    policy: policy
                ) {
                    try await operation(correlationID)
                }
                finish(with: .completed)
            } catch is ButtonDesignExample.ExecutionRejectedError {
                finish(with: .rejected)
            } catch is CancellationError {
                finish(with: .idle)
            } catch {
                finish(with: .failed)
            }
        }
    }

    private func finish(with state: LocalState) {
        localState = state
        task = nil
    }

    private func cancelViewBoundTask() {
        guard lifetime == .viewBound else { return }
        task?.cancel()
        task = nil
    }
}
