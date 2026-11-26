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

## Branch DEV

`main` is the template. `DEV` carries the configuration of the S5S
installation (the /KRO/ apps): the icon font "my-icons" (taken over from the
reuse-library BSP `ZREUSEICONS`: the WOFF as a base64 data URI in
`css/icons.css`, the 30 icon names and code points in `ICONS` of
`cc/Extension.js`) and the /KRO/ stylesheet (`css/style.css`: row colours of
the layout-management tables, column-sort headers, phone padding, popover
size). The /KRO/ views declare the extension in
`/KRO/UI501_CL_APP_VIEW=>xml_build_page` and carry the class `kroApp`.

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
npm run check   # abaplint (Standard and Cloud), the scripts parse, the BSP is up to date
npm run site    # the documentation site into build/site
```

## CI

CI comes from the shared CI template of abap2UI5-addons (reusable workflows in
[rap-ext](https://github.com/abap2UI5-addons/rap-ext/blob/main/.github/ci/README.md),
pinned by commit in the `uses:` lines and moved by `bump-deps`):

* `ci` - on every push to `main`, every pull request, weekly and by hand,
  one job per check: `check / abaplint (./abaplint.jsonc)`,
  `check / abaplint (.github/abaplint/abap_cloud.jsonc)` (ABAP Cloud),
  `check / npm run check:js` and `check / npm run check:bsp` - these are the
  required status checks of the branch protection. No abap2UI5-linter: its
  render gate cannot know `z2ui5_ccc.cc.Example`, a control shipped from its
  own BSP, and there is no `abap2ui5lint.jsonc`. No unit tests. `check /
  rename` is the namespace rename check (below).
* `ci-702` - on every push to `main` `npm run auto_downport`, a force-push
  to the branch `702`, then abaplint on that branch
  (`.github/abaplint/abap_702.jsonc`). Never commit to `702` by hand.
* `build-rename` (manual) - pushes the renamed branch `rename_<name>`.
* `deploy-pages`, `bump-deps` (monthly; the template pin moves only with the
  `DEPS_TOKEN` secret). No sibling addon, so no `.github/deps.json`.

## Namespace rename

`npm run rename` (CI: `check / rename`) and the manual `build-rename`
workflow are abap2UI5's namespace rename - `.github/scripts/rename.mjs`, the
same file in every repository that has one: every `z2ui5_` object becomes
`<name>_...` or `/<ns>/...` (at most 10 characters), and so does every
reference to abap2UI5, which is renamed along. A customer who copies this
template into their own namespace by hand does not need it; it is for an
installation renamed as a whole. Not complete yet - `package.json` `config`,
printed on every run:

- **`src/01` is not renamed** (`renameSkip`): abaplint cannot rename a BSP
  (WAPA) - abap2UI5 backlog item `abaplint-rename-wapa`, abaplint PR #4721 -
  and the abap2UI5 frontend reserves the resource root `z2ui5_ccc`.
- **One literal stays** (`renameLiterals`): `z2ui5_cl_ccc=>c_ns`, that
  resource root. Any other literal naming a `z2ui5_` object fails the check.

English for code, comments, commit messages and pull requests. The wider
rules live in abap2UI5's
[CONVENTIONS.md](https://github.com/abap2UI5/abap2UI5/blob/main/.github/shared/CONVENTIONS.md).
