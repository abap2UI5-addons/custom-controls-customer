# Contributing

Your own frontend artefacts for abap2UI5 - a UI5 library, an icon font, CSS or a control - served from a BSP of your own.

## Before you open a pull request

Run what CI runs:

```sh
npm ci
npm run check
```

`npm run check` is the set of steps the workflows run on a pull request, so a
green run locally is a green run there.

## What the gates are

| Gate | What it proves |
| --- | --- |
| `npm run lint` | abaplint over `src/` |
| `npm run check:js` | every script under `app/webapp/` parses |
| `npm run check:bsp` | the BSP under `src/01/` is what `npm run app2bsp` generates from `app/webapp/` - never edit it by hand |

Nothing here runs in a browser in CI. Say in the pull request whether the change was tried in a system.

## Conventions

English for code, comments, commit messages and pull requests. Commit subjects
are written in the imperative and describe the outcome, not the mechanics. One
topic per pull request. The wider rules the whole ecosystem follows live in
[abap2UI5's CONVENTIONS.md](https://github.com/abap2UI5/abap2UI5/blob/main/.github/shared/CONVENTIONS.md).
