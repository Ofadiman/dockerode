import { buildSync } from "esbuild";

buildSync({
  entryPoints: ["src/main.ts"],
  bundle: true,
  format: "cjs",
  platform: "node",
  outfile: "dist/main.cjs",
});
