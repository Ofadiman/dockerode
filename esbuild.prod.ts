import { buildSync } from "esbuild";

buildSync({
  bundle: true,
  drop: ["console", "debugger"],
  entryPoints: ["src/main.ts"],
  format: "cjs",
  ignoreAnnotations: true,
  minify: true,
  outfile: "dist/main.cjs",
  platform: "node",
  treeShaking: true,
});
