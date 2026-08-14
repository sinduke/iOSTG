//
//  ButtonDesignExecutor.swift
//  iOSTG
//
//  Created by Codex on 8/14/26.
//

import Foundation

extension ButtonDesignExample {
    actor OperationExecutor {
        private let reporter: ObservationReporter
        private let projector = ExecutionProjector()
        private var runningKeys: Set<ExecutionKey>

        init(reporter: ObservationReporter) {
            self.reporter = reporter
            self.runningKeys = []
        }

        func execute(
            request: ExecutionRequest,
            policy: ExecutionPolicy,
            operation: @Sendable () async throws -> Void
        ) async throws {
            let exclusiveKey = try await accept(
                request: request,
                policy: policy
            )

            defer {
                if let exclusiveKey {
                    runningKeys.remove(exclusiveKey)
                }
            }

            await emit(request: request, state: .started)

            do {
                try await operation()
                await emit(request: request, state: .completed)
            } catch is CancellationError {
                await emit(request: request, state: .cancelled)
                throw CancellationError()
            } catch {
                await emit(
                    request: request,
                    state: .failed,
                    reasonCode: "operation_error"
                )
                throw error
            }
        }

        private func accept(
            request: ExecutionRequest,
            policy: ExecutionPolicy
        ) async throws -> ExecutionKey? {
            switch policy {
            case .immediate:
                await emit(request: request, state: .accepted)
                return nil
            case .asyncExclusive(let key):
                guard !runningKeys.contains(key) else {
                    await emit(
                        request: request,
                        state: .rejected,
                        reasonCode: "exclusive_operation_running"
                    )
                    throw ExecutionRejectedError(key: key)
                }

                runningKeys.insert(key)
                await emit(request: request, state: .accepted)
                return key
            }
        }

        private func emit(
            request: ExecutionRequest,
            state: ExecutionState,
            reasonCode: String? = nil
        ) async {
            let event = ExecutionEvent(
                request: request,
                state: state,
                reasonCode: reasonCode
            )
            await reporter.emit(projector.project(event))
        }
    }

    actor DemoService {
        private let reporter: ObservationReporter
        private let projector = DemoDomainProjector()

        init(reporter: ObservationReporter) {
            self.reporter = reporter
        }

        func complete(correlationID: UUID) async throws {
            try await Task.sleep(for: .seconds(1.5))

            let event = DomainEvent(
                name: "demo.operation_finished",
                payload: DemoCompletedPayload(
                    message: "The demo service confirmed its own domain fact."
                ),
                correlationID: correlationID
            )
            await reporter.emit(projector.project(event))
        }

        func fail() async throws {
            try await Task.sleep(for: .milliseconds(650))
            throw DemoFailure()
        }
    }

    @MainActor
    final class Runtime {
        let store: ObservationStore
        let reporter: ObservationReporter
        let executor: OperationExecutor
        let service: DemoService

        init(store: ObservationStore = ObservationStore()) {
            let reporter = ObservationReporter(
                sinks: [
                    StoreObservationSink(store: store),
                    NoOpObservationSink()
                ]
            )

            self.store = store
            self.reporter = reporter
            self.executor = OperationExecutor(reporter: reporter)
            self.service = DemoService(reporter: reporter)
        }
    }
}
