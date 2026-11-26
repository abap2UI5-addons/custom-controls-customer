#!/usr/bin/env node
/*
 * build-example - turn this checkout into the branch `example`: the template
 * as one real customer filled it in, built from the folder example/ of main.
 *
 *   example/<path>        copied over <path> (css/icons.css, css/style.css,
 *                         the example app under src/00)
 *   example/icons.json    its `icons` become ICONS of app/webapp/cc/Extension.js,
 *                         its `stylesheets` are added to STYLESHEETS - the code
 *                         of Extension.js stays main's, so the two cannot drift
 *   example/README.md     put on top of README.md
 *
 * Then example/ itself is removed and `npm run app2bsp` regenerates src/01.
 * The workflow build-example.yaml runs it on every push to main and
 * force-pushes the result to `example`; never commit to `example` by hand.
 *
 *   node tools/build-example.mjs        (changes the working tree)
 */
import { cpSync, existsSync, readFileSync, readdirSync, rmSync, statSync, writeFileSync } from "node:fs";
import { join, relative } from "node:path";
import { execFileSync } from "node:child_process";

const ROOT = new URL("..", import.meta.url).pathname;
const EX = join(ROOT, "example");
const SKIP = new Set(["icons.json", "README.md"]);

function copyTree(dir) {
  for (const name of readdirSync(dir)) {
    const from = join(dir, name);
    const rel = relative(EX, from);
    if (statSync(from).isDirectory()) copyTree(from);
    else if (!SKIP.has(rel)) cpSync(from, join(ROOT, rel));
  }
}
copyTree(EX);

const ext = join(ROOT, "app/webapp/cc/Extension.js");
let js = readFileSync(ext, "utf8");
const cfg = JSON.parse(readFileSync(join(EX, "icons.json"), "utf8"));
const icons = /const ICONS = \[[\s\S]*?\n {4}\];/;
if (!icons.test(js)) throw new Error("Extension.js: no `const ICONS = [ ... ];` block");
const body = JSON.stringify(cfg.icons, null, 2).split("\n").map((l) => `    ${l}`).join("\n").trimStart();
js = js.replace(icons, `const ICONS = ${body};`);
const sheets = /const STYLESHEETS = \[([^\]]*)\];/;
if (!sheets.test(js)) throw new Error("Extension.js: no `const STYLESHEETS = [ ... ];` line");
js = js.replace(sheets, (_, list) =>
  `const STYLESHEETS = [${[list.trim(), ...cfg.stylesheets.map((s) => `Util.url("${s}")`)].filter(Boolean).join(", ")}];`);
writeFileSync(ext, js);

const readme = join(ROOT, "README.md");
const note = readFileSync(join(EX, "README.md"), "utf8").trimEnd();
const text = readFileSync(readme, "utf8");
const at = text.indexOf("\n**A template repository");
if (at < 0) throw new Error("README.md: no '**A template repository' paragraph to put the note above");
writeFileSync(readme, `${text.slice(0, at + 1)}${note}\n\n${text.slice(at + 1)}`);

rmSync(EX, { recursive: true });
execFileSync("npm", ["run", "--silent", "app2bsp"], { cwd: ROOT, stdio: "inherit" });
if (!existsSync(join(ROOT, "src/01/z2ui5_ccc.wapa.css_-icons.css"))) throw new Error("app2bsp wrote no icons.css page");
console.log("build-example: done - this tree is the branch example");
