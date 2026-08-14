//
//  ButtonDesignObservation.swift
//  iOSTG
//
//  Created by Codex on 8/14/26.
//

import Observation

extension ButtonDesignExample {
    nonisolated protocol ObservationSink: Sendable {
        func consume(_ record: ObservationRecord) async
    }

    actor NoOpObservationSink: ObservationSink {
        func consume(_ record: ObservationRecord) async {
            _ = record
        }
    }

    @MainActor
    @Observable
    final class ObservationStore {
        private(set) var records: [ObservationRecord] = []

        func append(_ record: ObservationRecord) {
            records.append(record)
        }

        func clear() {
            records.removeAll()
        }
    }

    nonisolated struct StoreObservationSink: ObservationSink {
        let store: ObservationStore

        func consume(_ record: ObservationRecord) async {
            await store.append(record)
        }
    }

    actor ObservationReporter {
        private let sinks: [any ObservationSink]

        init(sinks: [any ObservationSink]) {
            self.sinks = sinks
        }

        func emit(_ record: ObservationRecord) async {
            await withTaskGroup(of: Void.self) { group in
                for sink in sinks {
                    group.addTask {
                        await sink.consume(record)
                    }
                }
            }
        }
    }
}
