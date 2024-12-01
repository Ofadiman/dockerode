import { buildSync } from "esbuild";

buildSync({
  bundle: false,
  entryPoints: ["src/main.ts"],
  format: "cjs",
  outfile: "dist/main.cjs",
  platform: "node",
});
