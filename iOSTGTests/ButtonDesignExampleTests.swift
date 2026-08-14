//
//  ButtonDesignExampleTests.swift
//  iOSTGTests
//
//  Created by Codex on 8/14/26.
//

import Foundation
import Testing
@testable import iOSTG

@Suite("Button Design Example")
struct ButtonDesignExampleTests {
    @Test("Executor reports accepted, started, and completed in order")
    func successfulExecutionLifecycle() async throws {
        let sink = CollectingObservationSink()
        let reporter = ButtonDesignExample.ObservationReporter(sinks: [sink])
        let executor = ButtonDesignExample.OperationExecutor(reporter: reporter)
        let request = ButtonDesignExample.ExecutionRequest(
            operationName: "test.operation"
        )

        try await executor.execute(
            request: request,
            policy: .immediate,
            operation: {}
        )

        let records = await sink.snapshot()
        #expect(
            records.map(\.name) == [
                "test.operation.accepted",
                "test.operation.started",
                "test.operation.completed"
            ]
        )
    }

    @Test("Async-exclusive policy rejects a competing execution")
    func exclusiveExecutionRejectsCompetition() async throws {
        let sink = CollectingObservationSink()
        let reporter = ButtonDesignExample.ObservationReporter(sinks: [sink])
        let executor = ButtonDesignExample.OperationExecutor(reporter: reporter)
        let gate = OperationGate()
        let key = ButtonDesignExample.ExecutionKey(rawValue: "shared-key")

        let firstExecution = Task {
            try await executor.execute(
                request: .init(operationName: "first.operation"),
                policy: .asyncExclusive(key)
            ) {
                await gate.enterAndWait()
            }
        }

        await gate.waitUntilEntered()

        var didReject = false
        do {
            try await executor.execute(
                request: .init(operationName: "second.operation"),
                policy: .asyncExclusive(key),
                operation: {}
            )
        } catch is ButtonDesignExample.ExecutionRejectedError {
            didReject = true
        }

        await gate.release()
        try await firstExecution.value

        let records = await sink.snapshot()
        #expect(didReject)
        #expect(records.contains { $0.name == "second.operation.rejected" })
        #expect(
            records.first(where: { $0.name == "second.operation.rejected" })?
                .attributes["reason_code"] == .string("exclusive_operation_running")
        )
    }

    @Test("Interaction, execution, and domain facts remain distinct")
    func observationKindsRemainDistinct() {
        let interactionIntent = ButtonDesignExample.InteractionIntent(
            name: .buttonTriggered,
            context: ButtonDesignExample.ButtonContext(
                example: "test",
                source: "unit-test"
            )
        )
        let interactionRecord = ButtonDesignExample.ButtonInteractionProjector()
            .project(.init(intent: interactionIntent))

        let executionRequest = ButtonDesignExample.ExecutionRequest(
            operationName: "test.operation"
        )
        let executionRecord = ButtonDesignExample.ExecutionProjector()
            .project(.init(request: executionRequest, state: .completed))

        let domainEvent = ButtonDesignExample.DomainEvent(
            name: "test.fact",
            payload: ButtonDesignExample.DemoCompletedPayload(message: "done")
        )
        let domainRecord = ButtonDesignExample.DemoDomainProjector()
            .project(domainEvent)

        #expect(interactionRecord.kind == .interaction)
        #expect(executionRecord.kind == .execution)
        #expect(domainRecord.kind == .domain)
    }
}

private actor CollectingObservationSink: ButtonDesignExample.ObservationSink {
    private var records: [ButtonDesignExample.ObservationRecord] = []

    func consume(_ record: ButtonDesignExample.ObservationRecord) async {
        records.append(record)
    }

    func snapshot() -> [ButtonDesignExample.ObservationRecord] {
        records
    }
}

private actor OperationGate {
    private var didEnter = false
    private var entryContinuation: CheckedContinuation<Void, Never>?
    private var releaseContinuation: CheckedContinuation<Void, Never>?

    func waitUntilEntered() async {
        guard !didEnter else { return }

        await withCheckedContinuation { continuation in
            entryContinuation = continuation
        }
    }

    func enterAndWait() async {
        didEnter = true
        entryContinuation?.resume()
        entryContinuation = nil

        await withCheckedContinuation { continuation in
            releaseContinuation = continuation
        }
    }

    func release() {
        releaseContinuation?.resume()
        releaseContinuation = nil
    }
}
