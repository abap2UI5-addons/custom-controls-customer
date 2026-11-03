---
layout: home

hero:
  name: "Custom Controls (customer)"
  text: "Template for your own controls, icon fonts and CSS, in your own BSP."
  image:
    src: /favicon.png
    alt: abap2UI5
  actions:
    - theme: brand
      text: Get started
      link: /guide
    - theme: alt
      text: GitHub
      link: https://github.com/abap2UI5-addons/custom-controls-customer
    - theme: alt
      text: All addons
      link: https://abap2ui5-addons.github.io/

features:
  - title: "Registers resource roots, UI5 reuse libraries, icon fonts and stylesheets at page level"
  - title: "Replaces the four framework patches that a framework update would overwrite"
  - title: "Template custom control Example.js and ABAP class z2ui5_cl_ccc with xmlns( ) and render( )"
  - title: "npm run app2bsp generates the abapGit BSP artefacts; CI fails on a stale BSP"
  - title: "Keeps an existing reuse-library BSP in place, registered by one entry"
  - title: "Check app z2ui5_cl_ccc_sample_00 verifies the installation"
---

## What it does

A template repository for a company's own frontend artefacts in abap2UI5: a UI5 reuse library, an icon font, corporate CSS or a custom control, served from the BSP Z2UI5_CCC under the resourceRoot z2ui5_ccc that abap2UI5 reserves. Fork it, put your files under app/webapp/, declare resource roots, libraries, icon fonts and stylesheets in cc/Extension.js, run npm run app2bsp and install the result with abapGit. Nothing in abap2UI5 or its frontend BSP has to be patched, so the artefacts survive framework updates. Use it for things only your company needs; generally useful controls belong in abap2UI5-addons/custom-controls.

## Requirements

- Standard ABAP 7.50 or higher
- NetWeaver 7.02 - 7.40: the downported branch 702
- abap2UI5 in a version that reserves the z2ui5_ccc resourceRoot
- abap2UI5/frontend (the frontend BSP) when running in BSP or launchpad mode

## Installation

With [abapGit](https://abapgit.org), from [the repository](https://github.com/abap2UI5-addons/custom-controls-customer):

- Install with abapGit in this order: abap2UI5 (and abap2UI5/frontend for BSP or launchpad mode), then your fork of this repository (branch main)
- Fork or copy the repository first and put your artefacts under app/webapp/, then run npm run app2bsp and commit
- Brings the ABAP classes, the BSP application Z2UI5_CCC and the two ICF nodes it is served from
- Start ?app_start=z2ui5_cl_ccc_sample_00: if the badge renders, is styled and reacts to a click, the BSP is deployed
- Binary files such as fonts cannot be BSP pages: use base64 data URIs in CSS or MIME objects

The [Guide](/guide) has every step.

## A first app

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

## Links

- [abap2UI5-addons/custom-controls](https://github.com/abap2UI5-addons/custom-controls)
- [abap2UI5/frontend](https://github.com/abap2UI5/frontend)
- [abap2UI5/samples](https://github.com/abap2UI5/samples)
- [abap2UI5](https://github.com/abap2UI5/abap2UI5)
- [The repository](https://github.com/abap2UI5-addons/custom-controls-customer) - issues and pull requests welcome
