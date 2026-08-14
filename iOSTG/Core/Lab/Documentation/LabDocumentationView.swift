//
//  LabDocumentationView.swift
//  iOSTG
//
//  Created by Codex on 8/14/26.
//

import SwiftUI
import WebKit

struct LabDocumentationView: View {
    private enum LoadState: Equatable {
        case loading
        case loaded
        case failed(String)
    }

    let resource: LabDocumentationResource

    @State private var page: WebPage
    @State private var loadState: LoadState = .loading
    @State private var reloadID = UUID()

    init(resource: LabDocumentationResource) {
        self.resource = resource

        var configuration = WebPage.Configuration()
        configuration.loadsSubresources = false
        self._page = State(
            initialValue: WebPage(
                configuration: configuration,
                navigationDecider: LabDocumentationNavigationDecider()
            )
        )
    }

    var body: some View {
        ZStack {
            WebView(page)
                .webViewBackForwardNavigationGestures(.disabled)
                .webViewLinkPreviews(.disabled)
                .webViewTextSelection(.enabled)
                .opacity(loadState == .loaded ? 1 : 0)
                .ignoresSafeArea(.container, edges: .top)

            stateOverlay
        }
        .navigationTitle(resource.title)
        .navigationBarTitleDisplayMode(.inline)
        .task(id: reloadID, loadDocumentation)
    }

    @ViewBuilder
    private var stateOverlay: some View {
        switch loadState {
        case .loading:
            ProgressView("Loading guide…")
        case .loaded:
            EmptyView()
        case .failed(let message):
            ContentUnavailableView {
                Label("Unable to Load Guide", systemImage: "doc.text.magnifyingglass")
            } description: {
                Text(message)
            } actions: {
                Button("Retry") {
                    reloadID = UUID()
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }

    private func loadDocumentation() async {
        loadState = .loading

        do {
            let markdown = try resource.markdown()
            let html = LabMarkdownHTMLRenderer().render(
                markdown: markdown,
                title: resource.title
            )

            for try await event in page.load(html: html) {
                guard !Task.isCancelled else { return }
                if event == .committed || event == .finished {
                    loadState = .loaded
                }
            }
        } catch is CancellationError {
            return
        } catch {
            guard !Task.isCancelled else { return }
            loadState = .failed(error.localizedDescription)
        }
    }
}

private struct LabDocumentationNavigationDecider: WebPage.NavigationDeciding {
    mutating func decidePolicy(
        for action: WebPage.NavigationAction,
        preferences: inout WebPage.NavigationPreferences
    ) async -> WKNavigationActionPolicy {
        _ = preferences

        guard let scheme = action.request.url?.scheme?.lowercased() else {
            return .cancel
        }

        return scheme == "about" ? .allow : .cancel
    }
}

#Preview {
    NavigationStack {
        LabDocumentationView(resource: .buttonDesign)
    }
}
