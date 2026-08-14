//
//  LabDocumentationResource.swift
//  iOSTG
//
//  Created by Codex on 8/14/26.
//

import Foundation

nonisolated struct LabDocumentationResource: Equatable, Sendable {
    let title: String
    let fileName: String
    let fileExtension: String

    static let buttonDesign = LabDocumentationResource(
        title: "Full Chinese Guide",
        fileName: "ButtonDesign",
        fileExtension: "md"
    )

    func markdown(in bundle: Bundle = .main) throws -> String {
        guard let url = bundle.url(
            forResource: fileName,
            withExtension: fileExtension
        ) else {
            throw LabDocumentationError.resourceNotFound(
                "\(fileName).\(fileExtension)"
            )
        }

        return try String(contentsOf: url, encoding: .utf8)
    }
}

nonisolated enum LabDocumentationError: LocalizedError, Equatable {
    case resourceNotFound(String)

    var errorDescription: String? {
        switch self {
        case .resourceNotFound(let name):
            "The bundled documentation resource \(name) could not be found."
        }
    }
}
