//
//  ButtonDesignProjection.swift
//  iOSTG
//
//  Created by Codex on 8/14/26.
//

import Foundation

extension ButtonDesignExample {
    nonisolated struct ButtonInteractionProjector: Sendable {
        func project(
            _ event: InteractionEvent<ButtonContext>
        ) -> ObservationRecord {
            ObservationRecord(
                id: event.eventID,
                kind: .interaction,
                name: event.intent.name.rawValue,
                schemaVersion: 1,
                occurredAt: event.occurredAt,
                correlationID: event.intent.correlationID,
                attributes: [
                    "example": .string(event.intent.context.example),
                    "source": .string(event.intent.context.source)
                ]
            )
        }
    }

    nonisolated struct ExecutionProjector: Sendable {
        func project(_ event: ExecutionEvent) -> ObservationRecord {
            var attributes: [String: ObservationValue] = [
                "execution_id": .string(event.executionID.uuidString),
                "state": .string(event.state.rawValue)
            ]

            if let reasonCode = event.reasonCode {
                attributes["reason_code"] = .string(reasonCode)
            }

            return ObservationRecord(
                id: event.eventID,
                kind: .execution,
                name: "\(event.operationName).\(event.state.rawValue)",
                schemaVersion: 1,
                occurredAt: event.occurredAt,
                correlationID: event.correlationID,
                attributes: attributes
            )
        }
    }

    nonisolated struct DemoDomainProjector: Sendable {
        func project(
            _ event: DomainEvent<DemoCompletedPayload>
        ) -> ObservationRecord {
            ObservationRecord(
                id: event.eventID,
                kind: .domain,
                name: event.name,
                schemaVersion: 1,
                occurredAt: event.occurredAt,
                correlationID: event.correlationID,
                attributes: [
                    "message": .string(event.payload.message)
                ]
            )
        }
    }
}
