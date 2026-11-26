> **This is the branch `example`: a real customer example, kept to look at.**
> It is the template as one customer filled it in - built automatically from
> the folder [`example/`](https://github.com/abap2UI5-addons/custom-controls-customer/tree/main/example)
> of `main` on every push, always `main` plus one commit:
>
> - their icon font "my-icons" as a base64 data URI in
>   [`app/webapp/css/icons.css`](app/webapp/css/icons.css), its 30 icon names in
>   `ICONS` of [`app/webapp/cc/Extension.js`](app/webapp/cc/Extension.js)
> - their stylesheet (row colours, column-sort headers, phone padding) in
>   [`app/webapp/css/style.css`](app/webapp/css/style.css), scoped to the CSS
>   class `customerApp` their views carry
> - an app that uses all of it:
>   [`z2ui5_cl_ccc_sample_01`](src/00/z2ui5_cl_ccc_sample_01.clas.abap)
>   (`?app_start=z2ui5_cl_ccc_sample_01`)
>
> Do not install it - fork `main` and add your own files the same way.
