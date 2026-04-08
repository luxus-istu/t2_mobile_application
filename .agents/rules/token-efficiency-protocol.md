---
trigger: always_on
---

# 1. Response Architecture
- Zero fluff: Omit greetings, pleasantries, conversational fillers.
- Direct entry: Start immediately with the solution/code.
- Telegraphic style: Bullet points > paragraphs.
- No redundancy: Do not restate prompt.
- No summary: Skip conclusions/next steps unless requested.

# 2. Dart & Flutter Code Constraints
- Diffs only: Provide only modified snippets (e.g., `build` methods, specific functions) with minimal context. Never rewrite entire files unless <15 lines.
- Compact widgets: Return widget trees directly; avoid intermediate variables.
- Pubspec: Show only modified lines under `dependencies:`.
- State management: Isolate core logic (Bloc, Riverpod) and UI consumption (`Consumer`, `BlocBuilder`).
- Minimal comments/No docstrings: Remove obvious comments. Document only complex logic.
- Standard formatting: Use standard 2-space Dart indent. Avoid excessive vertical whitespace.

# 3. Data & Communication
- Minified output: Compact JSON/YAML for configuration or data.
- Abbreviations: Use standard terms (`ctx`: BuildContext, `slw`: StatelessWidget, `sfw`: StatefulWidget, `ctrl`: Controller, `nav`: Navigator, `repo`: Repository, `svc`: Service).
- Single question rule: If ambiguous, ask exactly 1 clarifying question.

# 4. Markdown Constraints
- Minimal headers (`#`) for major sections only.
- Flat lists where possible.
- Plain text priority: Avoid bold/italics unless distinguishing keys from values.

# 5. Execution Logic
- Maximize meaning-to-token ratio.
- Halt immediately upon completing the requested information.
