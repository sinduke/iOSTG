//
//  LabDocumentationTests.swift
//  iOSTGTests
//
//  Created by Codex on 8/14/26.
//

import Testing
@testable import iOSTG

@Suite("Lab Documentation")
struct LabDocumentationTests {
    @Test("Button Design Markdown is bundled from the canonical document")
    func buttonDesignResourceIsBundled() throws {
        let markdown = try LabDocumentationResource.buttonDesign.markdown()

        #expect(markdown.contains("# Button Design：可运行的 Interaction System 示例"))
        #expect(markdown.contains("## 设计规则"))
    }

    @Test("Renderer supports the document's block structures")
    func rendererSupportsBlockStructures() {
        let markdown = """
        # Guide

        - First
        - Second

        1. Start
        2. Finish

        ```swift
        let value = true
        ```
        """

        let html = LabMarkdownHTMLRenderer().render(
            markdown: markdown,
            title: "Guide"
        )

        #expect(html.contains("<h1>Guide</h1>"))
        #expect(html.contains("<ul>"))
        #expect(html.contains("<ol>"))
        #expect(html.contains("<pre><code class=\"language-swift\">"))
        #expect(html.contains("let value = true"))
        #expect(html.contains("env(safe-area-inset-top)"))
    }

    @Test("Renderer formats inline Markdown and escapes HTML")
    func rendererFormatsInlineContentSafely() {
        let markdown = "Use `AppButton`, **strong**, *emphasis*, and <script>alert(1)</script>."

        let html = LabMarkdownHTMLRenderer().render(
            markdown: markdown,
            title: "Safety"
        )

        #expect(html.contains("<code>AppButton</code>"))
        #expect(html.contains("<strong>strong</strong>"))
        #expect(html.contains("<em>emphasis</em>"))
        #expect(html.contains("&lt;script&gt;alert(1)&lt;/script&gt;"))
        #expect(!html.contains("<script>alert(1)</script>"))
    }
}
