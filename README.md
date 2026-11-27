# custom-controls-customer

[![abap2UI5-addons](https://img.shields.io/badge/abap2UI5--addons-template-1873b4)](https://github.com/abap2UI5-addons)
[![ABAP](https://img.shields.io/badge/ABAP-Standard%20%E2%89%A5%207.50-blue)](#installation)
[![abap2UI5](https://img.shields.io/badge/requires-abap2UI5-blue)](https://github.com/abap2UI5/abap2UI5)
[![License](https://img.shields.io/github/license/abap2UI5-addons/custom-controls-customer)](LICENSE)
<br>
[![CI](https://img.shields.io/github/actions/workflow/status/abap2UI5-addons/custom-controls-customer/ci.yaml?branch=main&label=CI)](https://github.com/abap2UI5-addons/custom-controls-customer/actions/workflows/ci.yaml)
[![ABAP 7.02](https://img.shields.io/github/actions/workflow/status/abap2UI5-addons/custom-controls-customer/ci-702.yaml?branch=main&label=ABAP%207.02)](https://github.com/abap2UI5-addons/custom-controls-customer/actions/workflows/ci-702.yaml)

**A template repository for your own frontend artefacts in abap2UI5.** A UI5
reuse library, an icon font, corporate CSS, a custom control — served to
[abap2UI5](https://github.com/abap2UI5/abap2UI5) from a BSP that belongs to
you. Fork it (or copy it into your own git host), put your files under
`app/webapp/`, run `npm run app2bsp`, and install the result with abapGit.
Nothing in abap2UI5 or in its frontend BSP has to change, and no pull request
against the framework is needed.

> Part of [abap2UI5-addons](https://github.com/abap2UI5-addons) - addons and apps for [abap2UI5](https://github.com/abap2UI5/abap2UI5), installed with [abapGit](https://abapgit.org). Documentation: [abap2ui5-addons.github.io/custom-controls-customer](https://abap2ui5-addons.github.io/custom-controls-customer/).

## Make it yours in five steps

You do not need to know UI5 internals or touch abap2UI5 for this. If you can
edit a file and use abapGit, you can do it.

1. **Fork this repository** on GitHub (button "Fork" at the top right), or
   copy it into your own git host. Your fork is yours: the files you add stay
   there and never have to go back here.
2. **Put your files under `app/webapp/`** - your CSS into `css/style.css`,
   an icon font into `css/icons.css`, a custom control into `cc/` - in
   place of the customer example that ships there (see below).
3. **Register them in `app/webapp/cc/Extension.js`.** At the top there are
   five short lists - resource roots, libraries, icon fonts, icons,
   stylesheets. Every list has a commented-out example; copy it and fill in
   your names.
4. **Build and check:** `npm ci`, then `npm run app2bsp` (turns
   `app/webapp/` into the BSP files under `src/01`) and `npm run check`.
   Commit both `app/webapp/` and `src/01`.
5. **Install** abap2UI5 first, then your fork, with abapGit. Open
   `?app_start=z2ui5_cl_ccc_sample_00` - if the badge shows and reacts to a
   click, everything is in place. In your apps, call
   `z2ui5_cl_ccc=>render( page )` once per view (see [Use it from
   ABAP](#4-use-it-from-abap)).

**A filled-in example is already in the box.** `main` ships a real customer
example (anonymous): an icon font with 30 icons in
[`css/icons.css`](app/webapp/css/icons.css) and `ICONS` of
[`cc/Extension.js`](app/webapp/cc/Extension.js), the customer's stylesheet in
[`css/style.css`](app/webapp/css/style.css), and the app
[`z2ui5_cl_ccc_sample_01`](src/00/z2ui5_cl_ccc_sample_01.clas.abap)
(`?app_start=z2ui5_cl_ccc_sample_01`) that uses all of it - icons, row
colours, a column-sort header. Look at it after installing, then replace
those files with your own (or delete them) in your fork.

That's it. When this template gets an update, pull it into your fork
("Sync fork" on GitHub) - your own files are not touched by it, as long as
you only added files and filled in the lists in `Extension.js`.

**Example - your own icon font.** Turn the font into a base64 data URI and
write it into `css/icons.css`:

```css
@font-face {
  font-family: "MyCustomFontFamily";
  src: url("data:font/woff;base64,d09GRgABAAAAA...") format("woff");
}
```

then add `Util.url("css/icons.css")` to `STYLESHEETS` and the icon names with
their code points to `ICONS` in `Extension.js`:

```js
const ICONS = [{
  collectionName: "my-icons",
  fontFamily: "MyCustomFontFamily",
  icons: { Regal: "e910", Stapler: "e915" },
}];
```

Every view that calls `z2ui5_cl_ccc=>render( )` can now use
`sap-icon://my-icons/Regal`. A BSP page is text, so a font has to be a data
URI; a long base64 string may be split over several lines with a `\` at the
end of each line (lines stay below 255 characters).

## Why

Adding a UI5 reuse library to abap2UI5 used to mean patching the framework's
own BSP by hand, in four places:

| File | Patch |
|---|---|
| `index.html` | `data-sap-ui-resourceroots` → `"com.myorg.reuselib": "/sap/bc/ui5_ui5/sap/zreuseicons/"` |
| `manifest.json` | `sap.ui5.dependencies.libs` → `"com.myorg.reuselib": {}` |
| `View1.view.xml` | `xmlns:custom="com.myorg.reuselib"` |
| `View1.controller.js` | `sap.ui.define([… "com/myorg/reuselib/library"])` |

All four are **generated** in the abap2UI5 repository and part of its BSP
`Z2UI5`, which is force-overwritten on every framework update — so the patch survives exactly until the next
upgrade, and then the icons are gone with no error message.

This repository is the supported place for those artefacts instead. It is the
same mechanism [abap2UI5-addons/custom-controls](https://github.com/abap2UI5-addons/custom-controls)
uses for the community controls, with a second reserved namespace so the two
never collide.

## Installation

**Requirements**

- Standard ABAP 7.50 or higher
- NetWeaver 7.02 - 7.40: the branch `702`, downported automatically from
  `main` on every push - pull abap2UI5 from its `702` branch as well
- [abap2UI5](https://github.com/abap2UI5/abap2UI5) - a version that reserves
  the `z2ui5_ccc` resourceRoot, installed in the backend. On an older
  framework the check app renders an empty page and the browser console shows
  a failed request for `z2ui5_ccc/cc/Extension.js`.

**Steps** - with [abapGit](https://abapgit.org), in this order:

1. [abap2UI5](https://github.com/abap2UI5/abap2UI5) - it brings the ICF node
   and the BSP `Z2UI5` for BSP and launchpad mode itself
2. fork this repository (or copy it into your own git host) and put your
   artefacts in - see [Usage](#usage)
3. your fork (branch `main`) - it brings the ABAP classes, the BSP
   application `Z2UI5_CCC` and the two ICF nodes it is served from

**Start** - **`?app_start=z2ui5_cl_ccc_sample_00`** — the check app, and
**`?app_start=z2ui5_cl_ccc_sample_01`** — the customer example. If the badge
renders, is styled and reacts to a click, the BSP is deployed and the
frontend resolves `z2ui5_ccc`.

## Usage

### 1. Drop the files under `app/webapp/`

```
app/webapp/
├── index.html          the BSP start page - a note, this BSP has no UI
├── Util.js             small helpers (url, loadStyle, loadScript, logError, isDestroyed)
├── cc/
│   ├── Extension.js    THE FILE YOU EDIT - the five config lists
│   └── Example.js      a template custom control
└── css/
    └── style.css       your CSS
```

Two limits come from the BSP page format and are checked by `app2bsp`, which
fails loudly rather than letting SAP reject the import:

* **at most one directory level** — `cc/Example.js` is fine, `cc/lib/x.js` is not
* **names from letters, digits, `_` and `.` only** — no hyphens

### 2. Declare what has to be registered

Everything that must happen once, before a view can use your artefacts, is
declared at the top of `app/webapp/cc/Extension.js`:

```js
const RESOURCE_ROOTS = {
  "com.myorg.reuselib": "/sap/bc/ui5_ui5/sap/zreuseicons/",
};

const LIBRARIES = ["com.myorg.reuselib"];

const ICON_FONTS = [{
  fontFamily: "MyCustomFontFamily",
  collectionName: "my-icons",
  fontURI: Util.url("fonts"),
  metadata: { Regal: "e910", Stapler: "e917" },
}];

const STYLESHEETS = [Util.url("css/style.css")];
```

Those blocks are the replacement for the four framework patches in the
table above. A fifth list, `ICONS`, registers the icons of a font this BSP
serves itself (see [Make it yours](#make-it-yours-in-five-steps)).

### 3. Regenerate and commit

```bash
npm run app2bsp        # app/webapp -> src/01 (BSP pages, page directory, ICF nodes)
npm run check          # abaplint, the scripts parse, the BSP is up to date
```

CI runs the same checks and fails on a diff, so a stale BSP page can never ship old
JavaScript unnoticed.

### 4. Use it from ABAP

```abap
DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

DATA(root) = view->ele( n  = `View`
                        ns = `mvc`
    )->a( n = `xmlns`     v = `sap.m`
    )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc` ).

z2ui5_cl_ccc=>xmlns( root ).             " declares xmlns:z2ui5_ccc - once per view

DATA(page) = root->ele( `Page` )->a( n = `title` v = `Warehouse` ).

z2ui5_cl_ccc=>render( page ).            " loads and installs the extension

page->tag( `Button`
    )->a( n = `icon` v = `sap-icon://my-icons/Regal`   " your own icon font
    )->a( n = `text` v = `Rack` ).

client->view_display( view->stringify( ) ).
```

`render( )` is what pulls `Extension.js` into the page, so it belongs in every
view that relies on an icon font, a stylesheet or a registered library —
before the controls that use them. Calling it twice is harmless; the
installation runs once per page.

## How it works

abap2UI5 reserves the resourceRoot **`z2ui5_ccc`** in its `manifest.json`:

```json
"sap.ui5": { "resourceRoots": { "z2ui5_cci": "../z2ui5_cci/", "z2ui5_ccc": "../z2ui5_ccc/" } }
```

so the module `z2ui5_ccc/cc/Example` is served from
`/sap/bc/ui5_ui5/sap/z2ui5_ccc/cc/Example.js` — the BSP `Z2UI5_CCC` that this
repository builds. In the standalone HTTP service, where there is no sibling
BSP to resolve `../z2ui5_ccc/` against, `z2ui5_cl_ui5_http_handler` hands the
absolute path to the frontend instead. All three delivery modes (BSP,
launchpad, ICF service) therefore resolve it without configuration.

Registering the path costs nothing when this repository is not installed:
the browser requests nothing from `z2ui5_ccc` until a view actually names the
namespace.

```
your ABAP app  ──►  z2ui5_cl_ccc=>render( page )
                          │  emits <z2ui5_ccc:Extension/> into the view
                          ▼
abap2UI5 frontend  ──►  loads z2ui5_ccc/cc/Extension.js from YOUR BSP
                          │  which registers, at page level:
                          ├─ resource roots of other BSPs
                          ├─ UI5 reuse libraries
                          ├─ icon fonts (IconPool)
                          └─ stylesheets
```

## Keeping an existing reuse-library BSP

You do not have to move an existing library into this BSP. Leave
`ZREUSEICONS` where it is and register it in `RESOURCE_ROOTS` plus
`LIBRARIES` — one entry each, in a file that no framework update overwrites.
The library keeps its own name (`com.myorg.reuselib`), and views address it
under their own prefix:

```abap
root->a( n = `xmlns:custom` v = `com.myorg.reuselib` ).
```

Moving it in here is still the tidier option when you can: one BSP, one
transport, one thing to install.

## Binary artefacts

BSP pages are **text**. A `.woff2`, `.ttf` or `.png` cannot be committed under
`app/webapp` — `app2bsp` would mangle it, so it rejects the name instead. Two
ways work:

* **base64 data URI in CSS** — for a single icon font this is the simplest
  path, because a data URI *is* text and rides along in `css/style.css`:

  ```css
  @font-face {
    font-family: "MyCustomFontFamily";
    src: url("data:font/woff2;base64,d09GMgABAAAAA...") format("woff2");
  }
  ```

  With the names listed in `ICONS` of `Extension.js` such a font also serves
  `sap-icon://` icons - see [Make it yours](#make-it-yours-in-five-steps).
  (`ICON_FONTS` is different: there the UI5 `IconPool` loads the font file
  itself from `fontURI`, so that route needs the MIME objects below.)

* **MIME objects** — upload the font into the BSP with
  `/UI5/UI5_REPOSITORY_LOAD` (report `/UI5/UI5_REPOSITORY_LOAD` in `SE38`) or
  keep it as a `W3MI` object serialized by abapGit, then point `fontURI` at
  the URL it is served from. This is the right choice for anything large or
  for a font the IconPool has to read.

## Naming

ABAP objects here follow the scheme `z2ui5_<type>_<token>_<object>` the
abap2UI5 repositories share, with the token **`ccc`** — *custom control
customers* — reserved for this one, the way `smp` belongs to
[abap2UI5/samples](https://github.com/abap2UI5/samples) and `cci` to the
community add-on
[abap2UI5-addons/custom-controls](https://github.com/abap2UI5-addons/custom-controls).
So every class starts with `Z2UI5_CL_CCC` (`Z2UI5_CX_CCC` for exceptions,
`Z2UI5_IF_CCC` for interfaces) and is at most 25 characters long —
`object_naming` in `abaplint.jsonc` enforces both, and the comment
there explains where the 25 comes from.

The frontend side carries the same token: the BSP is `Z2UI5_CCC` and the
resourceRoot it is served under is **`z2ui5_ccc`** — the ABAP name of the BSP,
lowercased. A resourceRoot resolves to the BSP's URL
(`/sap/bc/ui5_ui5/sap/z2ui5_ccc/`), so the two are necessarily the same
string, and keeping the ABAP token in it means there is one name to remember
for the whole repository instead of two. It is reserved in the abap2UI5
`manifest.json`, which is what makes this BSP findable without patching
anything downstream.

The community controls follow the same rule, so
[abap2UI5-addons/custom-controls](https://github.com/abap2UI5-addons/custom-controls)
ships the BSP `Z2UI5_CCI` under the root `z2ui5_cci` for its `z2ui5_cl_cci*`
classes. The two roots therefore differ in the last letter only: `_cci` is
the community one, `_ccc` this one. They are distinct strings and cannot
collide, but a typo in a view's `xmlns:` resolves against the wrong BSP and
shows up only as a failed module request in the browser console — so when a
control does not render, check that letter first.

## Renaming

`Z2UI5_CCC` and the `Z2UI5_CL_CCC*` classes are the defaults. To use your own
namespace, change `BSP` and `PREFIX` in `tools/app2bsp.mjs`, the
`resourceRoots` key the frontend registers, the class names, and the
`object_naming` patterns in `abaplint.jsonc` — all together.

Be aware that `z2ui5_ccc` is the namespace abap2UI5 registers out of the box.
Renaming it means registering the new one yourself, which puts you back in the
business of patching framework files — so rename the ABAP objects if your
system demands it, but keep the resourceRoot.

## What is in the box

| Artefact | Purpose |
|---|---|
| `app/webapp/cc/Extension.js` | the bootstrap element — resource roots, libraries, icon fonts, stylesheets |
| `app/webapp/cc/Example.js` | a template custom control (property, event, renderer) |
| `app/webapp/Util.js` | `url`, `loadStyle`, `loadScript`, `logError`, `isDestroyed` |
| `src/z2ui5_cl_ccc.clas.abap` | ABAP side — `xmlns( )`, `render( )`, `example( )`, `tag( )` |
| `src/00/z2ui5_cl_ccc_sample_00.clas.abap` | installation check app |
| `src/00/z2ui5_cl_ccc_sample_01.clas.abap` | the customer example: icons, row colours, column-sort header |
| `app/webapp/css/icons.css` | the customer example's icon font (base64 data URI) |
| `tools/app2bsp.mjs` | `app/webapp` → the abapGit BSP artefacts under `src/01` |

## Development

CI (`.github/workflows/ci.yaml`, from the shared CI template of
abap2UI5-addons) runs on every push to `main`, every pull request and weekly:
abaplint against `abaplint.jsonc` (Standard ABAP) and
`.github/abaplint/abap_cloud.jsonc` (ABAP Cloud), a check that the BSP under
`src/01` matches `app/webapp` (`npm run check:bsp`: `npm run app2bsp` must
leave no diff), and a syntax check of every JavaScript file under `app/webapp`
(`npm run check:js`). `ci-702` writes the downported branch `702` on every
push to `main` and lints it. Run the same before you push:

```bash
npm ci
npm run app2bsp
npm run check
```

## Related

* [abap2UI5-addons/custom-controls](https://github.com/abap2UI5-addons/custom-controls)
  — the same mechanism under the reserved namespace `z2ui5_cci`, for controls
  shared with the community. If what you are building is generally useful,
  contribute it there instead.

## Contributing

Issues and pull requests are welcome - see [CONTRIBUTING.md](CONTRIBUTING.md) for what CI checks.

## License

MIT - see [LICENSE](LICENSE).
