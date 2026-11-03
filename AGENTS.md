# AGENTS.md

custom-controls-customer is a **template**: a customer copies it, puts their
own frontend artefacts (a UI5 library, an icon font, CSS, a custom control)
under `app/webapp/`, generates the BSP `Z2UI5_CCC` from them and installs it
with abapGit next to abap2UI5 - no change to the framework or its frontend BSP.
README.md is the user documentation; keep it and this file in step.

## Layout

| Path | Purpose |
| --- | --- |
| `app/webapp/` | The source of the BSP: `cc/Extension.js` (loaded by abap2UI5 from the reserved resourceRoot `z2ui5_ccc`), `cc/Example.js`, `css/style.css`, `Util.js`, `index.html` |
| `tools/app2bsp.mjs` | Generates `src/01/` from `app/webapp/`: a BSP page per file, the UI5 repository path mapping, the page directory and the two ICF nodes |
| `src/01/` | The BSP `Z2UI5_CCC` and its ICF nodes - **generated**, never edited |
| `src/z2ui5_cl_ccc.clas.abap` | The ABAP helper the apps call |
| `src/00/` | The sample app `z2ui5_cl_ccc_sample_00` |
| `site/` | The documentation site (VitePress) - https://abap2ui5-addons.github.io/custom-controls-customer/ |

## Rules

- **Edit `app/webapp/`, then run `npm run app2bsp` and commit both.** CI
  regenerates the BSP and fails on a diff (`npm run check:bsp`), so a stale
  page never ships old JavaScript.
- **The resourceRoot `z2ui5_ccc` is reserved by abap2UI5** for this
  repository; `z2ui5_cci` belongs to abap2UI5-addons/custom-controls. Do not
  move either - the framework's frontend loads them by name.
- **A BSP page is stored as 255-character lines** (`tools/app2bsp.mjs`,
  `LINE_WIDTH`): a longer line is cut into 255-character chunks, a line break
  in the middle of whatever stands there. Keep every line of `app/webapp/`
  shorter.
- **UI5 1.71 is the floor**, as everywhere in abap2UI5: no module or API newer
  than that in `app/webapp/`.

## Commands

```sh
npm ci
npm run check   # abaplint, the scripts parse, the BSP is up to date
npm run site    # the documentation site into build/site
```

English for code, comments, commit messages and pull requests. The wider
rules live in abap2UI5's
[CONVENTIONS.md](https://github.com/abap2UI5/abap2UI5/blob/main/.github/shared/CONVENTIONS.md).
