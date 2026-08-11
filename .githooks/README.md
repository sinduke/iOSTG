# Git hooks

This repository requires commit subjects to use the following format:

```text
[Type] Short description
```

Allowed types are `Base`, `Feature`, `Fix`, `Refactor`, `Docs`, `Test`, and
`Chore`. Git-generated merge and revert messages, plus temporary `fixup!` and
`squash!` commits, are exempt.

Enable the version-controlled hooks in each clone:

```sh
git config core.hooksPath .githooks
```

Git clients that intentionally disable repository hooks are not covered. In
particular, the current ChatGPT/Codex desktop Git integration runs Git with
`core.hooksPath` disabled, so its **Commit instructions** setting or an
explicitly entered commit message is still required.
