//
//  ButtonDesignModels.swift
//  iOSTG
//
//  Created by Codex on 8/14/26.
//

import Foundation

nonisolated enum ButtonDesignExample {}

extension ButtonDesignExample {
    nonisolated protocol InteractionContext: Sendable {}

    nonisolated struct ButtonContext: InteractionContext, Equatable {
        let example: String
        let source: String
    }

    nonisolated struct InteractionName: RawRepresentable, Sendable, Equatable {
        let rawValue: String

        init(rawValue: String) {
            self.rawValue = rawValue
        }

        static let buttonTriggered = InteractionName(
            rawValue: "button.triggered"
        )
    }

    nonisolated struct InteractionIntent<Context: InteractionContext>: Sendable {
        let interactionID: UUID
        let name: InteractionName
        let context: Context
        let correlationID: UUID?

        init(
            interactionID: UUID = UUID(),
            name: InteractionName,
            context: Context,
            correlationID: UUID? = nil
        ) {
            self.interactionID = interactionID
            self.name = name
            self.context = context
            self.correlationID = correlationID
        }
    }

    nonisolated struct InteractionEvent<Context: InteractionContext>: Sendable {
        let eventID: UUID
        let intent: InteractionIntent<Context>
        let occurredAt: Date

        init(
            eventID: UUID = UUID(),
            intent: InteractionIntent<Context>,
            occurredAt: Date = Date()
        ) {
            self.eventID = eventID
            self.intent = intent
            self.occurredAt = occurredAt
        }
    }

    nonisolated struct ExecutionKey: Hashable, Sendable {
        let rawValue: String
    }

    nonisolated enum ExecutionPolicy: Sendable, Equatable {
        case immediate
        case asyncExclusive(ExecutionKey)
    }

    nonisolated struct ExecutionRequest: Sendable {
        let executionID: UUID
        let operationName: String
        let correlationID: UUID?

        init(
            executionID: UUID = UUID(),
            operationName: String,
            correlationID: UUID? = nil
        ) {
            self.executionID = executionID
            self.operationName = operationName
            self.correlationID = correlationID
        }
    }

    nonisolated enum ExecutionState: String, Sendable, Equatable {
        case accepted
        case rejected
        case started
        case completed
        case failed
        case cancelled
    }

    nonisolated struct ExecutionEvent: Sendable, Equatable {
        let eventID: UUID
        let executionID: UUID
        let operationName: String
        let state: ExecutionState
        let correlationID: UUID?
        let reasonCode: String?
        let occurredAt: Date

        init(
            eventID: UUID = UUID(),
            request: ExecutionRequest,
            state: ExecutionState,
            reasonCode: String? = nil,
            occurredAt: Date = Date()
        ) {
            self.eventID = eventID
            self.executionID = request.executionID
            self.operationName = request.operationName
            self.state = state
            self.correlationID = request.correlationID
            self.reasonCode = reasonCode
            self.occurredAt = occurredAt
        }
    }

    nonisolated struct DemoCompletedPayload: Sendable, Equatable {
        let message: String
    }

    nonisolated struct DomainEvent<Payload: Sendable>: Sendable {
        let eventID: UUID
        let name: String
        let payload: Payload
        let correlationID: UUID?
        let occurredAt: Date

        init(
            eventID: UUID = UUID(),
            name: String,
            payload: Payload,
            correlationID: UUID? = nil,
            occurredAt: Date = Date()
        ) {
            self.eventID = eventID
            self.name = name
            self.payload = payload
            self.correlationID = correlationID
            self.occurredAt = occurredAt
        }
    }

    nonisolated enum ObservationKind: String, Sendable, Equatable {
        case interaction
        case execution
        case domain
    }

    nonisolated enum ObservationValue: Sendable, Equatable {
        case string(String)
        case integer(Int)
        case double(Double)
        case boolean(Bool)

        var displayValue: String {
            switch self {
            case .string(let value):
                value
            case .integer(let value):
                value.formatted()
            case .double(let value):
                value.formatted()
            case .boolean(let value):
                value ? "true" : "false"
            }
        }
    }

    nonisolated struct ObservationRecord: Identifiable, Sendable, Equatable {
        let id: UUID
        let kind: ObservationKind
        let name: String
        let schemaVersion: Int
        let occurredAt: Date
        let correlationID: UUID?
        let attributes: [String: ObservationValue]
    }

    nonisolated struct ExecutionRejectedError: Error, Sendable, Equatable {
        let key: ExecutionKey
    }

    nonisolated struct DemoFailure: Error, Sendable {}
}
