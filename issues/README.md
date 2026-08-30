# Issues

Use `issues/` for local issue notes that can also serve as implementation task briefs or GitHub Issue drafts.

## Scope

- Keep one issue file per concrete problem or improvement.
- Use lowercase kebab-case for `<issue-name>`.
- Write issue bodies in English.
- Do not add a status field. The presence of an issue note is enough for this repository.

## Layout

- Without attachments: `issues/<issue-name>.md`
- With attachments: `issues/<issue-name>/ISSUE.md`
- Put attachments directly under `issues/<issue-name>/`.

## Format

Start from `issues/TEMPLATE.md`.

The standard headings are:

- `Summary`
- `Background`
- `Problem`
- `Expected`
- `Done When`
- `Notes`

Delete headings that are clearly irrelevant. If a heading might apply but has not been investigated or decided yet, keep it and leave `TODO`.

Use `Problem` for current symptoms or constraints. Use `Expected` for the desired user-visible state.

For improvement or implementation issues, `Done When` is required. Write checkable completion conditions as bullet points. For research-only notes, `Done When` is optional.

Use `Notes` for supporting details that do not fit the main headings, such as logs, error output, links, and investigation notes. Redact secrets, tokens, credentials, private paths, hostnames, and personal data before committing notes or turning them into GitHub Issues. Prefer summarized logs unless exact output is needed.

## Examples

- `issues/backup-files.md`
