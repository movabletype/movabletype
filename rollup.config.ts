// rollup.config.js
import { existsSync, readdirSync } from "node:fs";
import resolve from "@rollup/plugin-node-resolve";
import commonjs from "@rollup/plugin-commonjs";
import esbuild from "rollup-plugin-esbuild";
import livereload from "rollup-plugin-livereload";
import sveltePreprocess from "svelte-preprocess";
import typescript from "@rollup/plugin-typescript";
import svelte from "rollup-plugin-svelte";
import { resolve as pathResolve, dirname } from "path";
import { fileURLToPath } from "node:url";

const production = !process.env.ROLLUP_WATCH;
const defaultOutputDir = "mt-static/js/build";

const mtStaticOutputDir = "mt-static";
const mtStaticInputFiles = [
  "src/mt-static/plugins/TinyMCE6/lib/js/tinymce/plugins/mt_protect/plugin.ts",
  ...readdirSync("src/mt-static/plugins/DashboardWidgetTemplate/js")
    .filter((file) => file.endsWith(".ts"))
    .map((file) => `src/mt-static/plugins/DashboardWidgetTemplate/js/${file}`),
];
const __dirname = dirname(fileURLToPath(import.meta.url));

const resolveSrc = () => ({
  name: "resolve-src",
  resolveId(source) {
    if (source.startsWith("src/")) {
      const base = pathResolve(__dirname, source);
      for (const ext of ["", ".ts", ".js", ".svelte"]) {
        if (existsSync(base + ext)) return base + ext;
      }
    }
    return null;
  },
});

const srcConfig = (inputFile, output = {}) => {
  return {
    input: [inputFile],
    output: {
      dir: defaultOutputDir,
      entryFileNames: inputFile.replace(/^src\//, "").replace(/ts$/, "js"),
      format: "esm",
      sourcemap: !production,
      ...output,
    },
    plugins: [
      resolve({
        browser: true,
        dedupe: ["svelte"],
      }),
      commonjs(),
      esbuild({
        sourceMap: true,
        minify: production,
      }),
      svelte({
        preprocess: sveltePreprocess({ sourceMap: !production }),
        compilerOptions: {
          // enable run-time checks when not in production
          dev: !production,
        },
      }),
      // Watch the `public` directory and refresh the
      // browser on changes when not in production
      !production && livereload(defaultOutputDir),

      // Resolve "src/" imports instead of @rollup/plugin-typescript (outDir issue)
      resolveSrc(),
    ],
  };
};

const mtStaticConfig = (inputfile) => {
  return {
    input: inputfile,
    output: {
      file: inputfile.replace(/^src\//, "").replace(/ts$/, "js"),
      format: "iife",
      sourcemap: !production,
    },
    plugins: [
      resolve({
        browser: true,
      }),
      commonjs(),
      esbuild({
        sourceMap: true,
        minify: production,
      }),

      // Watch the `public` directory and refresh the
      // browser on changes when not in production
      !production && livereload(mtStaticOutputDir),

      // Resolve "src/" imports instead of @rollup/plugin-typescript (outDir issue)
      resolveSrc(),
    ],
  };
};

export default [
  srcConfig("src/contenttype.ts"),
  srcConfig("src/listing.ts"),
  srcConfig("src/dashboard.ts"),
  srcConfig("src/edit-author.ts"),
  srcConfig("src/admin2025/admin-ui.ts"),
  srcConfig("src/admin2025/admin-ui-immediate.ts", {
    format: "iife",
  }),
  ...mtStaticInputFiles.map(mtStaticConfig),
];
