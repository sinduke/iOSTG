//
//  LabMarkdownHTMLRenderer.swift
//  iOSTG
//
//  Created by Codex on 8/14/26.
//

import Foundation

nonisolated struct LabMarkdownHTMLRenderer: Sendable {
    func render(markdown: String, title: String) -> String {
        let body = renderBlocks(markdown)

        return """
        <!doctype html>
        <html lang="zh-Hans">
        <head>
          <meta charset="utf-8">
          <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
          <title>\(escape(title))</title>
          <style>
        \(Self.stylesheet)
          </style>
        </head>
        <body>
        \(body)
        </body>
        </html>
        """
    }

    private static let stylesheet = """
      :root {
        color-scheme: light dark;
        --background: #ffffff;
        --foreground: #171717;
        --secondary: #66666b;
        --border: #dedee3;
        --code-background: #f2f2f7;
        --accent: #5e35d5;
      }

      @media (prefers-color-scheme: dark) {
        :root {
          --background: #000000;
          --foreground: #f5f5f7;
          --secondary: #a1a1aa;
          --border: #35353a;
          --code-background: #1c1c1e;
          --accent: #a78bfa;
        }
      }

      * { box-sizing: border-box; }

      body {
        margin: 0 auto;
        max-width: 760px;
        padding: calc(env(safe-area-inset-top) + 104px) 18px
          calc(env(safe-area-inset-bottom) + 72px);
        background: var(--background);
        color: var(--foreground);
        font: 17px/1.68 -apple-system, BlinkMacSystemFont, "SF Pro Text", sans-serif;
        overflow-wrap: break-word;
        -webkit-text-size-adjust: 100%;
      }

      h1, h2, h3, h4, h5, h6 {
        line-height: 1.25;
        margin: 1.6em 0 0.65em;
      }

      h1 { font-size: 2rem; margin-top: 0.35em; }
      h2 { font-size: 1.5rem; border-bottom: 1px solid var(--border); padding-bottom: 0.35em; }
      h3 { font-size: 1.2rem; }
      p { margin: 0.85em 0; }
      ul, ol { padding-left: 1.45em; }
      li { margin: 0.45em 0; }

      code {
        padding: 0.12em 0.35em;
        border-radius: 0.35em;
        background: var(--code-background);
        color: var(--accent);
        font: 0.88em/1.5 ui-monospace, "SFMono-Regular", Menlo, monospace;
      }

      pre {
        overflow-x: auto;
        padding: 14px;
        border: 1px solid var(--border);
        border-radius: 12px;
        background: var(--code-background);
        -webkit-overflow-scrolling: touch;
      }

      pre code {
        padding: 0;
        background: transparent;
        color: var(--foreground);
        white-space: pre;
      }

      hr {
        margin: 2em 0;
        border: 0;
        border-top: 1px solid var(--border);
      }
    """

    private func renderBlocks(_ markdown: String) -> String {
        let lines = markdown
            .replacingOccurrences(of: "\r\n", with: "\n")
            .split(separator: "\n", omittingEmptySubsequences: false)
            .map(String.init)
        var output: [String] = []
        var index = 0

        while index < lines.count {
            let line = lines[index]
            let trimmed = line.trimmingCharacters(in: .whitespaces)

            if trimmed.isEmpty {
                index += 1
                continue
            }

            if trimmed.hasPrefix("```") {
                output.append(renderCodeBlock(lines: lines, index: &index))
                continue
            }

            if let heading = heading(from: trimmed) {
                output.append(
                    "<h\(heading.level)>\(renderInline(heading.text))</h\(heading.level)>"
                )
                index += 1
                continue
            }

            if trimmed == "---" || trimmed == "***" {
                output.append("<hr>")
                index += 1
                continue
            }

            if isUnorderedListItem(trimmed) {
                output.append(renderList(lines: lines, index: &index, ordered: false))
                continue
            }

            if orderedListText(from: trimmed) != nil {
                output.append(renderList(lines: lines, index: &index, ordered: true))
                continue
            }

            output.append(renderParagraph(lines: lines, index: &index))
        }

        return output.joined(separator: "\n")
    }

    private func renderCodeBlock(
        lines: [String],
        index: inout Int
    ) -> String {
        let openingLine = lines[index].trimmingCharacters(in: .whitespaces)
        let language = String(openingLine.dropFirst(3))
            .trimmingCharacters(in: .whitespaces)
        var codeLines: [String] = []
        index += 1

        while index < lines.count {
            let line = lines[index]
            if line.trimmingCharacters(in: .whitespaces).hasPrefix("```") {
                index += 1
                break
            }

            codeLines.append(line)
            index += 1
        }

        let languageClass = language.isEmpty
            ? ""
            : " class=\"language-\(escapeAttribute(language))\""
        return "<pre><code\(languageClass)>\(escape(codeLines.joined(separator: "\n")))</code></pre>"
    }

    private func renderList(
        lines: [String],
        index: inout Int,
        ordered: Bool
    ) -> String {
        let tag = ordered ? "ol" : "ul"
        var items: [String] = []

        while index < lines.count {
            let line = lines[index].trimmingCharacters(in: .whitespaces)
            let text: String?

            if ordered {
                text = orderedListText(from: line)
            } else if isUnorderedListItem(line) {
                text = String(line.dropFirst(2))
            } else {
                text = nil
            }

            guard let text else { break }
            items.append("<li>\(renderInline(text))</li>")
            index += 1
        }

        return "<\(tag)>\n\(items.joined(separator: "\n"))\n</\(tag)>"
    }

    private func renderParagraph(
        lines: [String],
        index: inout Int
    ) -> String {
        var paragraphLines: [String] = []

        while index < lines.count {
            let line = lines[index]
            let trimmed = line.trimmingCharacters(in: .whitespaces)

            guard !trimmed.isEmpty,
                  !isBlockStart(trimmed) || paragraphLines.isEmpty
            else {
                break
            }

            paragraphLines.append(trimmed)
            index += 1
        }

        return "<p>\(renderInline(paragraphLines.joined(separator: " ")))</p>"
    }

    private func renderInline(_ text: String) -> String {
        var output = ""
        var index = text.startIndex

        while index < text.endIndex {
            if text[index] == "`",
               let closing = text[text.index(after: index)...].firstIndex(of: "`") {
                let value = String(text[text.index(after: index)..<closing])
                output += "<code>\(escape(value))</code>"
                index = text.index(after: closing)
                continue
            }

            if text[index...].hasPrefix("**"),
               let closing = text[text.index(index, offsetBy: 2)...]
                .range(of: "**")?.lowerBound {
                let value = String(text[text.index(index, offsetBy: 2)..<closing])
                output += "<strong>\(escape(value))</strong>"
                index = text.index(closing, offsetBy: 2)
                continue
            }

            if text[index] == "*",
               let closing = text[text.index(after: index)...].firstIndex(of: "*") {
                let value = String(text[text.index(after: index)..<closing])
                output += "<em>\(escape(value))</em>"
                index = text.index(after: closing)
                continue
            }

            output += escape(String(text[index]))
            index = text.index(after: index)
        }

        return output
    }

    private func heading(from line: String) -> (level: Int, text: String)? {
        let markerCount = line.prefix(while: { $0 == "#" }).count
        guard (1...6).contains(markerCount) else { return nil }

        let textStart = line.index(line.startIndex, offsetBy: markerCount)
        guard textStart < line.endIndex, line[textStart] == " " else { return nil }

        return (
            markerCount,
            String(line[line.index(after: textStart)...])
        )
    }

    private func orderedListText(from line: String) -> String? {
        guard let dotIndex = line.firstIndex(of: "."),
              dotIndex < line.index(before: line.endIndex),
              line[line.index(after: dotIndex)] == " ",
              !line[..<dotIndex].isEmpty,
              line[..<dotIndex].allSatisfy(\.isNumber)
        else {
            return nil
        }

        return String(line[line.index(dotIndex, offsetBy: 2)...])
    }

    private func isUnorderedListItem(_ line: String) -> Bool {
        line.hasPrefix("- ") || line.hasPrefix("* ")
    }

    private func isBlockStart(_ line: String) -> Bool {
        line.hasPrefix("```")
            || heading(from: line) != nil
            || line == "---"
            || line == "***"
            || isUnorderedListItem(line)
            || orderedListText(from: line) != nil
    }

    private func escape(_ value: String) -> String {
        value
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "\"", with: "&quot;")
            .replacingOccurrences(of: "'", with: "&#39;")
    }

    private func escapeAttribute(_ value: String) -> String {
        escape(value.filter { $0.isLetter || $0.isNumber || $0 == "-" })
    }
}
